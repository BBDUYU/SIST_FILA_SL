package mypage.service;

import java.sql.Connection;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mypage.persistence.WishAddDAO;

public class WishAddService {

    private static WishAddService instance = new WishAddService();
    public static WishAddService getInstance() { return instance; }
    private WishAddService() {}

    public void addWish(int userNumber, String productId) {

        Connection conn = null;

        try {
            conn = ConnectionProvider.getConnection();
            WishAddDAO dao = WishAddDAO.getInstance();

            // 중복 찜 방지
            if (dao.exists(conn, userNumber, productId)) {
                return;
            }

            dao.insert(conn, userNumber, productId);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }
    }
}