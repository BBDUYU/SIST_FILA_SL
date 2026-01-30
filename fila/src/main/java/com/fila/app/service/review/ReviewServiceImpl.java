package com.fila.app.service.review;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fila.app.domain.review.ReviewVO;
import com.fila.app.mapper.review.ReviewMapper;

import lombok.Setter;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Setter(onMethod_ = @Autowired)
    private ReviewMapper reviewMapper;

    @Override
    public int writeReview(ReviewVO review) {
        return reviewMapper.insert(review);
    }

    @Override
    public List<ReviewVO> getReviewList(String productId, String[] ratingArr, int userNumber, String sort, String keyword) {
        return reviewMapper.selectListByFilter(productId, ratingArr, userNumber, sort, keyword);
    }

    @Override
    public Map<String, Object> getReviewSummary(String productId) {
        Map<String, Object> summary = reviewMapper.getReviewSummary(productId);
        
        // 통계 계산 로직 (DB에서 가져온 값으로 비율 계산)
        if (summary != null) {
            // MyBatis는 숫자 결과를 BigDecimal로 주는 경우가 많아 Number로 캐스팅 후 처리
            long total = ((Number) summary.get("total_cnt")).longValue();
            long best = ((Number) summary.get("best_cnt")).longValue();
            
            // 5점 리뷰 비율 계산 (전체가 0이면 0%)
            int bestRate = (total > 0) ? (int)((double)best / total * 100) : 0;
            summary.put("best_rate", bestRate);
        }
        
        return summary;
    }

    @Override
    public int likeReview(int reviewId, int userNumber, int type) {
        // [비즈니스 로직] 중복 참여 방지
        int count = reviewMapper.checkReviewLike(reviewId, userNumber);
        if (count > 0) {
            return -1; // 이미 참여했음
        }
        return reviewMapper.insertReviewLike(reviewId, userNumber, type);
    }

    @Override
    public boolean canWriteReview(int userNumber, String productId) {
        // [비즈니스 로직] 1주문 1리뷰 원칙
        // 1. 배송 완료된 주문 건수
        int deliveryCount = reviewMapper.getDeliveryCount(userNumber, productId);
        // 2. 이미 작성한 리뷰 건수
        int reviewCount = reviewMapper.getMyReviewCount(userNumber, productId);
        
        // 주문 횟수가 리뷰 횟수보다 많아야 작성 가능
        return deliveryCount > reviewCount;
    }

}
