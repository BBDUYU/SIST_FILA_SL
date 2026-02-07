package com.fila.app.service.product;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.fila.app.domain.product.ProductsOptionVO;
import com.fila.app.domain.product.ProductsVO;
import com.fila.app.mapper.product.UserProductMapper;

import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.domain.product.ProductsOptionVO;
import com.fila.app.domain.product.ProductsVO;
import com.fila.app.mapper.product.UserProductMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final UserProductMapper productMapper;

    // 1. 상세 페이지
    @Override
    public Map<String, Object> getProductDetail(String productId) {
        Map<String, Object> resultMap = new HashMap<>();

        ProductsVO product = productMapper.getProduct(productId);
        if (product == null) return null;

        // 이미지 파일 스캔 (기존 로직 유지)
        String uploadPath = "C:\\fila_upload\\product\\" + productId;
        File dir = new File(uploadPath);
        List<String> mainImages = new ArrayList<>();
        List<String> modelImages = new ArrayList<>();
        List<String> detailImages = new ArrayList<>();

        if (dir.exists() && dir.isDirectory()) {
            File[] files = dir.listFiles();
            if (files != null) {
                for (File file : files) {
                    String name = file.getName();
                    if (name.contains("_main_")) mainImages.add(name);
                    else if (name.contains("_model_")) modelImages.add(name);
                    else if (name.contains("_detail_")) detailImages.add(name);
                }
            }
        }
        Collections.sort(mainImages);
        Collections.sort(modelImages);
        Collections.sort(detailImages);

        // 옵션 및 관련 상품
        List<ProductsOptionVO> sizeOptions = productMapper.getProductOptions(productId);
        List<ProductsVO> relatedList = productMapper.selectProductsByCategory(product.getCategoryId());
        
        // 스타일 태그 (스포츠 등)
        String styleTag = productMapper.getProductTag(productId, 2);
        if(styleTag == null) styleTag = "라이프스타일";

        resultMap.put("product", product);
        resultMap.put("mainImages", mainImages);
        resultMap.put("modelImages", modelImages);
        resultMap.put("detailImages", detailImages);
        resultMap.put("sizeOptions", sizeOptions);
        resultMap.put("relatedList", relatedList);
        resultMap.put("styleTag", styleTag);

        return resultMap;
    }

    // 2. 리스트 조회
    @Override
    public List<ProductsVO> getProductList(int categoryId) {
        if (categoryId == 0) {
            return productMapper.selectAllProducts();
        } else {
            return productMapper.selectProductsByCategory(categoryId);
        }
    }

    // 3. 검색
    @Override
    public List<ProductsVO> searchProducts(String searchItem) {
        return productMapper.selectProductsBySearch(searchItem);
    }
    
    // 4. 사이드바 로직
    @Override
    public Map<String, Object> getSidebarAndTitles(int cateId) {
        Map<String, Object> result = new HashMap<>();
        
        String mainTitle = "WOMEN"; 
        String subTitle = "전체보기";
        int sidebarParentId = 0;
        
        if (cateId > 0) {
            CategoriesVO curDto = productMapper.selectCategory(cateId);
            
            if (curDto != null) {
                // (1) 메인 타이틀
                CategoriesVO parent = null;
                if (curDto.getDepth() == 1) {
                    mainTitle = curDto.getName();
                } else if (curDto.getDepth() == 2) {
                    parent = productMapper.selectCategory(curDto.getParentId());
                    if (parent != null) mainTitle = parent.getName();
                } else if (curDto.getDepth() == 3) {
                    parent = productMapper.selectCategory(curDto.getParentId());
                    if (parent != null) {
                        CategoriesVO grandParent = productMapper.selectCategory(parent.getParentId());
                        if (grandParent != null) mainTitle = grandParent.getName();
                    }
                }

                // (2) 서브 타이틀
                if (curDto.getDepth() == 3) {
                    if (parent == null) parent = productMapper.selectCategory(curDto.getParentId());
                    if (parent != null && "NewFeatured".equalsIgnoreCase(parent.getName())) {
                        String myName = curDto.getName();
                        if ("베스트".equals(myName)) subTitle = "BEST";
                        else if ("세일".equals(myName)) subTitle = "SALE";
                        else subTitle = myName;
                    } else {
                        if (parent != null) subTitle = parent.getName();
                    }
                } else if (curDto.getDepth() == 2) {
                    subTitle = curDto.getName();
                }
                
                // (3) 사이드바 기준점
                if (curDto.getDepth() == 1) sidebarParentId = cateId;
                else if (curDto.getDepth() == 2) sidebarParentId = cateId;
                else if (curDto.getDepth() == 3) {
                    CategoriesVO p = productMapper.selectCategory(curDto.getParentId());
                    sidebarParentId = p.getCategoryId();
                }
            }
        }
        
        // (4) 목록 조회
        List<CategoriesVO> sidebarList;
        if (sidebarParentId > 0) {
            sidebarList = productMapper.selectChildCategories(sidebarParentId);
        } else {
            sidebarList = productMapper.selectMainCategories();
        }
        
        // (5) 개수 계산
        int totalSidebarCount = 0;
        if (sidebarList != null) {
            for (CategoriesVO vo : sidebarList) {
                totalSidebarCount += vo.getProductCount();
            }
        }
        
        result.put("mainTitle", mainTitle);
        result.put("subTitle", subTitle);
        result.put("sidebarList", sidebarList);
        result.put("sidebarParentId", sidebarParentId);
        result.put("totalSidebarCount", totalSidebarCount);
        
        return result;
    }
}
