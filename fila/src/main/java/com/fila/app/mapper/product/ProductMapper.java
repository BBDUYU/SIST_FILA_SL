package com.fila.app.mapper.product;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.product.ProductsOptionVO;
import com.fila.app.domain.product.ProductsVO;

@Mapper // 스프링이 이 인터페이스를 보고 "아, 이게 DAO구나" 하고 인식해서 객체를 만들어줍니다.
public interface ProductMapper {

    // 1. 상품 전체 목록 조회
    // (기존 메서드에서 Connection 파라미터가 다 사라집니다!)
    List<ProductsVO> selectAllProducts();

    // 2. 카테고리별 상품 목록 조회
    List<ProductsVO> selectProductsByCategory(int cateId);

    // 3. 최상위 카테고리 이름 가져오기
    String getRootCategoryName(int categoryId);

    // 4. 현재 카테고리 이름 가져오기
    String getCategoryName(int categoryId);

    // 5. 상품 상세 정보 조회
    ProductsVO getProduct(String productId);

    // 6. 상품 옵션 조회
    // (리턴 타입이 ProductsOptionVO 리스트로 바뀜)
    List<ProductsOptionVO> getProductOptions(String productId);

    // 7. 카테고리별 상품 개수 세기
    int getProductCount(int categoryId);

    // 8. 상품 태그(스포츠/라이프스타일 등) 가져오기
    // ★ 주의: 파라미터가 2개 이상일 때는 @Param을 붙여줘야 XML에서 #{이름}으로 구분 가능합니다.
    String getProductTag(@Param("productId") String productId, @Param("masterId") int masterId);

    // 9. 검색어로 상품 찾기
    List<ProductsVO> selectProductsBySearch(String searchItem);

}