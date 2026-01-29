package admin.persistence;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import admin.domain.UserInfoDTO;

public interface IUserInfo {
    // 전체 회원 목록 조회
    ArrayList<UserInfoDTO> selectUserList(Connection conn) throws SQLException;
    UserInfoDTO selectOne(Connection conn, int userNum) throws SQLException;
}