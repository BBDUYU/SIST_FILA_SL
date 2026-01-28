package mypage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.util.JdbcUtil;
import admin.domain.UserInfoDTO;

public class UserCouponDAO {
    private static UserCouponDAO dao = new UserCouponDAO();
    private UserCouponDAO() {}
    public static UserCouponDAO getInstance() { return dao; }

    public List<UserInfoDTO> selectMemberCoupons(Connection conn, int userNum) throws SQLException {
        List<UserInfoDTO> list = new ArrayList<>();
        // COUPON 테이블과 USER_COUPON 테이블 조인
        String sql = "SELECT uc.USER_COUPON_ID, uc.COUPON_ID, uc.IS_USED, uc.EXPIRE_DATE, uc.RECEIVED_AT, " +
                     "       c.NAME as COUPON_NAME, c.DISCOUNT_TYPE, c.DISCOUNT_VALUE " +
                     "FROM USER_COUPON uc " +
                     "JOIN COUPON c ON uc.COUPON_ID = c.COUPON_ID " +
                     "WHERE uc.USER_NUMBER = ? " +
                     "ORDER BY uc.RECEIVED_AT DESC";

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                UserInfoDTO dto = UserInfoDTO.builder()
                        .usercouponid(rs.getInt("USER_COUPON_ID"))
                        .couponid(rs.getInt("COUPON_ID"))
                        .isused(rs.getString("IS_USED")) // 0 또는 1
                        .expireddate(rs.getDate("EXPIRE_DATE"))
                        .receivedat(rs.getDate("RECEIVED_AT"))
                        .coupon_name(rs.getString("COUPON_NAME"))
                        .discount_type(rs.getString("DISCOUNT_TYPE"))
                        .price(rs.getInt("DISCOUNT_VALUE")) // 할인금액/율을 price 필드 등에 임시매핑
                        .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
}