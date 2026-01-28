package mypage;

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
public class WishListDTO {

    // 1) WISHLIST 테이블 컬럼
    private int wishlist_id;        // 위시리스트 PK
    private int user_number;        // 회원 번호 FK
    private String product_id;      // 상품 ID FK
    private Date created_at;        // 찜한 날짜
    private String size_text;		// 사이즈

    // 2) 화면 출력용(조인으로 채울 값)
    private String product_name;    // PRODUCTS.NAME
    private int price;              // PRODUCTS.PRICE
    private int discount_rate;      // PRODUCTS.DISCOUNT_RATE (필요 없으면 나중에 빼도 됨)
    private String image_url;       // PRODUCT_IMAGE.IMAGE_URL (대표이미지)



    // ProductsDTO랑 동일한 방식으로 이미지 URL 가공
    public String getImage_url() {
        if (this.image_url == null || this.image_url.isEmpty()) return "";

        String webPath = this.image_url.replace("\\", "/");
        return "/SIST_FILA/displayImage.do?path=" + webPath;
    }

    // (선택) 할인 적용 최종가가 필요하면 사용
    public int getFinal_price() {
        int rate = this.discount_rate;
        if (rate <= 0) return this.price;
        return this.price * (100 - rate) / 100;
    }
    
    public String getSize_text() {
    	return size_text;
    }
    
    public void setSize_text(String size_text) {
    	this.size_text = size_text;
    }
}
