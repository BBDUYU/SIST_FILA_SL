package com.fila.app.domain.mypage;

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
public class WishListVO {

    // 1) WISHLIST 테이블 컬럼
    private int wishlistId;        // 위시리스트 PK
    private int userNumber;        // 회원 번호 FK
    private String productId;      // 상품 ID FK
    private Date createdAt;        // 찜한 날짜
    private String sizeText;		// 사이즈

    // 2) 화면 출력용(조인으로 채울 값)
    private String productName;    // PRODUCTS.NAME
    private int price;              // PRODUCTS.PRICE
    private int discountRate;      // PRODUCTS.DISCOUNT_RATE (필요 없으면 나중에 빼도 됨)
    private String imageUrl;       // PRODUCT_IMAGE.IMAGE_URL (대표이미지)




}
