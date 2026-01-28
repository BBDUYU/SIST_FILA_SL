package admin.service;

import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import admin.domain.CreateproductDTO;
import admin.persistence.CreateproductDAO;
import style.StyleDAO;

public class ProductService {
	private ProductService() {}
	private static ProductService instance = new ProductService();
	public static ProductService getInstance() { return instance; }

	private CreateproductDAO dao = CreateproductDAO.getInstance();
	private StyleDAO styleDao = StyleDAO.getInstance();
	// 1. 등록 폼에 필요한 데이터 로드
	public Map<Integer, List<Map<String, Object>>> getProductFormData() {
		try (Connection conn = ConnectionProvider.getConnection()) {
			return dao.selectAllOptions(conn);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}


	public void createProduct(CreateproductDTO product, String[] categoryIds, String[] tagIds,
			String genderOption, String sportOption, String[] sizeOptions,
			ArrayList<CreateproductDTO> imageList,
			int styleId, int sectionId, int stock) {
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false); 

			dao.insertProduct(conn, product);
			dao.insertCategoryRelations(conn, product.getProduct_id(), categoryIds,genderOption);
			if (tagIds != null && tagIds.length > 0) {
	            // 기존에 만든 insertCategoryRelations를 재활용하거나, 태그 전용을 호출
	            dao.insertCategoryRelations(conn, product.getProduct_id(), tagIds, null); 
	        }
			dao.insertProductOptions(conn, product.getProduct_id(), genderOption, sportOption, sizeOptions);
			dao.insertDefaultStock(conn, product.getProduct_id(), sizeOptions, stock);            
			if (imageList != null && !imageList.isEmpty()) {
				dao.insertProductImages(conn, imageList);
			}

			if (styleId > 0) dao.insertStyleProduct(conn, product.getProduct_id(), styleId);
			if (sectionId > 0) dao.insertEventProduct(conn, product.getProduct_id(), sectionId);

			conn.commit(); 
		} catch (Exception e) {
			JdbcUtil.rollback(conn);
			e.printStackTrace();
			throw new RuntimeException(e);
		} finally {
			JdbcUtil.close(conn);
		}
	}
	public void getAdminFullFormData(javax.servlet.http.HttpServletRequest request) {
		try (Connection conn = ConnectionProvider.getConnection()) {
			// 1. 기존 옵션 데이터 (스포츠, 사이즈 등)
			request.setAttribute("options", dao.selectAllOptions(conn));
			// 2. 스타일 리스트 추가
			request.setAttribute("styleList", styleDao.selectStyleList(conn));            
			// 3. 이벤트 섹션 리스트 추가
			request.setAttribute("eventSectionList", dao.selectActiveEventSections(conn));

		} catch (Exception e) {
			throw new RuntimeException("폼 데이터 로드 중 오류 발생", e);
		}
	}
	// 수정 페이지용 데이터 로드
	public CreateproductDTO getProductDetail(String productId) {
		try (Connection conn = ConnectionProvider.getConnection()) {
			return dao.selectProductById(conn, productId);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	// 상품 수정 프로세스
	// ProductService.java
	public void updateProduct(CreateproductDTO dto, List<CreateproductDTO> newImages, String[] deleteImageIds, 
	        String[] categoryIds, String[] tagIds, String genderOption, String sportOption, String[] sizeOptions, 
	        int styleId, int sectionId, int stock) {
	    Connection conn = null;
	    try {
	        conn = ConnectionProvider.getConnection();
	        conn.setAutoCommit(false);

	        // 1. 기본 정보 업데이트
	        dao.updateProduct(conn, dto);

	        // 2. 사용자가 'X' 눌러서 넘긴 이미지만 정확히 삭제
	        if (deleteImageIds != null && deleteImageIds.length > 0) {
	            List<String> pathsToDelete = dao.getImagePathsByIds(conn, deleteImageIds);
	            for (String path : pathsToDelete) {
	            	String cleanPath = path.replace("\\", "/").trim();
	                File file = new File(cleanPath);
	                if (file.exists()) {
	                    if(file.delete()) {
	                        System.out.println("✅ 물리 파일 삭제 성공!");
	                    }
	                } else {
	                    System.out.println("❌ 파일 없음: " + cleanPath);
	                }
	            }
	            dao.deleteSpecificImages(conn, deleteImageIds);
	        }

	        // 3. 새 이미지 추가 등록
	        if (newImages != null && !newImages.isEmpty()) { // isEmpty 체크 추가
	            for (CreateproductDTO img : newImages) {
	                String url = img.getImage_url();
	                if (url.contains("path=")) {
	                    url = url.split("path=")[1];
	                }
	                url = url.replace("/", "\\").replace("C:C:", "C:");
	                img.setImage_url(url);
	            }
	            // 여기서 새 이미지만 DB에 추가 (기존 이미지는 가만히 둠)
	            dao.insertProductImages(conn, newImages); 
	        }

	        // 4. 연관 데이터 동기화 (이미지 제외)
	        // [주의] dao.deleteRelatedData 내부에 이미지를 지우는 SQL이 있다면 반드시 제거하세요!
	        dao.deleteRelatedData(conn, dto.getProduct_id()); 

	        dao.insertCategoryRelations(conn, dto.getProduct_id(), categoryIds, genderOption);
	        if (tagIds != null && tagIds.length > 0) {
	            dao.insertCategoryRelations(conn, dto.getProduct_id(), tagIds, null);
	        }
	        dao.insertProductOptions(conn, dto.getProduct_id(), genderOption, sportOption, sizeOptions);
	        dao.insertDefaultStock(conn, dto.getProduct_id(), sizeOptions, stock);

	        if (styleId > 0) dao.insertStyleProduct(conn, dto.getProduct_id(), styleId);
	        if (sectionId > 0) dao.insertEventProduct(conn, dto.getProduct_id(), sectionId);

	        conn.commit();
	    } catch (Exception e) {
	        JdbcUtil.rollback(conn);
	        e.printStackTrace();
	        throw new RuntimeException("수정 실패: " + e.getMessage());
	    } finally {
	        JdbcUtil.close(conn);
	    }
	}

	public void deleteProduct(String productId) {
		Connection conn = null;
		try {
			conn = ConnectionProvider.getConnection();
			conn.setAutoCommit(false);

			// 실제 삭제 대신 상태값만 변경
			dao.updateProductStatusDeleted(conn, productId);

			conn.commit();
		} catch (Exception e) {
			JdbcUtil.rollback(conn);
			throw new RuntimeException("상품 상태 변경 중 오류 발생: " + e.getMessage());
		} finally {
			JdbcUtil.close(conn);
		}
	}
	// ProductService.java


	// 이미지를 가져오는 메서드를 별도로 활용 (핸들러에서 호출용)
	public ArrayList<CreateproductDTO> getProductImages(String productId) {
		try (Connection conn = ConnectionProvider.getConnection()) {
			return CreateproductDAO.getInstance().selectImagesByProductId(conn, productId);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	// ProductService.java 내부에 추가/수정 권장

	// 기존 선택된 카테고리 리스트 가져오기
	public List<Map<String, Object>> getProductCategories(String productId) {
		try (Connection conn = ConnectionProvider.getConnection()) {
			return dao.selectProductCategories(conn, productId); // DAO에 해당 쿼리 구현 필요
		} catch (Exception e) {
			throw new RuntimeException(e); 
		}
	}

	// 기존 선택된 사이즈 ID 리스트 가져오기
	public List<Integer> getProductSizeIds(String productId) {
		try (Connection conn = ConnectionProvider.getConnection()) {
			return dao.selectProductSizeIds(conn, productId); // DAO에 해당 쿼리 구현 필요
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}