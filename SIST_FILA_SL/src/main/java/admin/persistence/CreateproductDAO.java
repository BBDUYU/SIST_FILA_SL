package admin.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



import admin.domain.CreateproductDTO;

public class CreateproductDAO {

	private static CreateproductDAO dao = null;
	private CreateproductDAO() {}
	public static CreateproductDAO getInstance() {
		if (dao == null) dao = new CreateproductDAO();
		return dao;
	}

	/**
	 * 1단계: 카테고리에 맞는 새로운 Product ID 생성
	 */
	public String generateProductId(Connection conn, int categoryId) {
		String productId = "";
		String sequenceName = "";

		if (categoryId == 10 || (categoryId >= 1000 && categoryId < 2000)) {
			sequenceName = "seq_prod_women";
		} else if (categoryId == 20 || (categoryId >= 2000 && categoryId < 3000)) {
			sequenceName = "seq_prod_men";
		} else if (categoryId == 30 || (categoryId >= 3000 && categoryId < 4000)) {
			sequenceName = "seq_prod_kids";
		} else {
			sequenceName = "seq_prod_women"; 
		}

		String sql = "SELECT 'PROD' || " + sequenceName + ".NEXTVAL FROM DUAL";

		try (PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {
			if (rs.next()) {
				productId = rs.getString(1);
			}
		} catch (Exception e) {
			throw new RuntimeException("DB 작업 중 에러 발생: " + e.getMessage(), e);
		}
		return productId;
	}

	public int insertProduct(Connection conn, CreateproductDTO dto) {
		int result = 0;
		String sql = "INSERT INTO PRODUCTS (product_id, category_id, name, description, price, "
				+ "view_count, created_at, updated_at, status, discount_rate) "
				+ "VALUES (?, ?, ?, ?, ?, 0, SYSDATE, SYSDATE, ?, ?)";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, dto.getProduct_id());
			pstmt.setInt(2, dto.getCategory_id());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getDescription());
			pstmt.setInt(5, dto.getPrice());

			// 2. 상태값(status) 판별 로직
			// 할인율이 0보다 크면 'SALE', 아니면 'NORMAL' (또는 null)
			String status = "NORMAL";
			if (dto.getDiscount_rate() > 0) {
				status = "SALE";
			}

			pstmt.setString(6, status); // 9번째 ? (status)
			pstmt.setInt(7, dto.getDiscount_rate()); // 10번째 ? (discount_rate)

