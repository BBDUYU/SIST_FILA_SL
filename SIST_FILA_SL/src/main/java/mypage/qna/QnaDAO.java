package mypage.qna;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import categories.CategoriesDTO;

public interface QnaDAO {
    // 내 문의 목록 조회
    List<QnaDTO> selectByUser(Connection conn, long userNumber) throws SQLException;

    // 상태별 문의 목록 조회
    List<QnaDTO> selectByUserAndStatus(Connection conn, long userNumber, String status) throws SQLException;

    // 문의 카테고리 목록 조회
    List<QNACategoriesDTO> selectCategoryList(Connection conn) throws SQLException;
    
    // 문의 등록
    int insertInquiry(Connection conn, QnaDTO dto) throws SQLException;

    // 개인정보 수집 동의 업데이트 (5번 항목)
    void updatePrivacyAgree(Connection conn, long userNumber, int isAgreed) throws SQLException;
    
 // 관리자: 전체 문의 목록 조회
    List<QnaDTO> selectAllInquiries(Connection conn) throws SQLException;

    // 관리자: 답변 등록 및 상태 변경
    int updateReply(Connection conn, long inquiryId, String replyContent) throws SQLException;
    
}