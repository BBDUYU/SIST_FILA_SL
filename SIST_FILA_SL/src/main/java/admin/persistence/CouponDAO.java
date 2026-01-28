package admin.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import admin.domain.CouponDTO;
import admin.domain.UserInfoDTO;

public class CouponDAO {
    private static CouponDAO instance = new CouponDAO();
    public static CouponDAO getInstance() { return instance; }
    private CouponDAO() {}

    public List<CouponDTO> selectList(Connection conn) throws SQLException {

    	String sql = "SELECT * FROM COUPON ORDER BY CREATED_AT DESC";
    	List<CouponDTO> list = new ArrayList<>();
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) { 
                CouponDTO dto = new CouponDTO();
                dto.setCoupon_id(rs.getInt("COUPON_ID"));
                dto.setName(rs.getString("NAME"));
                dto.setDiscount_type(rs.getString("DISCOUNT_TYPE"));
                dto.setDiscount_value(rs.getInt("DISCOUNT_VALUE"));
                dto.setExpires_at(rs.getDate("EXPIRES_AT"));
                dto.setCreated_at(rs.getTimestamp("CREATED_AT"));
                dto.setStatus(rs.getString("STATUS"));
                dto.setSerial_number(rs.getString("SERIAL_NUMBER"));
                list.add(dto);
            }
        }
        return list;
    }
    public int updateStatus(Connection conn, int couponId, String status) throws SQLException {
        String sql = "UPDATE COUPON SET STATUS = ? WHERE COUPON_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, couponId);
            return pstmt.executeUpdate();
        }
    }

    public int insertCoupon(Connection conn, CouponDTO dto) throws SQLException {
        String sql = "INSERT INTO COUPON (COUPON_ID, NAME, DISCOUNT_TYPE, DISCOUNT_VALUE, SERIAL_NUMBER,EXPIRES_AT, CREATED_AT) " +
                     "VALUES (SEQ_COUPON.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dto.getName());
            pstmt.setString(2, dto.getDiscount_type());
            pstmt.setInt(3, dto.getDiscount_value());
            pstmt.setString(4, dto.getSerial_number());
            pstmt.setDate(5, dto.getExpires_at()); // null 허용됨
            return pstmt.executeUpdate();
        }
    }
    public List<UserInfoDTO> getUserCouponList(Connection conn, int userNumber) throws SQLException {
        String sql = "SELECT uc.USER_COUPON_ID, c.NAME, c.DISCOUNT_TYPE, c.DISCOUNT_VALUE, " +
                     "uc.IS_USED, uc.USED_AT, uc.EXPIRE_DATE, uc.RECEIVED_AT, c.STATUS " +
                     "FROM USER_COUPON uc " +
                     "JOIN COUPON c ON uc.COUPON_ID = c.COUPON_ID " +
                     "WHERE uc.USER_NUMBER = ? ORDER BY uc.RECEIVED_AT DESC";
                     
        List<UserInfoDTO> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    UserInfoDTO dto = new UserInfoDTO();
                    dto.setUsercouponid(rs.getInt("USER_COUPON_ID"));
                    dto.setIsused(rs.getString("IS_USED")); // 0:미사용, 1:사용
                    dto.setUsedat(rs.getTimestamp("USED_AT"));
                    dto.setExpireddate(rs.getTimestamp("EXPIRE_DATE"));
                    dto.setReceivedat(rs.getTimestamp("RECEIVED_AT"));
                    
                    dto.setCoupon_name(rs.getString("NAME")); 
                    dto.setDiscount_type(rs.getString("DISCOUNT_TYPE"));
                    dto.setPrice(rs.getInt("DISCOUNT_VALUE")); 
                    dto.setStatus(rs.getString("STATUS"));
                    list.add(dto);
                }
            }
        }
        return list;
    }
 // CouponDAO.java 에 추가
    public int useUserCoupon(Connection conn, int userCouponId) throws SQLException {
        // IS_USED를 '1'로 변경하고 사용 일시를 기록
        String sql = "UPDATE USER_COUPON SET IS_USED = '1', USED_AT = SYSDATE WHERE USER_COUPON_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userCouponId);
            return pstmt.executeUpdate();
        }
    }
}