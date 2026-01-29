package fila.mypage.persistence;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import fila.categories.domain.CategoriesDTO;
import fila.mypage.domain.QNACategoriesDTO;
import fila.mypage.domain.QnaDTO;

public class QnaDAOImpl implements QnaDAO {

    // 싱글톤 패턴
    private static QnaDAOImpl dao = new QnaDAOImpl();
    private QnaDAOImpl() {}
    public static QnaDAOImpl getInstance() { return dao; }

    @Override
    public List<QnaDTO> selectByUser(Connection conn, long userNumber) throws SQLException {
        List<QnaDTO> list = new ArrayList<>();
        String sql = "SELECT i.*, c.CATEGORY_NAME FROM INQUIRY i " +
                     "JOIN INQUIRY_CATEGORY c ON i.CATEGORY_ID = c.CATEGORY_ID " +
                     "WHERE i.USER_NUMBER = ? ORDER BY i.CREATED_AT DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapToDTO(rs)); // 데이터 매핑
                }
            }
        }
        return list;
    }

    @Override
    public int insertInquiry(Connection conn, QnaDTO dto) throws SQLException {
        String sql = "INSERT INTO INQUIRY (INQUIRY_ID, USER_NUMBER, CATEGORY_ID, TITLE, CONTENT, STATUS, CREATED_AT) " +
                     "VALUES (SEQ_INQUIRY.NEXTVAL, ?, ?, ?, ?, 'WAIT', SYSDATE)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, dto.getUser_number());
            pstmt.setInt(2, dto.getCategory_id());
            pstmt.setString(3, dto.getTitle());
            pstmt.setString(4, dto.getContent());
            return pstmt.executeUpdate();
        }
    }

    @Override
    public void updatePrivacyAgree(Connection conn, long userNumber, int isAgreed) throws SQLException {
        String sql = "MERGE INTO USER_MARKETING_MAP m " +
                     "USING DUAL ON (m.USER_NUMBER = ? AND m.MARKETING_ID = 5) " +
                     "WHEN MATCHED THEN UPDATE SET IS_AGREED = ?, AGREED_AT = SYSDATE " +
                     "WHEN NOT MATCHED THEN INSERT (MAP_ID, USER_NUMBER, MARKETING_ID, IS_AGREED, AGREED_AT) " +
                     "VALUES (SEQ_MAP.NEXTVAL, ?, 5, ?, SYSDATE)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userNumber);
            pstmt.setInt(2, isAgreed);
            pstmt.setLong(3, userNumber);
            pstmt.setInt(4, isAgreed);
            pstmt.executeUpdate();
        }
    }

    // 결과셋을 DTO로 바꿔주는 헬퍼 메서드
    private QnaDTO mapToDTO(ResultSet rs) throws SQLException {
        return QnaDTO.builder()
                .inquiry_id(rs.getLong("INQUIRY_ID"))
                .user_number(rs.getLong("USER_NUMBER"))
                .category_id(rs.getInt("CATEGORY_ID"))
                .category_name(rs.getString("CATEGORY_NAME"))
                .title(rs.getString("TITLE"))
                .content(rs.getString("CONTENT"))
                .status(rs.getString("STATUS"))
                .reply_content(rs.getString("REPLY_CONTENT"))
                .reply_at(rs.getTimestamp("REPLY_AT"))
                .created_at(rs.getTimestamp("CREATED_AT"))
                .build();
    }

    @Override
    public List<QnaDTO> selectByUserAndStatus(Connection conn, long userNumber, String status) throws SQLException {
        if (status == null || status.isBlank() || "ALL".equalsIgnoreCase(status)) {
            return selectByUser(conn, userNumber);
        }

        List<QnaDTO> list = new ArrayList<>();
        String sql = "SELECT i.*, c.CATEGORY_NAME FROM INQUIRY i " +
                     "JOIN INQUIRY_CATEGORY c ON i.CATEGORY_ID = c.CATEGORY_ID " +
                     "WHERE i.USER_NUMBER = ? AND i.STATUS = ? " +
                     "ORDER BY i.CREATED_AT DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userNumber);
            pstmt.setString(2, status);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapToDTO(rs));
                }
            }
        }
        return list;
    }

 // QnaDAOImpl.java
    @Override
    public List<QNACategoriesDTO> selectCategoryList(Connection conn) throws SQLException {
        List<QNACategoriesDTO> list = new ArrayList<>();
        String sql = "SELECT CATEGORY_ID, CATEGORY_NAME FROM INQUIRY_CATEGORY ORDER BY CATEGORY_ID ASC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                // QNACategoriesDTO로 빌드해서 리스트에 추가
                list.add(QNACategoriesDTO.builder()
                        .category_id(rs.getInt("CATEGORY_ID"))
                        .category_name(rs.getString("CATEGORY_NAME"))
                        .build());
            }
        }
        return list;
    }
    @Override
    public List<QnaDTO> selectAllInquiries(Connection conn) throws SQLException {
        List<QnaDTO> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT i.*, c.CATEGORY_NAME, u.NAME as USER_NAME "); 
        sql.append("FROM INQUIRY i "); 
        sql.append("JOIN INQUIRY_CATEGORY c ON i.CATEGORY_ID = c.CATEGORY_ID ");
        sql.append("JOIN USERS u ON i.USER_NUMBER = u.USER_NUMBER ");
        sql.append("ORDER BY i.CREATED_AT DESC");

        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString());
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                QnaDTO dto = QnaDTO.builder()
                        .inquiry_id(rs.getLong("INQUIRY_ID"))
                        .category_name(rs.getString("CATEGORY_NAME"))
                        .title(rs.getString("TITLE"))
                        .content(rs.getString("CONTENT"))
                        .user_name(rs.getString("USER_NAME")) 
                        .status(rs.getString("STATUS"))
                        .created_at(rs.getTimestamp("CREATED_AT"))
                        .reply_content(rs.getString("REPLY_CONTENT"))
                        .reply_at(rs.getTimestamp("REPLY_AT"))
                        .build();
                list.add(dto);
            }
        }
        return list;
    }

    @Override
    public int updateReply(Connection conn, long inquiryId, String replyContent) throws SQLException {
        // 답변 내용을 넣고 상태를 DONE으로, 답변 시각을 SYSDATE로 변경
        String sql = "UPDATE INQUIRY SET REPLY_CONTENT = ?, STATUS = 'DONE', REPLY_AT = SYSDATE WHERE INQUIRY_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, replyContent);
            pstmt.setLong(2, inquiryId);
            return pstmt.executeUpdate();
        }
    }
}