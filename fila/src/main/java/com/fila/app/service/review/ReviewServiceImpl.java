package com.fila.app.service.review;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fila.app.domain.review.ReviewVO;
import com.fila.app.mapper.review.ReviewMapper;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired 
    private ReviewMapper reviewMapper;

    @Override
    public int writeReview(ReviewVO review) {
        return reviewMapper.insert(review);
    }

    // [수정] 포토리뷰 필터링(isPhotoFirst) 파라미터 추가 및 전달
    @Override
    public List<ReviewVO> getReviewList(String productId, String[] ratingArr, int userNumber, String sort, String keyword, boolean isPhotoFirst) {
        // 매퍼에 새로 추가한 isPhotoFirst 파라미터까지 실어서 보냅니다.
        return reviewMapper.selectListByFilter(productId, ratingArr, userNumber, sort, keyword, isPhotoFirst);
    }

    @Override
    public Map<String, Object> getReviewSummary(String productId) {
        // [변경] SQL(Mapper)에서 이미 best_rate까지 계산해서 오도록 고쳤으므로, 
        // 여기서 별도의 계산 로직 없이 바로 리턴해도 됩니다.
        Map<String, Object> summary = reviewMapper.getReviewSummary(productId);
        
        // 혹시 몰라 null 체크만 가볍게 해줍니다.
        if (summary == null) {
            System.err.println(">>> [Service] 요약 데이터가 없습니다.");
        }
        
        return reviewMapper.getReviewSummary(productId);
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