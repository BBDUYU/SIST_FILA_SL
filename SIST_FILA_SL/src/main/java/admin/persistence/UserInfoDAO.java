package admin.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import com.util.JdbcUtil;
import admin.domain.UserInfoDTO;

public class UserInfoDAO implements IUserInfo {
    private static UserInfoDAO dao = new UserInfoDAO();
    private UserInfoDAO() {}
    public static UserInfoDAO getInstance() { return dao; }

    @Override
    public ArrayList<UserInfoDTO> selectUserList(Connection conn) throws SQLException {
        ArrayList<UserInfoDTO> list = new ArrayList<>();
        String sql = "SELECT USER_NUMBER, ID, NAME, EMAIL, PHONE, GRADE, STATUS, CREATED_AT FROM USERS ORDER BY CREATED_AT DESC";

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                UserInfoDTO dto = UserInfoDTO.builder()
                        .usernumber(rs.getInt("USER_NUMBER"))
                        .id(rs.getString("ID"))
                        .name(rs.getString("NAME")) // 기획에 따라 필드명 매핑 확인 필요
                        .email(rs.getString("EMAIL"))
                        .phone(rs.getString("PHONE"))
                        .grade(rs.getString("GRADE"))
                        .status(rs.getString("STATUS"))
                        .createAt(rs.getDate("CREATED_AT"))
                        .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    @Override
    public UserInfoDTO selectOne(Connection conn, int userNum) throws SQLException {
        UserInfoDTO userDto = null;
        
        // 1. 회원 기본 정보 조회
        String sqlUser = "SELECT u.*, " +
                " (SELECT NVL(MAX(BALANCE) KEEP (DENSE_RANK LAST ORDER BY POINT_ID), 0) " +
                "  FROM USERPOINTS WHERE USER_NUMBER = u.USER_NUMBER) as CURRENT_BALANCE " +
                "FROM USERS u WHERE u.USER_NUMBER = ?";
        // 2. 해당 회원의 자녀 리스트 조회 (CHILD 테이블)
        String sqlChild = "SELECT CHILD_NAME, CHILD_BIRTH, CHILD_GENDER FROM CHILD WHERE USER_NUMBER = ? ORDER BY CHILD_BIRTH ASC";

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 회원 정보 처리
            pstmt = conn.prepareStatement(sqlUser);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                userDto = UserInfoDTO.builder()
                        .usernumber(rs.getInt("USER_NUMBER"))
                        .name(rs.getString("NAME"))
                        .id(rs.getString("ID"))
                        .email(rs.getString("EMAIL"))
                        .phone(rs.getString("PHONE"))
                        .grade(rs.getString("GRADE"))
                        .status(rs.getString("STATUS"))
                        .createAt(rs.getTimestamp("CREATED_AT"))
                        .gender(rs.getString("GENDER"))
                        .birthday(rs.getDate("BIRTHDAY"))
                        .balance(rs.getInt("CURRENT_BALANCE"))
                        .build();
            }
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);

            // 자녀 정보 처리 (리스트에 담기)
            if (userDto != null) {
                pstmt = conn.prepareStatement(sqlChild);
                pstmt.setInt(1, userNum);
                rs = pstmt.executeQuery();
                
                java.util.List<UserInfoDTO> childList = new java.util.ArrayList<>();
                while (rs.next()) {
                    UserInfoDTO child = new UserInfoDTO();
                    child.setChildname(rs.getString("CHILD_NAME"));
                    child.setChildbirth(rs.getDate("CHILD_BIRTH"));
                    child.setChildgender(rs.getString("CHILD_GENDER"));
                    childList.add(child);
                }
                userDto.setChildList(childList); // DTO에 자녀 리스트 세팅
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return userDto;
    }
    public ArrayList<UserInfoDTO> selectPointList(Connection conn, int userNum) throws SQLException {
        ArrayList<UserInfoDTO> list = new ArrayList<>();
        
        // 테이블명: USERPOINTS, 컬럼명: POINT_TYPE 반영
        String sql = "SELECT POINT_ID, ORDER_ID, POINT_TYPE, AMOUNT, BALANCE, DESCRIPTION, CREATED_AT " +
                     "FROM USERPOINTS " + 
                     "WHERE USER_NUMBER = ? " +
                     "ORDER BY CREATED_AT DESC";

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                UserInfoDTO dto = UserInfoDTO.builder()
                        .pointid(rs.getInt("POINT_ID"))
                        .orderid(rs.getString("ORDER_ID"))
                        .type(rs.getString("POINT_TYPE")) // DB의 POINT_TYPE을 DTO의 type에 매핑
                        .amout(rs.getInt("AMOUNT"))
                        .balance(rs.getInt("BALANCE"))
                        .description(rs.getString("DESCRIPTION"))
                        .createAt(rs.getTimestamp("CREATED_AT"))
                        .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    public int getCouponCount(Connection conn, int userNum) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USER_COUPON " +
                     "WHERE USER_NUMBER = ? AND IS_USED = 0 AND EXPIRE_DATE > SYSDATE";
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userNum);
            rs = pstmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }

 // 1. 위시리스트 개수 조회
    public int getWishCount(Connection conn, int userNum) throws SQLException {
        // 테이블명: WISHLIST, 컬럼명: USER_NUMBER
        String sql = "SELECT COUNT(*) FROM WISHLIST WHERE USER_NUMBER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // 2. 총 주문 건수 조회
    public int getOrderCount(Connection conn, int userNum) throws SQLException {
        // 테이블명: ORDERS, 컬럼명: USER_NUMBER
        String sql = "SELECT COUNT(*) FROM ORDERS WHERE USER_NUMBER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}