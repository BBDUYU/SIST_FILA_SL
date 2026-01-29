package fila.review;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
public class ReviewDTO {
    
    private int review_id;
    private String product_id;
    private int user_number;
    private String content;
    private int rating;
    private String review_img;
    private Date regdate; 
    
    // 조인용 / 추가 정보 필드
    private int like_id;
    private int type;
    private String user_id;
    private int like_cnt;
    private int dislike_cnt;
    private String product_size;
    
    @Builder.Default 
    private int myLike = -1;    
}