			result = pstmt.executeUpdate();
		} catch (Exception e) {
			throw new RuntimeException("DB 작업 중 에러 발생: " + e.getMessage(), e);
		}
		return result;
	}


	public int[] insertProductImages(Connection conn, List<CreateproductDTO> imgList) {
	    int[] results = null;
	    String sql = "INSERT INTO product_image (product_image_id, product_id, image_url, "
	            + "image_type, is_main, sort_order) "
	            + "VALUES (prod_img_seq.NEXTVAL, ?, ?, ?, ?, ?)";

	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        for (CreateproductDTO img : imgList) {
	            pstmt.setString(1, img.getProduct_id());
	            
	            // [수정] 가상 경로가 포함되어 있다면 제거하고 순수 경로만 저장
	            String url = img.getImage_url();
	            if (url != null && url.contains("path=")) {
	                url = url.split("path=")[1];
	            }
	            pstmt.setString(2, url); // "C:/fila_upload/..." 형태만 저장
	            
	            pstmt.setString(3, img.getImage_type());
	            pstmt.setInt(4, img.getIs_main());
	            pstmt.setInt(5, img.getSort_order());
	            pstmt.addBatch();
	        }
	        results = pstmt.executeBatch();
	    } catch (Exception e) {
	        throw new RuntimeException("이미지 저장 에러: " + e.getMessage(), e);
	    }
	    return results;
	}
	// 파라미터에 String genderOption 추가
	public void insertCategoryRelations(Connection conn, String productId, String[] categoryIds, String genderOption) {
		String sql = "INSERT INTO PRODUCT_CATEGORY_REL (REL_ID, PRODUCT_ID, CATEGORY_ID) "
				+ "VALUES (REL_SEQ.NEXTVAL, ?, ?)";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			// 1. 성별 카테고리(10, 20, 30) 강제 추가
			if (genderOption != null && !genderOption.isEmpty()) {
				pstmt.setString(1, productId);
				pstmt.setInt(2, Integer.parseInt(genderOption));
				pstmt.addBatch();
				System.out.println("성별 카테고리 추가됨: " + genderOption); // 디버깅용
			}

			// 2. 나머지 하위 카테고리들 추가
			if (categoryIds != null) {
				for (String catId : categoryIds) {
					if (catId == null || catId.trim().isEmpty()) continue;
					// 성별과 중복 방지
					if (catId.equals(genderOption)) continue; 

					pstmt.setString(1, productId);
					pstmt.setInt(2, Integer.parseInt(catId));
					pstmt.addBatch();
				}
			}
			pstmt.executeBatch();
		} catch (Exception e) {
			throw new RuntimeException("카테고리 저장 에러: " + e.getMessage(), e);
		}
	}
	public Map<Integer, List<Map<String, Object>>> selectAllOptions(Connection conn) throws SQLException {
		Map<Integer, List<Map<String, Object>>> optionsMap = new HashMap<>();

		String sql = "SELECT MASTER_ID, V_MASTER_ID, VALUE_NAME FROM OPTION_VALUE_MASTERS ORDER BY MASTER_ID, V_MASTER_ID";

		try (PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				int masterId = rs.getInt("MASTER_ID");
				Map<String, Object> val = new HashMap<>();
				val.put("v_master_id", rs.getInt("V_MASTER_ID"));
				val.put("value_name", rs.getString("VALUE_NAME"));

				// 해당 MasterID 리스트가 없으면 새로 생성, 있으면 추가
				optionsMap.computeIfAbsent(masterId, k -> new ArrayList<>()).add(val);
			}
		}
		return optionsMap;
	}
	/**
	 * 2단계: 상품 옵션 그룹 및 상세 값 저장 (12, 13번 테이블)
	 */
	public void insertProductOptions(Connection conn, String productId, String genderOption, String sportOption, String[] sizeOptions) throws SQLException {
		String sqlNextGroup = "SELECT SEQ_OPTION_GROUP.NEXTVAL FROM DUAL";
		String sqlGroup = "INSERT INTO PRODUCT_OPTION_GROUPS (OPTION_GROUP_ID, PRODUCT_ID, MASTER_ID, OPTION_NAME) VALUES (?, ?, ?, ?)";
		String sqlValue = "INSERT INTO PRODUCT_OPTION_VALUES (VALUE_ID, OPTION_GROUP_ID, V_MASTER_ID, VALUE_NAME) VALUES (SEQ_OPTION_VALUE.NEXTVAL, ?, ?, ?)";

		// 마스터 이름과 값 이름을 가져오기 위한 쿼리
		String sqlGetMasterName = "SELECT OPTION_NAME FROM OPTION_MASTERS WHERE MASTER_ID = ?";
		String sqlGetValueName = "SELECT VALUE_NAME FROM OPTION_VALUE_MASTERS WHERE V_MASTER_ID = ?";

		try (PreparedStatement pstmtSeq = conn.prepareStatement(sqlNextGroup);
				PreparedStatement pstmtGroup = conn.prepareStatement(sqlGroup);
				PreparedStatement pstmtValue = conn.prepareStatement(sqlValue);
				PreparedStatement pstmtMName = conn.prepareStatement(sqlGetMasterName);
				PreparedStatement pstmtVName = conn.prepareStatement(sqlGetValueName)) {



			// --- 2. 스포츠 옵션 (MASTER_ID: 2) ---
			if (sportOption != null) {
				insertSingleOption(pstmtSeq, pstmtGroup, pstmtValue, pstmtMName, pstmtVName, productId, 2, sportOption);
			}

			// --- 3. 사이즈 옵션 (MASTER_ID: 4~8 판별) ---
			if (sizeOptions != null) {
				int sizeMasterId = 4; // 기본 남성
				if (productId.startsWith("PROD1")) sizeMasterId = 5;      // 여성 의류
				else if (productId.startsWith("PROD3")) sizeMasterId = 6; // 아동 의류
				// 신발 카테고리 체크 로직 추가 가능 (예: category_id 확인)

				long gId = getNextSeq(pstmtSeq);

				// MASTER_ID 5인 경우 "여성 의류 사이즈" 라는 이름을 DB에서 가져옴
				pstmtMName.setInt(1, sizeMasterId);
				String masterName = "";
				try (ResultSet rs = pstmtMName.executeQuery()) { if (rs.next()) masterName = rs.getString(1); }

				pstmtGroup.setLong(1, gId);
				pstmtGroup.setString(2, productId);
				pstmtGroup.setInt(3, sizeMasterId);
				pstmtGroup.setString(4, masterName); // "여성 의류 사이즈" 저장
				pstmtGroup.executeUpdate();

				for (String vId : sizeOptions) {
					pstmtVName.setInt(1, Integer.parseInt(vId));
					String valueName = "";
					try (ResultSet rs = pstmtVName.executeQuery()) { if (rs.next()) valueName = rs.getString(1); }

					pstmtValue.setLong(1, gId);
					pstmtValue.setInt(2, Integer.parseInt(vId));
					pstmtValue.setString(3, valueName); // "095", "100" 등 저장
					pstmtValue.executeUpdate();
				}
			}
		}
	}

	private void insertSingleOption(PreparedStatement seq, PreparedStatement grp, PreparedStatement val, 
			PreparedStatement mName, PreparedStatement vName, 
			String pId, int mId, String vId) throws SQLException {
		long gId = getNextSeq(seq);

		mName.setInt(1, mId);
		String mNm = "";
		try (ResultSet rs = mName.executeQuery()) { if (rs.next()) mNm = rs.getString(1); }

		grp.setLong(1, gId);
		grp.setString(2, pId);
		grp.setInt(3, mId);
		grp.setString(4, mNm);
		grp.executeUpdate();

		vName.setInt(1, Integer.parseInt(vId));
		String vNm = "";
		try (ResultSet rs = vName.executeQuery()) { if (rs.next()) vNm = rs.getString(1); }

		val.setLong(1, gId);
		val.setInt(2, Integer.parseInt(vId));
		val.setString(3, vNm);
		val.executeUpdate();
	}

	private long getNextSeq(PreparedStatement seq) throws SQLException {
		try (ResultSet rs = seq.executeQuery()) { if (rs.next()) return rs.getLong(1); }
		return 0;
	}



	public void insertDefaultStock(Connection conn, String productId, String[] sizeOptions, int stock) throws SQLException {
		// 14번 테이블: 상품 옵션 조합
		String sqlCombi = "INSERT INTO PRODUCT_OPTION_COMBINATIONS (COMBINATION_ID, PRODUCT_ID) VALUES (SEQ_COMBINATION.NEXTVAL, ?)";

		// 16번 테이블: 재고 (기존 하드코딩된 10 대신 ? 사용)
		String sqlStock = "INSERT INTO PRODUCT_OPTION_STOCK (STOCK_ID, COMBINATION_ID, STORE_ID, STOCK, IS_SOLDOUT) VALUES (SEQ_STOCK.NEXTVAL, ?, 4, ?, ?)";

		// 15번 테이블(Combi_Value) 연결을 위한 VALUE_ID 조회 쿼리
		String sqlFindValueId = "SELECT VALUE_ID FROM PRODUCT_OPTION_VALUES v " +
				"JOIN PRODUCT_OPTION_GROUPS g ON v.OPTION_GROUP_ID = g.OPTION_GROUP_ID " +
				"WHERE g.PRODUCT_ID = ? AND v.V_MASTER_ID = ?";

		try (PreparedStatement pstmtCombi = conn.prepareStatement(sqlCombi, new String[]{"COMBINATION_ID"});
		PreparedStatement pstmtStock = conn.prepareStatement(sqlStock);
		PreparedStatement pstmtFind = conn.prepareStatement(sqlFindValueId)) {

			if (sizeOptions != null) {
				for (String vId : sizeOptions) {
					// 1. 조합(Combination) 생성
					pstmtCombi.setString(1, productId);
					pstmtCombi.executeUpdate();

					long combiId = 0;
					try (ResultSet rs = pstmtCombi.getGeneratedKeys()) {
						if (rs.next()) combiId = rs.getLong(1);
					}

					// 2. 재고(Stock) 등록
					if (combiId > 0) {
						pstmtStock.setLong(1, combiId);
						pstmtStock.setInt(2, stock); // 사용자가 입력한 재고 수량 설정
						pstmtStock.setInt(3, stock > 0 ? 0 : 1); // 0개면 품절(1) 처리
						pstmtStock.executeUpdate();

						// 3. 15번 테이블 PRODUCT_OPTION_COMBI_VALUES 채우기
						// 미리 등록된 VALUE_ID를 찾아서 조합(combiId)과 맵핑
						pstmtFind.setString(1, productId);
						pstmtFind.setInt(2, Integer.parseInt(vId));

						try (ResultSet rs = pstmtFind.executeQuery()) {
							if (rs.next()) {
								long valueId = rs.getLong("VALUE_ID");
								String sqlCV = "INSERT INTO PRODUCT_OPTION_COMBI_VALUES (VALUE_ID, COMBINATION_ID) VALUES (?, ?)";
								try (PreparedStatement pstmtCV = conn.prepareStatement(sqlCV)) {
									pstmtCV.setLong(1, valueId);
									pstmtCV.setLong(2, combiId);
									pstmtCV.executeUpdate();
								}
							}
						}
					}
				}
			}
		}
	}

	public void insertStyleProduct(Connection conn, String productId, int styleId) throws SQLException {
		String sql = "INSERT INTO STYLE_PRODUCT (PRODUCT_ID, STYLE_ID, SORT_ORDER) VALUES (?, ?, 1)";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, productId);
			pstmt.setInt(2, styleId);
			pstmt.executeUpdate();
		}
	}

	public void insertEventProduct(Connection conn, String productId, int sectionId) throws SQLException {
		String sql = "INSERT INTO EVENT_PRODUCT (PRODUCT_ID, SECTION_ID) VALUES (?, ?)";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, productId);
			pstmt.setInt(2, sectionId);
			pstmt.executeUpdate();
		}
	}

	public List<Map<String, Object>> selectActiveEventSections(Connection conn) throws SQLException {
		List<Map<String, Object>> list = new ArrayList<>();
		String sql = "SELECT e.EVENT_NAME, s.SECTION_ID " +
				"FROM EVENT e JOIN EVENT_SECTION s ON e.EVENT_ID = s.EVENT_ID " +
				"WHERE e.IS_ACTIVE = 1 ORDER BY e.EVENT_ID, s.SORT_ORDER";
		try (PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("name", rs.getString("EVENT_NAME") + " - 섹션 " + rs.getInt("SECTION_ID"));
				map.put("sectionId", rs.getInt("SECTION_ID"));
				list.add(map);
			}
		}
		return list;
	}
	public List<Map<String, Object>> selectStyleList(Connection conn) throws SQLException {
		List<Map<String, Object>> list = new ArrayList<>();
		// USE_YN이 1(사용중)인 스타일만 가져옴
		String sql = "SELECT STYLE_ID, STYLE_NAME FROM STYLE WHERE USE_YN = 1 ORDER BY STYLE_ID DESC";
		try (PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {
			while (rs.next()) {
				java.util.Map<String, Object> map = new java.util.HashMap<>();
				map.put("styleId", rs.getInt("STYLE_ID"));
				map.put("styleName", rs.getString("STYLE_NAME"));
				list.add(map);
			}
		}
		return list;
	}
	// 특정 상품의 기본 정보 조회
	public CreateproductDTO selectProductById(Connection conn, String productId) throws SQLException {
	    String sql = "SELECT p.*, " +
	            // 🚩 ROWNUM = 1을 추가하여 여러 개가 있어도 첫 번째 값만 가져옵니다.
	            "(SELECT STYLE_ID FROM STYLE_PRODUCT WHERE PRODUCT_ID = p.PRODUCT_ID AND ROWNUM = 1) as STYLE_ID, " +
	            "(SELECT SECTION_ID FROM EVENT_PRODUCT WHERE PRODUCT_ID = p.PRODUCT_ID AND ROWNUM = 1) as SECTION_ID, " +
	            "c.NAME as GENDER_NAME, c.CATEGORY_ID as GENDER_ID, " +
	            "(SELECT NAME FROM CATEGORIES WHERE CATEGORY_ID = " +
	                "(SELECT PARENT_ID FROM CATEGORIES WHERE CATEGORY_ID = p.CATEGORY_ID)) as CAT_TYPE, " +
	            "(SELECT SUM(STOCK) FROM PRODUCT_OPTION_STOCK pos " +
	            " JOIN PRODUCT_OPTION_COMBINATIONS poc ON pos.COMBINATION_ID = poc.COMBINATION_ID " +
	            " WHERE poc.PRODUCT_ID = p.PRODUCT_ID) as TOTAL_STOCK, " +
	            "(SELECT POV.V_MASTER_ID FROM PRODUCT_OPTION_VALUES POV " +
	            " JOIN PRODUCT_OPTION_GROUPS POG ON POV.OPTION_GROUP_ID = POG.OPTION_GROUP_ID " +
	            " WHERE POG.PRODUCT_ID = p.PRODUCT_ID AND POG.MASTER_ID = 2 AND ROWNUM = 1) as SPORT_ID " +
	            "FROM PRODUCTS p " +
	            "JOIN CATEGORIES c ON p.CATEGORY_ID = c.CATEGORY_ID " + 
	            "WHERE p.PRODUCT_ID = ?";

	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, productId);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                return CreateproductDTO.builder()
	                        .product_id(rs.getString("PRODUCT_ID"))
	                        .category_id(rs.getInt("CATEGORY_ID"))
	                        .name(rs.getString("NAME"))
	                        .description(rs.getString("DESCRIPTION"))
	                        .price(rs.getInt("PRICE"))
	                        .discount_rate(rs.getInt("DISCOUNT_RATE"))
	                        .style_id(rs.getInt("STYLE_ID"))
	                        .section_id(rs.getInt("SECTION_ID"))
	                        .sport_option_id(rs.getInt("SPORT_ID"))
	                        .stock(rs.getInt("TOTAL_STOCK"))
	                        .gender_name(rs.getString("GENDER_NAME"))
	                        .gender_option_id(rs.getInt("GENDER_ID"))
	                        .category_type(rs.getString("CAT_TYPE"))
	                        .build();
	            }
	        }
	    }
	    return null;
	}
	// 수정 처리 (기본 정보 업데이트)
	// CreateproductDAO.java
	// 이 메서드가 반드시 이 형태(Connection, DTO)로 정의되어 있어야 합니다.
	public void updateProduct(Connection conn, CreateproductDTO product) throws SQLException {
	    String sql = "UPDATE products SET name=?, description=?, price=?, discount_rate=? WHERE product_id=?";
	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, product.getName());
	        pstmt.setString(2, product.getDescription());
	        pstmt.setInt(3, product.getPrice());
	        pstmt.setInt(4, product.getDiscount_rate());
	        pstmt.setString(5, product.getProduct_id());
	        pstmt.executeUpdate();
	    }
	}

	// 기존 카테고리/옵션/이미지 삭제 (수정 시 새로 등록하기 위함)
	public void deleteRelatedData(Connection conn, String productId) throws SQLException {
		String[] sqls = {
				// 1. 옵션 조합 상세 값 (가장 하위 자식)
				"DELETE FROM PRODUCT_OPTION_COMBI_VALUES WHERE COMBINATION_ID IN " +
				"(SELECT COMBINATION_ID FROM PRODUCT_OPTION_COMBINATIONS WHERE PRODUCT_ID = ?)",

				// 2. 재고 정보
				"DELETE FROM PRODUCT_OPTION_STOCK WHERE COMBINATION_ID IN " +
				"(SELECT COMBINATION_ID FROM PRODUCT_OPTION_COMBINATIONS WHERE PRODUCT_ID = ?)",

				// 3. 옵션 조합 삭제
				"DELETE FROM PRODUCT_OPTION_COMBINATIONS WHERE PRODUCT_ID = ?",

				// 4. 옵션 값 삭제
				"DELETE FROM PRODUCT_OPTION_VALUES WHERE OPTION_GROUP_ID IN " +
				"(SELECT OPTION_GROUP_ID FROM PRODUCT_OPTION_GROUPS WHERE PRODUCT_ID = ?)",

				// 5. 옵션 그룹 삭제
				"DELETE FROM PRODUCT_OPTION_GROUPS WHERE PRODUCT_ID = ?",

				// 6. (추가된 부분) 카테고리 관계 테이블 삭제
				"DELETE FROM product_category_rel WHERE product_id = ?",

				// 7. 이미지 및 기타 연결 삭제 (단수형 명칭 유지)
				//"DELETE FROM product_image WHERE product_id = ?",
				//"DELETE FROM product_category WHERE product_id = ?",
				"DELETE FROM STYLE_PRODUCT WHERE PRODUCT_ID = ?",
				"DELETE FROM EVENT_PRODUCT WHERE PRODUCT_ID = ?"
		};

		for (String sql : sqls) {
			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setString(1, productId);
				pstmt.executeUpdate();
			} catch (SQLException e) {
				// 테이블이 없거나 이미 지워진 경우 로그만 찍고 다음으로 넘어감
				System.out.println("[삭제 알림] " + sql.split(" ")[2] + " : " + e.getMessage());
			}
		}
	}

	public void deleteSpecificImages(Connection conn, String[] imageIds) throws SQLException {
		if (imageIds == null || imageIds.length == 0) return;

		// ? 를 imageIds 개수만큼 생성 (예: ?, ?, ?)
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < imageIds.length; i++) {
			sb.append("?");
			if (i < imageIds.length - 1) sb.append(",");
		}

		String sql = "DELETE FROM product_image WHERE product_image_id IN (" + sb.toString() + ")";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			for (int i = 0; i < imageIds.length; i++) { // .size() 대신 .length 사용
				pstmt.setString(i + 1, imageIds[i]);
			}
			pstmt.executeUpdate();
		}
	}
	public void updateProductStatusDeleted(Connection conn, String productId) throws SQLException {
		// 주신 스키마의 PRODUCTS 테이블 STATUS 컬럼 활용
		String sql = "UPDATE PRODUCTS SET STATUS = 'DELETED', UPDATED_AT = SYSDATE WHERE PRODUCT_ID = ?";

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, productId);
			pstmt.executeUpdate();
		}
	}
	public ArrayList<CreateproductDTO> selectImagesByProductId(Connection conn, String productId) throws SQLException {
	    String sql = "SELECT * FROM PRODUCT_IMAGE WHERE PRODUCT_ID = ? ORDER BY SORT_ORDER ASC";
	    ArrayList<CreateproductDTO> list = new ArrayList<>();

	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, productId);
	        try (ResultSet rs = pstmt.executeQuery()) { 
	            while (rs.next()) {
	                String rawPath = rs.getString("IMAGE_URL"); // DB값: C:\fila_upload\...
	                
	                // 1. 역슬래시(\)를 슬래시(/)로 통일
	                if (rawPath != null) {
	                    rawPath = rawPath.replace("\\", "/");
	                }

	                // 2. 가상 경로 생성
	                // 여기서 앞에 /SIST_FILA를 붙이지 마세요. (JSP의 ${pageContext.request.contextPath}와 중복됨)
	                String webPath = "/displayImage.do?path=" + rawPath;

	                list.add(CreateproductDTO.builder()
	                        .product_id(rs.getString("PRODUCT_ID"))
	                        .product_image_id(rs.getInt("PRODUCT_IMAGE_ID"))
	                        .image_url(webPath) // 결과: /displayImage.do?path=C:/...
	                        .image_type(rs.getString("IMAGE_TYPE"))
	                        .is_main(rs.getInt("IS_MAIN"))
	                        .sort_order(rs.getInt("SORT_ORDER"))
	                        .build());
	            }
	        }
	    }
	    return list;
	}
	// 1. 해당 상품이 속한 카테고리 정보 가져오기
	public List<Map<String, Object>> selectProductCategories(Connection conn, String productId) throws SQLException {
		String sql = "SELECT CATEGORY_ID FROM PRODUCT_CATEGORY_REL WHERE PRODUCT_ID = ?";
		List<Map<String, Object>> list = new ArrayList<>();

		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, productId);
			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> map = new HashMap<>();
					map.put("CATEGORY_ID", rs.getInt("CATEGORY_ID"));
					list.add(map);
				}
			}
		}
		return list;
	}

	// 2. 해당 상품에 설정된 사이즈(V_MASTER_ID) 리스트 가져오기
	public List<Integer> selectProductSizeIds(Connection conn, String productId) throws SQLException {
		// PRODUCT_OPTION_VALUES 테이블에서 해당 상품의 옵션 그룹에 속한 사이즈 값들을 가져옵니다.
		String sql = "SELECT POV.V_MASTER_ID " +
				"FROM PRODUCT_OPTION_VALUES POV " +
				"JOIN PRODUCT_OPTION_GROUPS POG ON POV.OPTION_GROUP_ID = POG.OPTION_GROUP_ID " +
				"WHERE POG.PRODUCT_ID = ? AND POG.MASTER_ID = (SELECT MASTER_ID FROM OPTION_MASTERS WHERE OPTION_NAME = '사이즈')";

		List<Integer> list = new ArrayList<>();
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, productId);
			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(rs.getInt("V_MASTER_ID"));
				}
			}
		}
		return list;
	}
	// 1. 삭제할 이미지들의 물리적 경로 리스트 가져오기
	public List<String> getImagePathsByIds(Connection conn, String[] imageIds) throws SQLException {
	    if (imageIds == null || imageIds.length == 0) return new ArrayList<>();
	    
	    // IN 연산자를 위한 물음표(?) 생성
	    StringBuilder sql = new StringBuilder("SELECT image_url FROM product_image WHERE product_image_id IN (");
	    for (int i = 0; i < imageIds.length; i++) {
	        sql.append(i == 0 ? "?" : ", ?");
	    }
	    sql.append(")");

	    List<String> paths = new ArrayList<>();
	    try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
	        for (int i = 0; i < imageIds.length; i++) {
	            pstmt.setString(i + 1, imageIds[i]);
	        }
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                // DB에 저장된 경로가 가상 경로라면 물리 경로로 변환 (replace 로직은 본인 환경에 맞게 조정)
	                String path = rs.getString("image_url").replace("/displayImage.do?path=", "");
	                paths.add(path);
	            }
	        }
	    }
	    return paths;
	}

	// 2. 상품 ID에 해당하는 모든 이미지 레코드 DB에서 삭제 (파일은 안지움)
	public void deleteAllImagesByProductId(Connection conn, String productId) throws SQLException {
	    String sql = "DELETE FROM product_image WHERE product_id = ?";
	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, productId);
	        pstmt.executeUpdate();
	    }
	}
}