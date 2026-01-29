package member.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.util.ConnectionProvider;

import member.domain.ChildDTO;
import member.domain.MemberDTO;

public class MemberDAO {

    // --- 싱글톤 패턴 시작 ---
    private static MemberDAO instance = new MemberDAO();

    // 외부에서 new MemberDAO() 못하게 private으로 막음 (선택사항이지만 권장)
    public MemberDAO() {} 

    // 서비스에서 호출할 static 메서드
    public static MemberDAO getInstance() {
        if (instance == null) {
            instance = new MemberDAO();
        }
        return instance;
    }
    // --- 싱글톤 패턴 끝 ---

    // ✅ 일반 로그인
    public MemberDTO login(String id, String pw) {
        // 💡 필요한 모든 컬럼을 SELECT 문에 포함해야 합니다.
    	String sql = "SELECT user_number, id, name, email, phone, birthday, gender, status " +
                "FROM users " +
                "WHERE id = ? AND password = ? AND status = 'ACTIVE'";
        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    MemberDTO dto = new MemberDTO();
                    dto.setUserNumber(rs.getInt("user_number"));
                    dto.setId(rs.getString("id"));
                    dto.setName(rs.getString("name"));
                    dto.setEmail(rs.getString("email"));      
                    dto.setPhone(rs.getString("phone"));     
                    dto.setBirthday(rs.getString("birthday")); 
                    dto.setGender(rs.getString("gender"));   
                    dto.setStatus(rs.getString("status"));
                    return dto;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }


 // ✅ 회원가입
    public int insert(MemberDTO dto) {

        int result = 0;

        String sql =
            "INSERT INTO USERS ( " +
            " USER_NUMBER, ID, PASSWORD, NAME, EMAIL, PHONE, " +
            " BIRTHDAY, GENDER, ROLE, STATUS, GRADE, CREATED_AT, UPDATED_AT, KAKAO_ID " +
            ") VALUES ( " +
            " SEQ_USERS.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, SYSDATE, NULL " +
            ")";

        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, dto.getId());
            pstmt.setString(2, dto.getPassword());
            pstmt.setString(3, dto.getName());
            pstmt.setString(4, dto.getEmail());
            pstmt.setString(5, dto.getPhone());
            pstmt.setDate(6, java.sql.Date.valueOf(dto.getBirthday()));
            pstmt.setString(7, dto.getGender());
            pstmt.setString(8, dto.getRole());
            pstmt.setString(9, dto.getStatus());
            pstmt.setString(10, dto.getGrade());

            result = pstmt.executeUpdate();

