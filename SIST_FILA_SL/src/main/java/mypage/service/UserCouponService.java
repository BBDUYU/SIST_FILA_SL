package mypage.service;

import java.sql.Connection;
import java.util.List;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import admin.domain.UserInfoDTO;
import mypage.persistence.UserCouponDAO;

public class UserCouponService {
    private static UserCouponService instance = new UserCouponService();
    public static UserCouponService getInstance() { return instance; }

    public List<UserInfoDTO> getCouponList(int userNum) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return UserCouponDAO.getInstance().selectMemberCoupons(conn, userNum);
        } catch (Exception e) {
            throw new RuntimeException("쿠폰 목록 조회 실패", e);
        }
    }
}