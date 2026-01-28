package mypage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.util.JdbcUtil;

public class WishListDAO {

    private static WishListDAO instance = new WishListDAO();
    public static WishListDAO getInstance() { return instance; }
    public WishListDAO() {}

    // -----------------------------------------------------------
    // 1) 위시리스트 목록
    // -----------------------------------------------------------
    public List<WishListDTO> selectWishListByUser(Connection conn, int userNumber) throws SQLException {

        List<WishListDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
            "SELECT " +
            "  W.WISHLIST_ID, W.USER_NUMBER, W.PRODUCT_ID, W.SIZE_TEXT, W.CREATED_AT, " +
            "  P.NAME AS PRODUCT_NAME, P.PRICE, NVL(P.DISCOUNT_RATE,0) AS DISCOUNT_RATE, " +
            "  I.IMAGE_URL " +
            "FROM WISHLIST W " +
            "JOIN PRODUCTS P ON W.PRODUCT_ID = P.PRODUCT_ID " +
            "LEFT JOIN PRODUCT_IMAGE I ON P.PRODUCT_ID = I.PRODUCT_ID AND I.IS_MAIN = 1 " +
            "WHERE W.USER_NUMBER = ? " +
            "ORDER BY W.CREATED_AT DESC, W.WISHLIST_ID DESC";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNumber);
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

    private WishListDTO makeDTO(ResultSet rs) throws SQLException {

        WishListDTO dto = new WishListDTO();

        dto.setWishlist_id(rs.getInt("WISHLIST_ID"));
        dto.setUser_number(rs.getInt("USER_NUMBER"));
        dto.setProduct_id(rs.getString("PRODUCT_ID"));
        dto.setCreated_at(rs.getDate("CREATED_AT"));
        dto.setSize_text(rs.getString("SIZE_TEXT")); // ✅ 사이즈 표시용

        dto.setProduct_name(rs.getString("PRODUCT_NAME"));
        dto.setPrice(rs.getInt("PRICE"));
        dto.setDiscount_rate(rs.getInt("DISCOUNT_RATE"));

        String img = rs.getString("IMAGE_URL");
        if (img == null) img = "//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS261FT01X001_234.jpg";
        dto.setImage_url(img);

        return dto;
    }

    // -----------------------------------------------------------
    // 2) 위시 추가 (✅ 이걸 메인으로 사용)
    // - sizeText는 null일 수 있음 (null이면 DB도 null 저장)
    // - 같은 상품을 이미 찜했으면 0 리턴
    // -----------------------------------------------------------
    public int insertWish(Connection conn, int userNumber, String productId, String sizeText) throws SQLException {

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 1) 중복 체크
            String dupSql = "SELECT 1 FROM WISHLIST WHERE USER_NUMBER = ? AND PRODUCT_ID = ?";
            pstmt = conn.prepareStatement(dupSql);
            pstmt.setInt(1, userNumber);
            pstmt.setString(2, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) return 0;

            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);

            // 2) INSERT (✅ SIZE_TEXT 포함)
            String sql =
                "INSERT INTO WISHLIST (WISHLIST_ID, USER_NUMBER, PRODUCT_ID, CREATED_AT, SIZE_TEXT) " +
                "VALUES (SEQ_WISHLIST.NEXTVAL, ?, ?, SYSDATE, ?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNumber);
            pstmt.setString(2, productId);
            pstmt.setString(3, sizeText); // null 가능

            return pstmt.executeUpdate();

        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }

    // -----------------------------------------------------------
    // 3) (구버전) insertWish(productId만) → 이제 쓰지 말 것
    // -----------------------------------------------------------
    @Deprecated
    public int insertWish(Connection conn, int userNumber, String productId) throws SQLException {
        return insertWish(conn, userNumber, productId, null);
    }

    // -----------------------------------------------------------
    // 4) 단건 삭제
    // -----------------------------------------------------------
    public int deleteOne(Connection conn, int userNumber, int wishlistId) throws SQLException {
        String sql = "DELETE FROM WISHLIST WHERE WISHLIST_ID = ? AND USER_NUMBER = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wishlistId);
            ps.setInt(2, userNumber);
            return ps.executeUpdate();
        }
    }

    // -----------------------------------------------------------
    // 5) 선택 삭제
    // -----------------------------------------------------------
    public int deleteSelected(Connection conn, int userNumber, List<Integer> ids) throws SQLException {
        if (ids == null || ids.isEmpty()) return 0;

        StringBuilder sb = new StringBuilder();
        sb.append("DELETE FROM WISHLIST WHERE USER_NUMBER = ? AND WISHLIST_ID IN (");
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
        sb.append(")");

        try (PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            int idx = 1;
            ps.setInt(idx++, userNumber);
            for (Integer id : ids) ps.setInt(idx++, id);
            return ps.executeUpdate();
        }
    }
    
    // -----------------------------------------------------------
    // 6) product_detail에서 wishlist 삭제 (하트 토글용)
    // -----------------------------------------------------------
    public int deleteByProduct(Connection conn, int userNumber, String productId) throws SQLException {
        String sql = "DELETE FROM WISHLIST WHERE USER_NUMBER = ? AND PRODUCT_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userNumber);
            ps.setString(2, productId);
            return ps.executeUpdate();
        }
    }
    
	 // -----------------------------------------------------------
	 // 7) 상세페이지: 이 상품이 찜 상태인지 체크
	 // -----------------------------------------------------------
	 public boolean existsByProduct(Connection conn, int userNumber, String productId) throws SQLException {
	     String sql = "SELECT 1 FROM WISHLIST WHERE USER_NUMBER = ? AND PRODUCT_ID = ?";
	     try (PreparedStatement ps = conn.prepareStatement(sql)) {
	         ps.setInt(1, userNumber);
	         ps.setString(2, productId);
	         try (ResultSet rs = ps.executeQuery()) {
	             return rs.next();
	         }
	     }
	 }
	 
	 // -----------------------------------------------------------
	 // 8) 유저가 찜한 상품ID 목록
	 // -----------------------------------------------------------
	 public List<String> selectWishedProductIds(Connection conn, int userNumber) throws SQLException {
	     List<String> ids = new ArrayList<>();
	     String sql = "SELECT PRODUCT_ID FROM WISHLIST WHERE USER_NUMBER = ?";

	     try (PreparedStatement ps = conn.prepareStatement(sql)) {
	         ps.setInt(1, userNumber);
	         try (ResultSet rs = ps.executeQuery()) {
	             while (rs.next()) {
	                 ids.add(rs.getString("PRODUCT_ID"));
	             }
	         }
	     }
	     return ids;
	 }

}