            System.out.println("▶ USERS INSERT ROW = " + result);
            System.out.println("ID=" + dto.getId());
            System.out.println("EMAIL=" + dto.getEmail());
            System.out.println("BIRTHDAY=" + dto.getBirthday());

            

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }



 // ✅ 아이디 중복확인
    public boolean isDuplicateId(String id) {
        String sql = "SELECT COUNT(*) FROM users WHERE id = ?";

        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // true = 이미 존재
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // 1. 이메일 업데이트

    public void updateEmail(Connection conn, int userNum, String email) throws SQLException {
        String sql = "UPDATE USERS SET EMAIL = ?, UPDATED_AT = SYSDATE WHERE USER_NUMBER = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setInt(2, userNum);
            pstmt.executeUpdate();
        }
    }

 // ✅ 이름+휴대폰으로 아이디 찾기
    public String findIdByNameAndPhone(String name, String phone) {

        String sql =
            "SELECT id FROM users " +
            "WHERE name = ? AND REPLACE(phone, '-', '') = ?";

        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, name);
            pstmt.setString(2, phone.replace("-", ""));

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


  
    public boolean updatePassword(String id, String newPw) {

        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, newPw);
            pstmt.setString(2, id);

            return pstmt.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 // ✅ 이름 + 휴대폰 존재 여부 (아이디 찾기용)
    public boolean existsByNameAndPhone(String name, String phone) {

        String sql =
            "SELECT COUNT(*) FROM users " +
            "WHERE name = ? AND REPLACE(phone, '-', '') = ?";

        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, name);
            pstmt.setString(2, phone.replace("-", ""));

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

 // ✅ 아이디 + 휴대폰 존재 여부 (비밀번호 재설정용)
    public boolean existsByIdAndPhone(String id, String phone) {

        String sql =
            "SELECT COUNT(*) FROM users " +
            "WHERE id = ? AND REPLACE(phone, '-', '') = ?";

        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            pstmt.setString(2, phone.replace("-", ""));

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    
  
 // [조회] 자녀 리스트 가져오기
    public List<ChildDTO> selectChildren(Connection conn, int userNum) throws SQLException {
        String sql = "SELECT CHILD_NAME, TO_CHAR(CHILD_BIRTH, 'YYYYMMDD') as CHILD_BIRTH, CHILD_GENDER " +
                     "FROM CHILD WHERE USER_NUMBER = ?";
        List<ChildDTO> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ChildDTO dto = new ChildDTO();
                    dto.setChildName(rs.getString("CHILD_NAME"));
                    dto.setChildBirth(rs.getString("CHILD_BIRTH"));
                    dto.setChildGender(rs.getString("CHILD_GENDER"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    // [삭제] 기존 정보 싹 지우기
    public void deleteChildren(Connection conn, int userNum) throws SQLException {
        String sql = "DELETE FROM CHILD WHERE USER_NUMBER = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            pstmt.executeUpdate();
        }
    }

    // [삽입] 새로운 정보 넣기
    public void insertChild(Connection conn, int userNum, String name, String birth, String gender) throws SQLException {
        String sql = "INSERT INTO CHILD (CHILD_ID, USER_NUMBER, CHILD_NAME, CHILD_BIRTH, CHILD_GENDER, CREATED_AT) " +
                     "VALUES (SEQ_CHILD.NEXTVAL, ?, ?, TO_DATE(?, 'YYYYMMDD'), ?, SYSDATE)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            pstmt.setString(2, name);
            pstmt.setString(3, birth);
            pstmt.setString(4, gender);
            pstmt.executeUpdate();
        }
    }
 // [조회] 마케팅 상태 가져오기 (6: SMS, 7: EMAIL)
 // MemberDAO.java
 // MemberDAO.java 수정
    public Map<String, Integer> getMarketingStatus(Connection conn, int userNum) throws SQLException {
        String sql = "SELECT MARKETING_ID, IS_AGREED FROM USER_MARKETING_MAP WHERE USER_NUMBER = ?";
        Map<String, Integer> map = new HashMap<>();
        
        // Key를 숫자가 아닌 문자열 "6", "7"로 세팅
        map.put("6", 0); 
        map.put("7", 0);

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    // rs.getInt("MARKETING_ID")를 문자열로 변환하여 저장
                    map.put(String.valueOf(rs.getInt("MARKETING_ID")), rs.getInt("IS_AGREED"));
                }
            }
        }
        return map;
    }
    public void updateMarketing(Connection conn, int userNum, boolean sms, boolean email) throws SQLException {
        // 6번(SMS) 처리
        updateMarketingStatus(conn, userNum, 6, sms ? 1 : 0);
        // 7번(E-MAIL) 처리
        updateMarketingStatus(conn, userNum, 7, email ? 1 : 0);
    }

    public void updateMarketingStatus(Connection conn, int userNum, int mktId, int isAgreed) throws SQLException {
        String sql = "MERGE INTO USER_MARKETING_MAP m " +
                     "USING DUAL ON (m.USER_NUMBER = ? AND m.MARKETING_ID = ?) " +
                     "WHEN MATCHED THEN " +
                     "  UPDATE SET IS_AGREED = ?, AGREED_AT = SYSDATE " +
                     "WHEN NOT MATCHED THEN " +
                     "  INSERT (MAP_ID, USER_NUMBER, MARKETING_ID, IS_AGREED, AGREED_AT) " +
                     "  VALUES (SEQ_MAP.NEXTVAL, ?, ?, ?, SYSDATE)";
                     
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            pstmt.setInt(2, mktId);
            pstmt.setInt(3, isAgreed); // UPDATE 시 0 또는 1
            pstmt.setInt(4, userNum);
            pstmt.setInt(5, mktId);
            pstmt.setInt(6, isAgreed); // INSERT 시 0 또는 1
            pstmt.executeUpdate();
        }
    }
 // MemberDAO.java 내부에 추가
    public void updatePassword(Connection conn, int userNum, String newPassword) throws SQLException {
        String sql = "UPDATE USERS SET PASSWORD = ?, UPDATED_AT = SYSDATE WHERE USER_NUMBER = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userNum);
            pstmt.executeUpdate();
        }
    }
 // MemberDAO.java
    public int retireMember(Connection conn, int userNum) throws SQLException {
        // 상태를 INACTIVE로 변경하고 수정일시를 기록
        String sql = "UPDATE USERS SET STATUS = 'INACTIVE', UPDATED_AT = SYSDATE WHERE USER_NUMBER = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNum);
            return pstmt.executeUpdate();
        }
    }
}