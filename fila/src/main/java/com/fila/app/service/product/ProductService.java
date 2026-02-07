package com.fila.app.service.product;

import java.util.List;
import java.util.Map;

import com.fila.app.domain.product.ProductsVO;

public interface ProductService {

    // 1. 상품 상세 정보 조회 (이미지 + 옵션 + 기본정보)
    public Map<String, Object> getProductDetail(String productId);

    // 2. 카테고리별 상품 리스트 조회
    public List<ProductsVO> getProductList(int categoryId);

    // 3. 검색어로 상품 찾기
    public List<ProductsVO> searchProducts(String searchItem);

    public Map<String, Object> getSidebarAndTitles(int cateId);
    
}
