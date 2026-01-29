package productsqna;

import java.sql.SQLException;
import java.util.List;

public interface QnaDAO {
    // 1. 상품 문의 등록
    int insert(QnaDTO dto) throws SQLException;

    // 2. 상품 문의 목록 조회 (상품별)
    List<QnaDTO> selectList(String productId) throws SQLException;

    // 3. 관리자용 전체 목록 조회
    List<QnaDTO> selectAdminQnaList() throws Exception;

    // 4. 관리자용 상세 조회
    QnaDTO selectQnaDetail(int qnaId) throws Exception;
    
    // 5. 관리자 답변 저장
    int updateAnswer(int qnaId, String answer) throws Exception;
}