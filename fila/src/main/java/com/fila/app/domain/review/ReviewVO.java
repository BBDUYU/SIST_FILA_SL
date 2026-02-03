package com.fila.app.domain.review;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReviewVO {
    
    private int reviewId;
    private String productId;
    private int userNumber;
    private String content;
    private int rating;
    private String reviewImg;
    
    // 날짜 포맷 지정
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date regdate; 
    
    // 조인용 / 추가 정보 필드
    private int likeId;
    private int type;
    private String userId;     // 작성자 ID (users 테이블 조인)
    private int likeCnt;       // 좋아요 개수
    private int dislikeCnt;    // 싫어요 개수
    private String productSize;
    
    @Builder.Default 
    private int myLike = -1;    // 내가 누른 좋아요 상태 (기본값 -1)
}
