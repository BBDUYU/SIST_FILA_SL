package com.fila.app.service.admin;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.admin.CreateproductVO;
import com.fila.app.domain.admin.ProductVO;
import com.fila.app.mapper.admin.CreateproductMapper;
import com.fila.app.mapper.admin.StyleMapper;

@Service
public class AdminProductServiceImpl implements AdminProductService {

    @Autowired
    private CreateproductMapper productMapper;
    
    @Autowired
    private StyleMapper styleMapper;

    @Override
    @Transactional(readOnly = true)
    public List<ProductVO> getProductList() {
        return productMapper.selectAdminProductList();
    }
    
    @Override
    @Transactional(readOnly = true)
    public Map<Integer, List<Map<String, Object>>> getProductFormData() {
        List<Map<String, Object>> allOptions = productMapper.selectAllOptions();
        Map<Integer, List<Map<String, Object>>> optionsMap = new HashMap<>();
        for (Map<String, Object> opt : allOptions) {
            Integer masterId = Integer.parseInt(String.valueOf(opt.get("masterId")));
            optionsMap.computeIfAbsent(masterId, k -> new ArrayList<>()).add(opt);
        }
        return optionsMap;
    }

    @Override
    @Transactional
    public void createProduct(CreateproductVO product, String[] categoryIds, String[] tagIds,
                            String genderOption, String sportOption, String[] sizeOptions,
                            List<CreateproductVO> imageList, int styleId, int sectionId, int stock) {
        
        // 1. 대표 카테고리 설정
        int mainCateId = 0;
        if (categoryIds != null && categoryIds.length > 0) {
            mainCateId = Integer.parseInt(categoryIds[0]);
            product.setCategoryId(mainCateId);
        } else {
            product.setCategoryId(10);
            mainCateId = 10;
        }

        String newId = product.getProductId(); 
        
        if (newId == null || newId.isEmpty()) {
            newId = productMapper.generateProductId(mainCateId);
            product.setProductId(newId);
        }

        productMapper.insertProduct(product);
        
        saveCategoryRelations(newId, categoryIds, tagIds, genderOption);
        
        if (sportOption != null && !sportOption.isEmpty()) {
            insertSingleOptionLogic(newId, 2, sportOption);
        }
        
        processSizeOptions(newId, sizeOptions, stock);

        if (imageList != null) {
            for (CreateproductVO img : imageList) {
                img.setProductId(newId);
                productMapper.insertProductImage(img);
            }
        }
        
        // 8. 스타일 및 이벤트 연결
        if (styleId > 0) productMapper.insertStyleProduct(newId, styleId);
        if (sectionId > 0) productMapper.insertEventProduct(newId, sectionId);
    }

    // [헬퍼] 사이즈 옵션 공통 로직 (등록/수정 공용)
    private void processSizeOptions(String pId, String[] sizeOptions, int stock) {
        if (sizeOptions != null && sizeOptions.length > 0) {
            int sizeMasterId = 4; // 기본 남성
            if (pId.startsWith("PROD1")) sizeMasterId = 5;      // 여성 대역
            else if (pId.startsWith("PROD3")) sizeMasterId = 6; // 키즈 대역

            Map<String, Object> groupParam = new HashMap<>();
            groupParam.put("productId", pId);
            groupParam.put("masterId", sizeMasterId);
            productMapper.insertOptionGroup(groupParam); 
            
            // MyBatis selectKey 또는 맵을 통해 돌아온 PK 값 확인 (Long 또는 Integer 대응)
            Object groupIdObj = groupParam.get("optionGroupId");
            long groupId = Long.parseLong(String.valueOf(groupIdObj));

            for (String vMasterId : sizeOptions) {
                Map<String, Object> valParam = new HashMap<>();
                valParam.put("optionGroupId", groupId);
                valParam.put("vMasterId", Integer.parseInt(vMasterId));
                valParam.put("valueName", ""); 
                productMapper.insertOptionValue(valParam);
                
                long valueId = Long.parseLong(String.valueOf(valParam.get("valueId")));

                Map<String, Object> combiParam = new HashMap<>();
                combiParam.put("productId", pId);
                productMapper.insertCombination(combiParam);
                
                long combiId = Long.parseLong(String.valueOf(combiParam.get("combinationId")));
                
                productMapper.insertCombiValue(valueId, combiId);
                
                Map<String, Object> stockParam = new HashMap<>();
                stockParam.put("combinationId", combiId);
                stockParam.put("stock", stock);
                stockParam.put("isSoldout", stock > 0 ? 0 : 1);
                productMapper.insertStock(stockParam);
            }
        }
    }

