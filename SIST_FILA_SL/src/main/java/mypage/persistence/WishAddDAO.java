package mypage.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class WishAddDAO {

    private static WishAddDAO instance = new WishAddDAO();
    public static WishAddDAO getInstance() { return instance; }
    private WishAddDAO() {}

    // 중복 체크
    public boolean exists(Connection conn, int userNumber, String productId) throws Exception {
        String sql = "SELECT 1 FROM WISHLIST WHERE USER_NUMBER = ? AND PRODUCT_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userNumber);
            ps.setString(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // INSERT
    public void insert(Connection conn, int userNumber, String productId) throws Exception {
        String sql =
            "INSERT INTO WISHLIST (WISHLIST_ID, USER_NUMBER, PRODUCT_ID, CREATED_AT) " +
            "VALUES (SEQ_WISHLIST.NEXTVAL, ?, ?, SYSDATE)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userNumber);
            ps.setString(2, productId);
            ps.executeUpdate();
        }
    }
}