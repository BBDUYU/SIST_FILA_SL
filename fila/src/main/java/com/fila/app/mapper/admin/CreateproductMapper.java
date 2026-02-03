package com.fila.app.mapper.admin;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.fila.app.domain.admin.CreateproductVO;


public interface CreateproductMapper {
    // 1. 상품 ID 및 시퀀스 관련
    String generateProductId(@Param("sequenceName") String sequenceName);

    // 2. 상품 기본 정보
    int insertProduct(CreateproductVO vo);
    void updateProduct(CreateproductVO vo);
    CreateproductVO selectProductById(String productId);
    void updateProductStatusDeleted(String productId);

    // 3. 이미지 관련
    int insertProductImage(CreateproductVO img); // 단건 등록 (Service에서 루프)
    List<CreateproductVO> selectImagesByProductId(String productId);
    List<String> getImagePathsByIds(@Param("imageIds") String[] imageIds);
    void deleteSpecificImages(@Param("imageIds") String[] imageIds);
    void deleteAllImagesByProductId(String productId);

    // 4. 카테고리 관계
    void insertCategoryRelation(@Param("productId") String productId, @Param("categoryId") int categoryId);
    List<Map<String, Object>> selectProductCategories(String productId);
    void deleteCategoryRelations(String productId);

    // 5. 옵션 및 재고 관련 (Service의 복잡한 로직을 지원)
    List<Map<String, Object>> selectAllOptions();
    List<Integer> selectProductSizeIds(String productId);
    List<Map<String, Object>> selectActiveEventSections();
    
    // 옵션 그룹/값/조합 등록 (Map 파라미터 활용)
    void insertOptionGroup(Map<String, Object> param);
    void insertOptionValue(Map<String, Object> param);
    void insertCombination(Map<String, Object> param);
    void insertStock(Map<String, Object> param);
    void insertCombiValue(@Param("valueId") long valueId, @Param("combiId") long combiId);

    // 6. 스타일 및 이벤트 관계
    void insertStyleProduct(@Param("productId") String productId, @Param("styleId") int styleId);
    void insertEventProduct(@Param("productId") String productId, @Param("sectionId") int sectionId);
    void deleteStyleProduct(String productId);
    void deleteEventProduct(String productId);

    // 7. 연관 데이터 일괄 삭제를 위한 기타 메서드
    void deleteOptionCombiValues(String productId);
    void deleteOptionStock(String productId);
    void deleteOptionCombinations(String productId);
    void deleteOptionValues(String productId);
    void deleteOptionGroups(String productId);
    
    List<com.fila.app.domain.admin.ProductVO> selectAdminProductList();
    
    List<Map<String, Object>> getProductOptionsDetail(@Param("productId") String productId);
}