    private void insertSingleOptionLogic(String pId, int mId, String vMid) {
        Map<String, Object> groupParam = new HashMap<>();
        groupParam.put("productId", pId);
        groupParam.put("masterId", mId);
        productMapper.insertOptionGroup(groupParam);
        
        Object groupIdObj = groupParam.get("optionGroupId");
        long groupId = Long.parseLong(String.valueOf(groupIdObj));
        
        Map<String, Object> valParam = new HashMap<>();
        valParam.put("optionGroupId", groupId);
        valParam.put("vMasterId", Integer.parseInt(vMid));
        valParam.put("valueName", ""); 
        productMapper.insertOptionValue(valParam);
    }

    @Override
    @Transactional
    public void updateProduct(CreateproductVO dto, List<CreateproductVO> newImages, String[] deleteImageIds, 
                            String[] categoryIds, String[] tagIds, String genderOption, String sportOption, 
                            String[] sizeOptions, int styleId, int sectionId, int stock) {
        
        String pId = dto.getProductId();
        productMapper.updateProduct(dto);

        // 이미지 처리
        if (deleteImageIds != null && deleteImageIds.length > 0) {
            List<String> paths = productMapper.getImagePathsByIds(deleteImageIds);
            for (String path : paths) {
                File file = new File(path.replace("/upload/", "C:\\fila_upload\\"));
                if (file.exists()) file.delete();
            }
            productMapper.deleteSpecificImages(deleteImageIds);
        }
        if (newImages != null) {
            for (CreateproductVO img : newImages) {
                img.setProductId(pId);
                productMapper.insertProductImage(img);
            }
        }

        // 초기화 및 재등록
        productMapper.deleteOptionCombiValues(pId);
        productMapper.deleteOptionStock(pId);
        productMapper.deleteOptionCombinations(pId);
        productMapper.deleteOptionValues(pId);
        productMapper.deleteOptionGroups(pId);
        productMapper.deleteCategoryRelations(pId);
        productMapper.deleteStyleProduct(pId);
        productMapper.deleteEventProduct(pId);

        saveCategoryRelations(pId, categoryIds, tagIds, genderOption);
        if (sportOption != null && !sportOption.isEmpty()) insertSingleOptionLogic(pId, 2, sportOption);
        processSizeOptions(pId, sizeOptions, stock);

        if (styleId > 0) productMapper.insertStyleProduct(pId, styleId);
        if (sectionId > 0) productMapper.insertEventProduct(pId, sectionId);
    }

    private void saveCategoryRelations(String pId, String[] cats, String[] tags, String gender) {
        if (gender != null && !gender.isEmpty()) {
            productMapper.insertCategoryRelation(pId, Integer.parseInt(gender));
        }
        if (cats != null) {
            for (String id : cats) {
                // 성별 옵션과 중복되지 않게 저장
                if (!id.equals(gender)) productMapper.insertCategoryRelation(pId, Integer.parseInt(id));
            }
        }
        if (tags != null) {
            for (String id : tags) {
                productMapper.insertCategoryRelation(pId, Integer.parseInt(id));
            }
        }
    }

    @Override
    @Transactional(readOnly = true)
    public void getAdminFullFormData(HttpServletRequest request) {
        request.setAttribute("options", this.getProductFormData());
        request.setAttribute("styleList", styleMapper.selectStyleList());
        request.setAttribute("eventSectionList", productMapper.selectActiveEventSections());
        List<Map<String, Object>> allCategories = productMapper.selectAllCategories();
        request.setAttribute("list", allCategories);
        request.setAttribute("tagList", allCategories);
    }
    
    @Override
    public String generateProductId(int mainCateId) {
        return productMapper.generateProductId(mainCateId);
    }

    @Override
    public List<String> getImagePathsByIds(String[] imageIds) {
        if (imageIds == null || imageIds.length == 0) return new ArrayList<>();
        return productMapper.getImagePathsByIds(imageIds); 
    }

    @Override public CreateproductVO getProductDetail(String pId) { return productMapper.selectProductById(pId); }
    @Override public List<CreateproductVO> getProductImages(String pId) { return productMapper.selectImagesByProductId(pId); }
    @Override public List<Map<String, Object>> getProductCategories(String pId) { return productMapper.selectProductCategories(pId); }
    @Override public List<Integer> getProductSizeIds(String pId) { return productMapper.selectProductSizeIds(pId); }
    @Override @Transactional public void deleteProduct(String pId) { productMapper.updateProductStatusDeleted(pId); }
}