package com.fila.app.mapper.product;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

// [수정] 형님 VO 경로에 맞춰서 import
import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.domain.product.ProductsOptionVO;
import com.fila.app.domain.product.ProductsVO;

@Mapper
public interface UserProductMapper {

    // 1. 전체 상품 목록 조회
    public List<ProductsVO> selectAllProducts();

    // 2. 카테고리별 상품 목록 조회
    public List<ProductsVO> selectProductsByCategory(int cateId);

    // 3. 상품 상세 조회
    public ProductsVO getProduct(String productId);

    // 4. 검색
    public List<ProductsVO> selectProductsBySearch(@Param("searchItem") String searchItem);

    // 5. 상품 옵션 조회 (추가됨)
    public List<ProductsOptionVO> getProductOptions(String productId);

    // 6. 사이드바용 카테고리 조회 메서드들
    
    // (1) 단일 카테고리 정보 조회
    public CategoriesVO selectCategory(int categoryId);

    // (2) 메인(Depth 1) 카테고리 목록 조회
    public List<CategoriesVO> selectMainCategories();

    // (3) 하위 카테고리 목록 조회
    public List<CategoriesVO> selectChildCategories(int parentId);

    // 7. 상품 태그 조회 (추가됨)
    public String getProductTag(@Param("productId") String productId, @Param("masterId") int masterId);

}