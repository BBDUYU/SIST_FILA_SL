package com.fila.app.domain.wishlist;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class WishListVO {

    // 1) WISHLIST 테이블 컬럼
    private int wishlistId;      // 위시리스트 PK
    private int userNumber;      // 회원 번호 FK
    private String productId;    // 상품 ID FK
    private Date createdAt;      // 찜한 날짜
    private String sizeText;     // 사이즈

    // 2) 화면 출력용 (JOIN 결과)
    private String productName;  // PRODUCTS.NAME
    private int price;           // PRODUCTS.PRICE
    private int discountRate;    // PRODUCTS.DISCOUNT_RATE
    private String imageUrl;     // PRODUCT_IMAGE.IMAGE_URL (대표 이미지)

    // 이미지 URL 가공
    public String getImageUrl() {
        if (imageUrl == null || imageUrl.isEmpty()) return "";

        String webPath = imageUrl.replace("\\", "/");
        return "/SIST_FILA/displayImage.do?path=" + webPath;
    }

    // 할인 적용 최종가
    public int getFinalPrice() {
        if (discountRate <= 0) return price;
        return price * (100 - discountRate) / 100;
    }
}