package products;

import java.util.Date;

import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Data
public class ProductsDTO {
    
    // 1. PRODUCTS 테이블 컬럼
    private String product_id;      // 상품 ID (PK)
    private int category_id;        // 카테고리 ID (FK)
    private String name;            // 상품명
    private String description;     // 상품 설명
    private int price;              // 정가
    private int view_count;         // 조회수
    private Date created_at;        // 등록일
    private Date updated_at;        // 수정일
    private String status;          // 상태 (SALE, SOLDOUT 등)
    private int discount_rate;      // 할인율
    private int product_count; 		// 카테고리별 상품 개수를 담을 변수
    private String image_url;       // 대표 이미지 URL
    
 	// 2. [추가 필드]
    private String depth1_name;  	// 상위 카테고리 (여성/남성 등)
    private String tag_name;     	// 스타일 태그 (라이프스타일/트레이닝 등)
    private int like_count;      	// 찜(Wishlist) 개수
    private int review_count;    	// 리뷰 총 개수
    private double review_score; 	// 리뷰 평점 평균
    
    public String getImage_url() {
        // 값이 없으면 빈 문자열 리턴
        if (this.image_url == null || this.image_url.isEmpty()) return "";
     
        // 역슬래시를 슬래시로 바꾸고 서블릿 경로 붙여서 리턴
        String webPath = this.image_url.replace("\\", "/");
        return "/SIST_FILA/displayImage.do?path=" + webPath;
    }
    
    
}