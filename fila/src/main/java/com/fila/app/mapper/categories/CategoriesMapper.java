package com.fila.app.mapper.categories;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.categories.CategoriesVO;

@Mapper
public interface CategoriesMapper {
    
    // [조회 기능]
    List<CategoriesVO> selectCategoryList();
    CategoriesVO selectCategory(int categoryId);
    List<CategoriesVO> selectChildCategories(int parentId);
    List<CategoriesVO> selectMainCategories();
    List<CategoriesVO> selectActiveTagList(); // 활성화 태그만 (메인용)

    // [관리 기능 - 태그 관리]
    List<CategoriesVO> selectTagList(); // 전체 태그 (관리자용)
    int getMaxTagId();
    int insertTag(CategoriesVO vo);
    int updateTag(@Param("categoryId") int categoryId, @Param("tagName") String tagName);
    int updateTagStatus(@Param("categoryId") int categoryId, @Param("status") int status);
}