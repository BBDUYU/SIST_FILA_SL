package mypage.service;

import java.sql.Connection;
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import categories.CategoriesDTO;
import member.domain.MemberDTO;
import mypage.domain.QNACategoriesDTO;
import mypage.domain.QnaDTO;
import mypage.persistence.QnaDAO;
import mypage.persistence.QnaDAOImpl;

public class QnaService {

    private static QnaService instance = new QnaService();
    public static QnaService getInstance() {
        return instance;
    }

    private QnaService() {}

    private QnaDAO dao = QnaDAOImpl.getInstance();

    /* ===============================
     * 1. 1:1 문의 목록 조회
     * =============================== */
    public List<QnaDTO> getQnaList(long userNumber) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return dao.selectByUser(conn, userNumber);
        } catch (Exception e) {
            throw new RuntimeException("QNA 목록 조회 실패", e);
        }
    }

    /* ===============================
     * 2. 상태별 문의 목록 조회
     * =============================== */
    public List<QnaDTO> getQnaListByStatus(long userNumber, String status) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return dao.selectByUserAndStatus(conn, userNumber, status);
        } catch (Exception e) {
            throw new RuntimeException("QNA 상태별 조회 실패", e);
        }
    }

    /* ===============================
     * 3. 문의 카테고리 목록
     * =============================== */
 // QnaService.java
    public List<QNACategoriesDTO> getCategoryList() {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return dao.selectCategoryList(conn); // 이제 DAO가 QNACategoriesDTO를 반환함
        } catch (Exception e) {
            throw new RuntimeException("문의 카테고리 조회 실패", e);
        }
    }

    /* ===============================
     * 4. 문의 등록 + 개인정보 동의 업데이트
     * =============================== */
    public void writeQna(MemberDTO loginUser, QnaDTO dto, int privacyAgree) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            dto.setUser_number(loginUser.getUserNumber());
            
            // 1. 문의글 저장
            dao.insertInquiry(conn, dto);
            
            // 2. 개인정보 수집 동의(5번 항목) 저장
            dao.updatePrivacyAgree(conn, loginUser.getUserNumber(), privacyAgree);

            conn.commit();
        } catch (Exception e) {
            JdbcUtil.rollback(conn);
            throw new RuntimeException("문의 등록 및 동의 저장 실패", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
    public List<QnaDTO> getAllInquiryList() {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return dao.selectAllInquiries(conn);
        } catch (Exception e) {
            throw new RuntimeException("전체 문의 목록 조회 실패", e);
        }
    }

    public void answerInquiry(long inquiryId, String replyContent) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            dao.updateReply(conn, inquiryId, replyContent);
        } catch (Exception e) {
            throw new RuntimeException("답변 등록 실패", e);
        }
    }
}
