package admin.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import admin.domain.StyleDTO;
import admin.domain.StyleImageDTO;
import admin.domain.StyleProductDTO;
import admin.persistence.StyleDAO;

public class StyleService {
    private static StyleService instance = new StyleService();
    public static StyleService getInstance() { return instance; }
    private StyleService() {}

    private StyleDAO styleDAO = StyleDAO.getInstance();

    public List<StyleDTO> getActiveStyleList() {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            
            // 1. 활성화된(USE_YN=1) 스타일 마스터 목록 조회
            List<StyleDTO> styleList = styleDAO.selectActiveStyleList(conn);
            
            // 2. 각 스타일 객체 내부에 전체 이미지 리스트(슬라이더용)를 채움
            if (styleList != null) {
                for (StyleDTO style : styleList) {
                    List<StyleImageDTO> allImages = styleDAO.selectStyleImages(conn, style.getStyle_id());
                    style.setImages(allImages); // DTO의 images 필드에 저장
                }
            }
            return styleList;
        } catch (SQLException | NamingException e) {
            e.printStackTrace();
            return null;
        } finally {
            JdbcUtil.close(conn);
        }
    }
    
    
    public boolean registerStyle(StyleDTO styleDto, List<StyleImageDTO> imageList, List<StyleProductDTO> productList) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection(); 
            conn.setAutoCommit(false); 

            int styleId = styleDAO.insertStyle(conn, styleDto);
            
            if (styleId > 0) {
                for (StyleImageDTO img : imageList) {
                    img.setStyle_id(styleId);
                    styleDAO.insertStyleImage(conn, img);
                }
                
                for (StyleProductDTO prod : productList) {
                    prod.setStyle_id(styleId);
                    styleDAO.insertStyleProduct(conn, prod);
                }
                
                conn.commit(); 
                return true;
            }
            return false;
        } catch (SQLException | javax.naming.NamingException e) { // NamingException 추가
            if (conn != null) JdbcUtil.rollback(conn); 
            e.printStackTrace();
            return false;
        } finally {
            JdbcUtil.close(conn);
        }
    }
 // StyleService.java
    public int registerStyleMaster(StyleDTO dto) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return styleDAO.insertStyle(conn, dto);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public void registerStyleDetails(int styleId, List<StyleImageDTO> images, String[] productIds) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            
            // 1. 이미지 정보 저장
            for (StyleImageDTO img : images) {
                styleDAO.insertStyleImage(conn, img);
            }
            
            // 2. 상품 매칭 정보 저장
            if (productIds != null) {
                for (int i = 0; i < productIds.length; i++) {
                    StyleProductDTO spDto = new StyleProductDTO();
                    spDto.setStyle_id(styleId);
                    spDto.setProduct_id(productIds[i]);
                    spDto.setSort_order(i + 1);
                    styleDAO.insertStyleProduct(conn, spDto);
                }
            }
            conn.commit();
        } catch (Exception e) {
            JdbcUtil.rollback(conn);
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }
    }
 // 1. 스타일 기본 정보 조회
    public StyleDTO getStyleDetail(int styleId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return styleDAO.selectStyleDetail(conn, styleId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 2. 스타일 이미지 리스트 조회
    public List<StyleImageDTO> getStyleImages(int styleId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return styleDAO.selectStyleImages(conn, styleId);
        } catch (Exception e) { 
            e.printStackTrace();
            return null;
        }
    }

    // 3. 현재 매칭된 상품 ID들만 조회 (수정 폼 체크박스용)
    public List<String> getMatchedProductIds(int styleId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            // StyleDAO에 이 메서드도 추가되어야 합니다 (아래 참고)
            return styleDAO.selectMatchedProductIds(conn, styleId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 4. 스타일 수정 통합 처리 (핵심 로직)
    public void updateStyleComplete(StyleDTO styleDto, List<StyleImageDTO> newImages, String[] productIds, boolean hasNewImages) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // (1) 마스터 정보 수정 (이름, 설명, 사용여부)
            styleDAO.updateStyle(conn, styleDto);

            // (2) 이미지 업데이트 (새 파일이 들어온 경우만)
            if (hasNewImages) {
                // 기존 DB 이미지 정보 삭제
                styleDAO.deleteStyleImages(conn, styleDto.getStyle_id());
                // 새 이미지 정보 저장
                for (StyleImageDTO img : newImages) {
                    styleDAO.insertStyleImage(conn, img);
                }
            }

            // (3) 상품 매칭 업데이트 (기존 삭제 후 재등록)
            styleDAO.deleteStyleProducts(conn, styleDto.getStyle_id());
            if (productIds != null && productIds.length > 0) {
                for (int i = 0; i < productIds.length; i++) {
                    StyleProductDTO spDto = new StyleProductDTO();
                    spDto.setStyle_id(styleDto.getStyle_id());
                    spDto.setProduct_id(productIds[i]);
                    spDto.setSort_order(i + 1);
                    styleDAO.insertStyleProduct(conn, spDto);
                }
            }

            conn.commit(); // 모든 과정 성공 시 커밋
        } catch (Exception e) {
            JdbcUtil.rollback(conn); // 하나라도 실패 시 전체 롤백
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }
    }
 // StyleService.java 내부 예시
    public StyleDTO getStyleFullDetail(int styleId) throws Exception {
        // StyleDAO 인스턴스 가져오기 (싱글톤 방식)
        StyleDAO styleDAO = StyleDAO.getInstance();
        
        try (Connection conn = ConnectionProvider.getConnection()) {
            // 1. 기본 스타일 정보 로드 (메서드명: selectStyleDetail)
            StyleDTO style = styleDAO.selectStyleDetail(conn, styleId); 
            
            if (style != null) {
                // 2. 스타일 이미지 리스트 로드 (메서드명: selectStyleImages)
                style.setImages(styleDAO.selectStyleImages(conn, styleId));
                
                // 3. 스타일에 포함된 상품 상세 리스트 로드 (메서드명: selectStyleProductDetails)
                List<StyleProductDTO> products = styleDAO.selectStyleProductDetails(conn, styleId);
                
                // 4. 각 상품별로 선택 가능한 사이즈 목록 채우기
                for (StyleProductDTO product : products) {
                    List<String> sizes = styleDAO.getProductSizes(conn, product.getProduct_id());
                    product.setSizeOptions(sizes); 
                }
                
                style.setProducts(products);
            }
            
            return style;
        }
    }
    public List<StyleDTO> getStyleList() {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            // 아까 만든 DAO의 selectStyleList 호출 (WHERE 조건 없는 쿼리)
            return styleDAO.selectStyleList(conn);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            JdbcUtil.close(conn);
        }
    }

    // 2. 상태 변경 (Toggle) 처리
    public boolean updateStyleStatus(int id, int status) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            // 서비스에서는 DAO에 커넥션과 데이터를 넘겨줍니다.
            int result = styleDAO.updateStyleStatus(conn, id, status);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            JdbcUtil.close(conn);
        }
    }
    
    
}