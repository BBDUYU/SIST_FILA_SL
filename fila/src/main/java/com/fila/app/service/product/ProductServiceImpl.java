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

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service 
@RequiredArgsConstructor 
public class ProductServiceImpl implements ProductService {

    private final UserProductMapper productMapper;

    // 1. 상세 페이지 로직 (아까 짠 거랑 동일)
    @Override
    public Map<String, Object> getProductDetail(String productId) {
        Map<String, Object> resultMap = new HashMap<>();

        // (1) 상품 정보
        ProductsVO product = productMapper.getProduct(productId);
        if (product == null) return null;

        // (2) 파일 시스템 스캔 (이미지)
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

        // (3) 옵션 정보
        List<ProductsOptionVO> sizeOptions = productMapper.getProductOptions(productId);

        // (4) 관련 상품 (같은 카테고리)
        List<ProductsVO> relatedList = productMapper.selectProductsByCategory(product.getCategoryId());

        // (5) 맵에 담기
        resultMap.put("product", product);
        resultMap.put("mainImages", mainImages);
        resultMap.put("modelImages", modelImages);
        resultMap.put("detailImages", detailImages);
        resultMap.put("sizeOptions", sizeOptions);
        resultMap.put("relatedList", relatedList);

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
}
