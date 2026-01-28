package admin.domain;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ProductDTO {
    private String productid;    // 상품 ID
    private String name;         // 상품명
    private String categoryName; // 카테고리명 (JOIN 결과)
    private int price;           // 가격
    private int discountRate;    // 할인율
    private String status;       // 판매 상태 (판매중/품절 등)
    private int totalStock;      // 해당 상품의 모든 옵션 재고 합계
    private Date createdAt;      // 등록일
    private String mainImageUrl; // 상품 대표 이미지
    

}