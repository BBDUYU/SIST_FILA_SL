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
    private String product_id;
    private int category_id;
    private String name;
    private String description;
    private int price;
    private int view_count;
    private Date created_at;
    private Date updated_at;
    private String status;
    private int discount_rate;
    private String image_url;       // 원본 경로만 저장 (로직 제거)
    
    // 2. [추가 필드] - 화면 표시용
    private int product_count;
    private String depth1_name;
    private String tag_name;
    private int like_count;
    private int review_count;
    private double review_score;
    
    private List<ProductsOptionVO> optionList;
}