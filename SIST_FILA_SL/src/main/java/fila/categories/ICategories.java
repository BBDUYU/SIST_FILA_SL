package fila.categories;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import fila.categories.CategoriesDTO;

public interface ICategories {
    // 카테고리 목록 조회
    ArrayList<CategoriesDTO> selectCategoryList(Connection conn) throws SQLException;
    
    // 1. 특정 카테고리 하나 조회 (ID로)
    CategoriesDTO selectCategory(Connection conn, int categoryId) throws SQLException;
    
    // 2. 하위/형제 카테고리 목록 조회 (사이드바용)
    ArrayList<CategoriesDTO> selectChildCategories(Connection conn, int parentId) throws SQLException;
    int updateTag(Connection conn, int categoryId, String tagName) throws SQLException;
    int updateTagStatus(Connection conn, int categoryId,int status) throws SQLException;
}