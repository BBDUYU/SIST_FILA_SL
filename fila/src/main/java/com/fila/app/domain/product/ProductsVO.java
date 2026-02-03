package com.fila.app.domain.product;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductsVO {
    
	// 1. PRODUCTS 테이블 컬럼
    // (MyBatis 설정에 따라 CamelCase로 바꿔야 할 수도 있지만, 일단 기존 변수명 유지)
    private String productId;
    private int categoryId;
    private String name;
    private String description;
    private int price;
    private int viewCount;
    private Date createdAt;
    private Date updatedAt;
    private String status;
    private int discountRate;
    private String imageUrl;       // 원본 경로만 저장 (로직 제거)
    
    // 2. [추가 필드] - 화면 표시용
    private int productCount;
    private String depth1Name;
    private String tagName;
    private int likeCount;
    private int reviewCount;
    private double reviewScore;
    
    private List<ProductsOptionVO> optionList;
}