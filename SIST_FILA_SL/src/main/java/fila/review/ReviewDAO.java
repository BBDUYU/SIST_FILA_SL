package fila.review;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface ReviewDAO {

    // 1. 리뷰 등록
    public int insert(ReviewDTO dto) throws SQLException;

    // 2. 리뷰 목록 조회
    public List<ReviewDTO> selectListByFilter(String productId, String[] ratingArr, int userNumber, String sort, String keyword) throws Exception;
    
    // 리뷰 통계 정보를 담기 위한 간단한 Map이나 별도의 DTO를 반환
    Map<String, Object> getReviewSummary(String productId) throws Exception;
    int insertReviewLike(int reviewId, int userNumber, int type) throws Exception;
    
    // 구매 확정 여부 확인 (리뷰 작성 권한)
    boolean isPurchased(int userNumber, String productId) throws SQLException;

}