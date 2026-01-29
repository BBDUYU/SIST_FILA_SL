package products;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.JdbcUtil;

import categories.CategoriesDTO; 

public class ProductsDAO {

    // 싱글톤 패턴
    private static ProductsDAO instance = new ProductsDAO();
    public static ProductsDAO getInstance() { return instance; }
    public ProductsDAO() {}

    // -----------------------------------------------------------
    // 1. 상품 전체 목록 조회 (전체보기용)
    // -----------------------------------------------------------
    public List<ProductsDTO> selectAllProducts(Connection conn) throws SQLException {
        List<ProductsDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = 
                "SELECT P.*, I.IMAGE_URL, " +
                "       (SELECT NAME FROM ( " +
                "            SELECT NAME, LEVEL as LVL " +
                "            FROM CATEGORIES " +
                "            START WITH CATEGORY_ID = P.CATEGORY_ID " +
                "            CONNECT BY PRIOR PARENT_ID = CATEGORY_ID " +
                "            ORDER BY LVL DESC " + // 가장 높은 조상(DEPTH 1)이 1번으로 오게 함
                "        ) WHERE ROWNUM = 1) as DEPTH1_NAME, " + 
                "       (SELECT M.VALUE_NAME FROM OPTION_VALUE_MASTERS M " +
                "        JOIN PRODUCT_OPTION_VALUES V ON M.V_MASTER_ID = V.V_MASTER_ID " +
                "        JOIN PRODUCT_OPTION_GROUPS G ON V.OPTION_GROUP_ID = G.OPTION_GROUP_ID " +
                "        WHERE G.PRODUCT_ID = P.PRODUCT_ID AND G.MASTER_ID = 2 AND ROWNUM = 1) as TAG_NAME, " +
                "       NVL(R.REVIEW_COUNT, 0) as REVIEW_COUNT, " +
                "       NVL(R.AVG_RATING, 0.0) as AVG_RATING, " +
                "       NVL(W.WISH_COUNT, 0) as WISH_COUNT " +
                "FROM PRODUCTS P " +
                "LEFT JOIN PRODUCT_IMAGE I ON P.PRODUCT_ID = I.PRODUCT_ID AND I.IS_MAIN = 1 " +
                "LEFT JOIN ( " +
                "    SELECT PRODUCT_ID, COUNT(*) as REVIEW_COUNT, ROUND(AVG(RATING), 1) as AVG_RATING " +
                "    FROM REVIEW GROUP BY PRODUCT_ID " +
                ") R ON P.PRODUCT_ID = R.PRODUCT_ID " +
                "LEFT JOIN ( " +
                "    SELECT PRODUCT_ID, COUNT(*) as WISH_COUNT " +
                "    FROM WISHLIST GROUP BY PRODUCT_ID " +
                ") W ON P.PRODUCT_ID = W.PRODUCT_ID " +
                "ORDER BY P.CREATED_AT DESC";

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(makeDTO(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    } 

    // -----------------------------------------------------------
    // 2. 카테고리별 상품 목록 조회
    // -----------------------------------------------------------
    public List<ProductsDTO> selectProductsByCategory(Connection conn, int cateId) {
        List<ProductsDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = 
                "SELECT P.*, I.IMAGE_URL, " +
                "       (SELECT NAME FROM CATEGORIES WHERE CATEGORY_ID = (SELECT PARENT_ID FROM CATEGORIES WHERE CATEGORY_ID = P.CATEGORY_ID)) as DEPTH1_NAME, " +
                "       (SELECT M.VALUE_NAME FROM OPTION_VALUE_MASTERS M " +
                "        JOIN PRODUCT_OPTION_VALUES V ON M.V_MASTER_ID = V.V_MASTER_ID " +
                "        JOIN PRODUCT_OPTION_GROUPS G ON V.OPTION_GROUP_ID = G.OPTION_GROUP_ID " +
                "        WHERE G.PRODUCT_ID = P.PRODUCT_ID AND G.MASTER_ID = 2 AND ROWNUM = 1) as TAG_NAME, " +
                "       NVL(R.REVIEW_COUNT, 0) as REVIEW_COUNT, " +
                "       NVL(R.AVG_RATING, 0.0) as AVG_RATING, " +
                "       NVL(W.WISH_COUNT, 0) as WISH_COUNT " +
                "FROM PRODUCTS P " +
                "LEFT JOIN PRODUCT_IMAGE I ON P.PRODUCT_ID = I.PRODUCT_ID AND I.IS_MAIN = 1 " +
                "LEFT JOIN ( " +
                "    SELECT PRODUCT_ID, COUNT(*) as REVIEW_COUNT, ROUND(AVG(RATING), 1) as AVG_RATING " +
                "    FROM REVIEW GROUP BY PRODUCT_ID " +
                ") R ON P.PRODUCT_ID = R.PRODUCT_ID " +
                "LEFT JOIN ( " +
                "    SELECT PRODUCT_ID, COUNT(*) as WISH_COUNT " +
                "    FROM WISHLIST GROUP BY PRODUCT_ID " +
                ") W ON P.PRODUCT_ID = W.PRODUCT_ID " +
                "WHERE P.CATEGORY_ID IN ( " +
                "    SELECT CATEGORY_ID FROM CATEGORIES " +
                "    START WITH CATEGORY_ID = ? CONNECT BY PRIOR CATEGORY_ID = PARENT_ID " +
                ") " +
                "ORDER BY P.CREATED_AT DESC";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cateId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ProductsDTO dto = new ProductsDTO();
                dto.setProduct_id(rs.getString("PRODUCT_ID"));
                dto.setName(rs.getString("NAME"));
                dto.setPrice(rs.getInt("PRICE"));
                dto.setDiscount_rate(rs.getInt("DISCOUNT_RATE"));
                dto.setImage_url(rs.getString("IMAGE_URL")); 
                
                // 추가된 필드들
                dto.setDepth1_name(rs.getString("DEPTH1_NAME"));
                dto.setTag_name(rs.getString("TAG_NAME"));
                dto.setReview_count(rs.getInt("REVIEW_COUNT"));
                dto.setReview_score(rs.getDouble("AVG_RATING"));
                dto.setLike_count(rs.getInt("WISH_COUNT"));
                
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
        }
        return list;
    }

    // -----------------------------------------------------------
    // 3. 최상위 카테고리 이름 가져오기
    // -----------------------------------------------------------
    public String getRootCategoryName(Connection conn, int categoryId) throws SQLException {
        String name = "";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = " SELECT NAME FROM CATEGORIES WHERE DEPTH = 1 "
                   + " START WITH CATEGORY_ID = ? CONNECT BY PRIOR PARENT_ID = CATEGORY_ID ";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();
            if (rs.next()) name = rs.getString(1);
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return name;
    }
    
    // -----------------------------------------------------------
    // 4. 현재 카테고리 이름 가져오기
    // -----------------------------------------------------------
    public String getCategoryName(Connection conn, int categoryId) throws SQLException {
        String name = "";
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = " SELECT NAME FROM CATEGORIES WHERE CATEGORY_ID = ? ";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();
            if (rs.next()) name = rs.getString(1);
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return name;
    }

    // -----------------------------------------------------------
    // 5. 상품 상세 정보 조회
    // -----------------------------------------------------------
    public ProductsDTO getProduct(Connection conn, String productId) throws SQLException {
        ProductsDTO dto = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = " SELECT P.PRODUCT_ID, P.NAME, P.PRICE, P.DISCOUNT_RATE, P.STATUS, P.DESCRIPTION, P.CREATED_AT, P.CATEGORY_ID, I.IMAGE_URL "
                   + " FROM PRODUCTS P LEFT JOIN PRODUCT_IMAGE I ON P.PRODUCT_ID = I.PRODUCT_ID AND I.IS_MAIN = 1 "
                   + " WHERE P.PRODUCT_ID = ? ";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = makeDTO(rs);
                try { dto.setDescription(rs.getString("DESCRIPTION")); } catch(Exception e) {}
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return dto;
    }

    // -----------------------------------------------------------
    // 6. 상품 옵션 조회
    // -----------------------------------------------------------
    public List<ProductsOptionDTO> getProductOptions(Connection conn, String productId) throws SQLException {
        List<ProductsOptionDTO> options = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 쿼리 설명: 
        // 1. POC(조합) 테이블에서 시작해서 실제 사이즈 이름(OVM)까지 조인합니다.
        // 2. MASTER_ID가 1(성별), 2(스포츠), 3(색상)인 것은 제외하고 나머지만 가져옵니다. (4, 5, 6, 7, 8번이 모두 사이즈임)
        String sql = " SELECT DISTINCT POC.COMBINATION_ID, OVM.VALUE_NAME, NVL(POS.STOCK, 0) AS STOCK "
                   + " FROM PRODUCT_OPTION_COMBINATIONS POC "
                   + " JOIN PRODUCT_OPTION_COMBI_VALUES POCV ON POC.COMBINATION_ID = POCV.COMBINATION_ID "
                   + " JOIN PRODUCT_OPTION_VALUES POV ON POCV.VALUE_ID = POV.VALUE_ID "
                   + " JOIN OPTION_VALUE_MASTERS OVM ON POV.V_MASTER_ID = OVM.V_MASTER_ID "
                   + " LEFT JOIN PRODUCT_OPTION_STOCK POS ON POC.COMBINATION_ID = POS.COMBINATION_ID "
                   + " WHERE POC.PRODUCT_ID = ? "
                   + " AND OVM.MASTER_ID NOT IN (1, 2, 3) " // 성별, 스포츠, 색상 제외 = 사이즈만 남음
                   + " ORDER BY OVM.VALUE_NAME ASC "; // 사이즈 순서대로 정렬

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ProductsOptionDTO dto = new ProductsOptionDTO();
                dto.setCombinationId(rs.getInt("COMBINATION_ID"));
                dto.setOptionValue(rs.getString("VALUE_NAME"));
                dto.setStock(rs.getInt("STOCK"));
                options.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return options;
    }
    // -----------------------------------------------------------
    // 7. 카테고리별 상품 개수 세기
    // -----------------------------------------------------------
    public int getProductCount(Connection conn, int categoryId) {
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = " SELECT COUNT(*) FROM PRODUCTS WHERE CATEGORY_ID IN ( "
                   + "     SELECT CATEGORY_ID FROM CATEGORIES "
                   + "     START WITH CATEGORY_ID = ? CONNECT BY PRIOR CATEGORY_ID = PARENT_ID "
                   + " ) ";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return count;
    }

    // [헬퍼] DTO 생성
    private ProductsDTO makeDTO(ResultSet rs) throws SQLException {
        ProductsDTO dto = new ProductsDTO();
        
        // 1. 기본 정보
        dto.setProduct_id(rs.getString("PRODUCT_ID"));
        dto.setName(rs.getString("NAME"));
        dto.setPrice(rs.getInt("PRICE"));
        dto.setDiscount_rate(rs.getInt("DISCOUNT_RATE"));
        dto.setStatus(rs.getString("STATUS"));
        dto.setCreated_at(rs.getDate("CREATED_AT"));
        dto.setCategory_id(rs.getInt("CATEGORY_ID")); 
        
        // 2. 이미지 (없으면 기본 이미지)
        String img = rs.getString("IMAGE_URL");
        if(img == null) img = "//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS261FT01X001_234.jpg"; 
        dto.setImage_url(img);
        
        // 3. 통계 및 이름 ('의류' 등이 DEPTH1_NAME으로 들어감)
        try {
            dto.setDepth1_name(rs.getString("DEPTH1_NAME")); 
            dto.setTag_name(rs.getString("TAG_NAME"));     
            dto.setReview_count(rs.getInt("REVIEW_COUNT"));
            dto.setReview_score(rs.getDouble("AVG_RATING"));
            dto.setLike_count(rs.getInt("WISH_COUNT"));
        } catch (SQLException e) {
            // 컬럼이 없는 쿼리일 경우 무시
        }
        
        return dto;
    }
    
    // -----------------------------------------------------------
    // ★ [추가] 상품의 태그(스포츠/라이프스타일 등) 가져오기
    // -----------------------------------------------------------
    public String getProductTag(Connection conn, String productId, int masterId) throws SQLException {
        String tagName = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        // 1. 상품 옵션 그룹(PRODUCT_OPTION_GROUPS)에서 해당 상품의 옵션을 찾고
        // 2. 그 옵션의 값(OPTION_VALUE_MASTERS)을 가져오는 쿼리 (JOIN 사용)
        String sql = " SELECT M.VALUE_NAME "
                   + " FROM OPTION_VALUE_MASTERS M "
                   + " JOIN PRODUCT_OPTION_VALUES V ON M.V_MASTER_ID = V.V_MASTER_ID "
                   + " JOIN PRODUCT_OPTION_GROUPS G ON V.OPTION_GROUP_ID = G.OPTION_GROUP_ID "
                   + " WHERE G.PRODUCT_ID = ? AND G.MASTER_ID = ? ";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            pstmt.setInt(2, masterId); // 2번이 '스포츠' 카테고리라고 가정
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                tagName = rs.getString("VALUE_NAME");
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return tagName;
    }
    
   /* 상세 컬러 메서드 컷~!!~!~!~
    * // 같은 이름의 상품(다른 색상)들 가져오기 public List<ProductsDTO>
    * selectColorVariants(Connection conn, String productName) { List<ProductsDTO>
    * list = new ArrayList<>(); PreparedStatement pstmt = null; ResultSet rs =
    * null; // 리스트 페이지처럼 이미지를 가져오도록 조인 추가 String sql =
    * " SELECT P.PRODUCT_ID, I.IMAGE_URL FROM PRODUCTS P " +
    * " LEFT JOIN PRODUCT_IMAGE I ON P.PRODUCT_ID = I.PRODUCT_ID AND I.IS_MAIN = 1 "
    * + " WHERE P.NAME = ? ORDER BY P.PRODUCT_ID ASC "; try { pstmt =
    * conn.prepareStatement(sql); pstmt.setString(1, productName); rs =
    * pstmt.executeQuery(); while (rs.next()) { ProductsDTO dto = new
    * ProductsDTO(); dto.setProduct_id(rs.getString("PRODUCT_ID"));
    * dto.setImage_url(rs.getString("IMAGE_URL")); // 이미지 URL 추가! list.add(dto); }
    * } catch (Exception e) { e.printStackTrace(); } finally { JdbcUtil.close(rs);
    * JdbcUtil.close(pstmt); } // 제공된 JdbcUtil 사용 return list; }
    */
 // ProductsDAO.java 에 추가
    public List<ProductsDTO> selectProductsBySearch(Connection conn, String searchItem) throws SQLException {
        List<ProductsDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 카테고리 계층형 쿼리를 제거하고 상품명(NAME)으로 검색하는 단순 쿼리
        String sql = 
                "SELECT P.*, I.IMAGE_URL, " +
                "       NVL(R.REVIEW_COUNT, 0) as REVIEW_COUNT, " +
                "       NVL(R.AVG_RATING, 0.0) as AVG_RATING " +
                "FROM PRODUCTS P " +
                "LEFT JOIN PRODUCT_IMAGE I ON P.PRODUCT_ID = I.PRODUCT_ID AND I.IS_MAIN = 1 " +
                "LEFT JOIN ( " +
                "    SELECT PRODUCT_ID, COUNT(*) as REVIEW_COUNT, ROUND(AVG(RATING), 1) as AVG_RATING " +
                "    FROM REVIEW GROUP BY PRODUCT_ID " +
                ") R ON P.PRODUCT_ID = R.PRODUCT_ID " +
                "WHERE P.NAME LIKE ? " + // 검색어 필터링
                "ORDER BY P.CREATED_AT DESC";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + searchItem + "%"); // 포함된 단어 찾기
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(makeDTO(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
}