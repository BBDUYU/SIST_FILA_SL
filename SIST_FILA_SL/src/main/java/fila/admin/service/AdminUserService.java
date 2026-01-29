package fila.admin.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import fila.admin.domain.UserInfoDTO;
import fila.admin.persistence.UserInfoDAO;
import fila.com.util.ConnectionProvider;
import fila.com.util.JdbcUtil;

public class AdminUserService {
    private AdminUserService() {}
    private static AdminUserService instance = new AdminUserService();
    public static AdminUserService getInstance() { return instance; }

    public ArrayList<UserInfoDTO> getUserList() {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            UserInfoDAO dao = UserInfoDAO.getInstance();
            return dao.selectUserList(conn);
        } catch (Exception e) {
            throw new RuntimeException("회원 목록 로드 실패", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
    public UserInfoDTO getUserDetail(int userNum) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            UserInfoDAO dao = UserInfoDAO.getInstance();
            UserInfoDTO user = dao.selectOne(conn, userNum);
            
            // 2. 포인트 내역 추가로 가져오기
            if (user != null) {
                ArrayList<UserInfoDTO> pointList = dao.selectPointList(conn, userNum);
                user.setPointList(pointList); // DTO에 List<UserInfoDTO> pointList 필드 추가 필요
            }
            return user;
        } catch (Exception e) {
            throw new RuntimeException("회원 상세 정보 로드 실패", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
    public UserInfoDTO getMyPageSummary(int userNum) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            UserInfoDAO dao = UserInfoDAO.getInstance();
            
            // 1. 기본 정보 조회 (잔액 포함)
            UserInfoDTO summary = dao.selectOne(conn, userNum);
            
            // 2. 각 항목 개수 세팅 (UserInfoDTO에 필드가 있다고 가정)
            if (summary != null) {
                summary.setCouponCount(dao.getCouponCount(conn, userNum));
                summary.setWishCount(dao.getWishCount(conn, userNum));
                summary.setOrderCount(dao.getOrderCount(conn, userNum));
            }
            return summary;
        } catch (Exception e) {
            throw new RuntimeException("요약 정보 조회 실패", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
    
}