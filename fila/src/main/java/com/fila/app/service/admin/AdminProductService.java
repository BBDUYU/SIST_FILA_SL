package com.fila.app.service.admin;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import com.fila.app.domain.admin.CreateproductVO;

public interface AdminProductService {
    // 폼 데이터 로딩
    Map<Integer, List<Map<String, Object>>> getProductFormData();
    void getAdminFullFormData(HttpServletRequest request);
    
    // 등록/상세/수정/삭제
    void createProduct(CreateproductVO product, String[] categoryIds, String[] tagIds,
                      String genderOption, String sportOption, String[] sizeOptions,
                      List<CreateproductVO> imageList, int styleId, int sectionId, int stock);
    
    CreateproductVO getProductDetail(String productId);
    List<CreateproductVO> getProductImages(String productId);
    List<Map<String, Object>> getProductCategories(String productId);
    List<Integer> getProductSizeIds(String productId);

    void updateProduct(CreateproductVO dto, List<CreateproductVO> newImages, String[] deleteImageIds, 
                      String[] categoryIds, String[] tagIds, String genderOption, String sportOption, 
                      String[] sizeOptions, int styleId, int sectionId, int stock);
    
    void deleteProduct(String productId);
}