package com.fila.app.mapper.review;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.review.ReviewVO;

public interface ReviewMapper {

    // 1. 리뷰 등록
    int insert(ReviewVO review);

    // 2. 리뷰 목록 조회 (필터링 포함)
    // @Param을 써야 XML에서 #{productId} 처럼 이름으로 꺼낼 수 있습니다.
    List<ReviewVO> selectListByFilter(
        @Param("productId") String productId, 
        @Param("ratingArr") String[] ratingArr, 
        @Param("userNumber") int userNumber, 
        @Param("sort") String sort, 
        @Param("keyword") String keyword
    );
    
    // 3. 리뷰 통계 정보 (총 개수, 평균 별점, 5점 개수 등)
    Map<String, Object> getReviewSummary(String productId);
    
    // 4. 좋아요/싫어요 관련
    // 중복 참여 확인
    int checkReviewLike(@Param("reviewId") int reviewId, @Param("userNumber") int userNumber);
    // 좋아요 등록
    int insertReviewLike(@Param("reviewId") int reviewId, @Param("userNumber") int userNumber, @Param("type") int type);
    
    // 5. 구매 확정 및 리뷰 작성 권한 확인
    // 배송 완료된 주문 건수 조회
    int getDeliveryCount(@Param("userNumber") int userNumber, @Param("productId") String productId);
    // 내 리뷰 작성 건수 조회
    int getMyReviewCount(@Param("userNumber") int userNumber, @Param("productId") String productId);

}
