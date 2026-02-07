package com.fila.app.mapper.admin;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.fila.app.domain.admin.CreateproductVO;
import com.fila.app.domain.admin.ProductVO;

@Mapper
public interface CreateproductMapper {
    // 1. 상품 ID 및 시퀀스 관련
	String generateProductId(@Param("mainCateId") int mainCateId);

    // 2. 상품 기본 정보
    int insertProduct(CreateproductVO vo);
    void updateProduct(CreateproductVO vo);
    CreateproductVO selectProductById(String productId);
    void updateProductStatusDeleted(String productId);

    // 3. 이미지 관련
    int insertProductImage(CreateproductVO img);
    List<CreateproductVO> selectImagesByProductId(String productId);
    List<String> getImagePathsByIds(@Param("imageIds") String[] imageIds);
    void deleteSpecificImages(@Param("imageIds") String[] imageIds);
    void deleteAllImagesByProductId(String productId);

    // 4. 카테고리 관계
    void insertCategoryRelation(@Param("productId") String productId, @Param("categoryId") int categoryId);
    List<Map<String, Object>> selectProductCategories(String productId);
    void deleteCategoryRelations(String productId);

    // 5. 옵션 및 재고 관련
    List<Map<String, Object>> selectAllOptions();
    List<Integer> selectProductSizeIds(String productId);
    List<Map<String, Object>> selectActiveEventSections();
    List<Map<String, Object>> selectAllCategories();
    
    // 핵심 수정 부분: 파라미터 타입을 XML과 일치시킴
    void insertOptionGroup(Map<String, Object> param);
    
    // XML에서 #{optionGroupId}, #{vMasterId}, #{valueName}을 쓰므로 Map으로 전달
    void insertOptionValue(Map<String, Object> param); 
    
    void insertCombination(Map<String, Object> param);
    
    // XML에서 #{combinationId}, #{stock}, #{isSoldout}을 쓰므로 Map으로 전달
    void insertStock(Map<String, Object> param);
    
    void insertCombiValue(@Param("valueId") long valueId, @Param("combinationId") long combinationId);

    // 6. 스타일 및 이벤트 관계
    void insertStyleProduct(@Param("productId") String productId, @Param("styleId") int styleId);
    void insertEventProduct(@Param("productId") String productId, @Param("sectionId") int sectionId);
    void deleteStyleProduct(String productId);
    void deleteEventProduct(String productId);

    // 7. 연관 데이터 일괄 삭제
    void deleteOptionCombiValues(String productId);
    void deleteOptionStock(String productId);
    void deleteOptionCombinations(String productId);
    void deleteOptionValues(String productId);
    void deleteOptionGroups(String productId);
    
    List<ProductVO> selectAdminProductList();
    List<Map<String, Object>> getProductOptionsDetail(@Param("productId") String productId);
}