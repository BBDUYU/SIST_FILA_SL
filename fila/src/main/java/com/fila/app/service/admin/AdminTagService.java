package com.fila.app.service.admin;

import java.util.List;

import com.fila.app.domain.admin.ProductVO;
import com.fila.app.domain.categories.CategoriesVO;

public interface AdminTagService {
    // 태그 리스트 조회
    List<CategoriesVO> getTagList();
    
    // 신규 태그 생성
    int createTag(String tagName);
    
    List<ProductVO> getProductsByTag(int tagId);
    
    int updateTag(int categoryId, String tagName);
    int updateTagStatus(int categoryId, int status);
}