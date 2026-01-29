package fila.categories.service;

import java.util.ArrayList;
import fila.categories.domain.CategoriesDTO;

public interface CategoryService {
    
    // 1. 헤더 및 메뉴용 전체 카테고리 조회 (selectCategoryList 매핑)
    ArrayList<CategoriesDTO> getHeaderCategories();
    
    // 2. 관리자 페이지용 전체 태그 조회 (selectTagList 매핑)
    ArrayList<CategoriesDTO> getAllTags();
    
    // 3. 사용자 메인화면용 활성 태그 조회 (selectActiveTagList 매핑) 
    ArrayList<CategoriesDTO> getActiveTags();
    
    // 4. 새로운 태그 등록 (getMaxTagId + insertTag 매핑)
    void addNewTag(String tagName);
    
    // 5. 기존 태그 수정 (updateTag 매핑)
    void modifyTag(int id, String name);
    
    // 6. 태그 노출 상태 변경 (updateTagStatus 매핑)
    void changeTagStatus(int id, int status);
}