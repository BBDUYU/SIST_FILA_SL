package com.fila.app.domain.mypage.qna;

import java.util.Date;

import com.fila.app.domain.categories.CategoriesVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MypageQnaVO {

	// ===== 1:1 문의 (INQUIRY) 핵심 필드 =====
    private long inquiryId;      // inquiry_id
    private long userNumber;     // user_number
    private int categoryId;      // category_id

    private String title;
    private String content;
    private String imageUrl;     // image_url

    private String status;       // WAIT (대기) / DONE (완료)
    private String replyContent; // reply_content (관리자 답변 내용)
    private Date replyAt;        // reply_at (답변 일시)

    private Date createdAt;      // created_at
    private Date updatedAt;      // updated_at

    // ===== JOIN 데이터 (목록 출력용) =====
    private String categoryName; // category_name (인쿼리 카테고리명)
    private String userName;     // user_name (작성자 이름)
    
    // ===== 상품 문의(Product QnA) 호환용 (필요 시) =====
    private String productId;    // product_id
    private String productName;  // product_name
    
    

    // getter / setter
}
