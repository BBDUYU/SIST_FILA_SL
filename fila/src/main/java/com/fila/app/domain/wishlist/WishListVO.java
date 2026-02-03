package com.fila.app.domain.wishlist;

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
    private String sizeText;       // 사이즈

   
}
