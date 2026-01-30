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
    
    private int review_id;
    private String product_id;
    private int user_number;
    private String content;
    private int rating;
    private String review_img;
    
    // 날짜 포맷 지정
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date regdate; 
    
    // 조인용 / 추가 정보 필드
    private int like_id;
    private int type;
    private String user_id;     // 작성자 ID (users 테이블 조인)
    private int like_cnt;       // 좋아요 개수
    private int dislike_cnt;    // 싫어요 개수
    private String product_size;
    
    @Builder.Default 
    private int myLike = -1;    // 내가 누른 좋아요 상태 (기본값 -1)
}
