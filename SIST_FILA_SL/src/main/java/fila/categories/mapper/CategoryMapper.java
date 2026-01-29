package fila.categories.mapper;

import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.ibatis.annotations.Param;
import fila.categories.CategoriesDTO;

public interface CategoryMapper {
    // 모든 카테고리 목록 조회
    ArrayList<CategoriesDTO> selectCategoryList() throws SQLException;
    
    // 특정 카테고리 정보 조회
    CategoriesDTO selectCategory(@Param("categoryId") int categoryId) throws SQLException;
    
    // 하위 카테고리 목록 조회
    ArrayList<CategoriesDTO> selectChildCategories(@Param("parentId") int parentId) throws SQLException;
    
    // 메인 카테고리 조회 (Depth 1)
    ArrayList<CategoriesDTO> selectMainCategories() throws SQLException;
    
    // 태그 리스트 조회 (ID 4000번대 이상)
    ArrayList<CategoriesDTO> selectTagList() throws SQLException;
    
    // 활성화된 태그만 조회
    ArrayList<CategoriesDTO> selectActiveTagList() throws SQLException;
    
    // 태그 관리 로직
    int getMaxTagId() throws SQLException;
    int insertTag(CategoriesDTO dto) throws SQLException;
    int updateTag(@Param("categoryId") int categoryId, @Param("tagName") String tagName) throws SQLException;
    int updateTagStatus(@Param("categoryId") int categoryId, @Param("status") int status) throws SQLException;
}