package com.fila.app.service.review;

import java.util.List;
import java.util.Map;

import com.fila.app.domain.review.ReviewVO;

public interface ReviewService {
    
    // 리뷰 작성
    int writeReview(ReviewVO review);
    
    // [수정] 포토리뷰 필터(isPhotoFirst) 파라미터 추가
    List<ReviewVO> getReviewList(String productId, String[] ratingArr, int userNumber, String sort, String keyword, boolean isPhotoFirst);
    
    // 리뷰 통계 정보 가져오기
    Map<String, Object> getReviewSummary(String productId);
    
    // 좋아요/싫어요 기능
    int likeReview(int reviewId, int userNumber, int type);
    
    // 리뷰 작성 권한 확인
    boolean canWriteReview(int userNumber, String productId);
}
