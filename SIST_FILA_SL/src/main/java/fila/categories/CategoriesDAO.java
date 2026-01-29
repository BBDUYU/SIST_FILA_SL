package fila.categories;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import fila.com.util.JdbcUtil;

public class CategoriesDAO implements ICategories {
    private CategoriesDAO() {}
    private static CategoriesDAO instance = new CategoriesDAO();
    public static CategoriesDAO getInstance() { return instance; }

    @Override
    public ArrayList<CategoriesDTO> selectCategoryList(Connection conn) throws SQLException {
        String sql = "SELECT * FROM categories WHERE use_yn = 1 ORDER BY depth, category_id";
        ArrayList<CategoriesDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CategoriesDTO dto = CategoriesDTO.builder()
                        .category_id(rs.getInt("category_id"))
                        .name(rs.getString("name"))
                        .parent_id(rs.getInt("parent_id"))
                        .depth(rs.getInt("depth"))
                        .created_at(rs.getDate("created_at"))
                        .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    
    // 특정 카테고리 정보 조회 (ID로 검색)
    @Override
    public CategoriesDTO selectCategory(Connection conn, int categoryId) throws SQLException {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        CategoriesDTO dto = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = CategoriesDTO.builder()
                        .category_id(rs.getInt("category_id"))
                        .name(rs.getString("name"))
                        .parent_id(rs.getInt("parent_id"))
                        .depth(rs.getInt("depth"))
                        .build();
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return dto;
    }
    
    // 하위/형제 카테고리 목록 조회 (사이드바 출력용)
    @Override
    public ArrayList<CategoriesDTO> selectChildCategories(Connection conn, int parentId) throws SQLException {
        String sql = "SELECT * FROM categories WHERE parent_id = ? AND use_yn = 1 ORDER BY category_id ASC";
        ArrayList<CategoriesDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, parentId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CategoriesDTO dto = CategoriesDTO.builder()
                        .category_id(rs.getInt("category_id"))
                        .name(rs.getString("name"))
                        .parent_id(rs.getInt("parent_id"))
                        .depth(rs.getInt("depth"))
                        .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    public ArrayList<CategoriesDTO> selectMainCategories(Connection conn) throws SQLException {
        // depth가 1인 것만 가져옵니다 (FEMALE, MALE, KIDS)
        String sql = "SELECT * FROM categories WHERE depth = 1 AND use_yn = 1 ORDER BY category_id ASC";

        ArrayList<CategoriesDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CategoriesDTO dto = CategoriesDTO.builder()
                        .category_id(rs.getInt("category_id"))
                        .name(rs.getString("name"))
                        .parent_id(rs.getInt("parent_id"))
                        .depth(rs.getInt("depth"))
                        .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    public ArrayList<CategoriesDTO> selectTagList(Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<CategoriesDTO> list = new ArrayList<>();
        
        String sql = "SELECT * FROM CATEGORIES WHERE CATEGORY_ID >= 4000 AND DEPTH = 4 ORDER BY CATEGORY_ID DESC";
        
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CategoriesDTO dto = CategoriesDTO.builder()
                    .category_id(rs.getInt("category_id"))
                    .name(rs.getString("name"))
                    .parent_id(rs.getInt("parent_id"))
                    .depth(rs.getInt("depth"))
                    .created_at(rs.getDate("created_at"))
                    .updated_at(rs.getDate("updated_at"))
                    .use_yn(rs.getInt("use_yn"))
                    .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    public int getMaxTagId(Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT MAX(CATEGORY_ID) FROM CATEGORIES WHERE CATEGORY_ID >= 4000 AND CATEGORY_ID < 5000";
        
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int maxId = rs.getInt(1);
                if (maxId == 0) return 4000; 
                return maxId;
            }
            return 4000;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }

    public int insertTag(Connection conn, CategoriesDTO dto) throws SQLException {
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO CATEGORIES (CATEGORY_ID, NAME, DEPTH, CREATED_AT, UPDATED_AT, USE_YN) " +
                     "VALUES (?, ?, 4, SYSDATE, SYSDATE, 1)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getCategory_id());
            pstmt.setString(2, dto.getName());
            return pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
 // 태그 수정 (이름 변경 및 수정일 업데이트)
    public int updateTag(Connection conn, int categoryId, String tagName) throws SQLException {
        PreparedStatement pstmt = null;
        String sql = "UPDATE CATEGORIES SET NAME = ?, UPDATED_AT = SYSDATE WHERE CATEGORY_ID = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, tagName);
            pstmt.setInt(2, categoryId);
            return pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }


 // 태그 상태 변경 (활성화/비활성화 통합)
    public int updateTagStatus(Connection conn, int categoryId, int status) throws SQLException {
        PreparedStatement pstmt = null;
        String sql = "UPDATE CATEGORIES SET USE_YN = ?, UPDATED_at = SYSDATE WHERE CATEGORY_ID = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            pstmt.setInt(2, categoryId);
            return pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
 // 활성화된 태그만 조회하는 메서드 추가
    public ArrayList<CategoriesDTO> selectActiveTagList(Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<CategoriesDTO> list = new ArrayList<>();
        
        String sql = "SELECT * FROM CATEGORIES WHERE CATEGORY_ID >= 4000 AND DEPTH = 4 AND USE_YN = 1 ORDER BY CATEGORY_ID DESC";
        
        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CategoriesDTO dto = CategoriesDTO.builder()
                    .category_id(rs.getInt("category_id"))
                    .name(rs.getString("name"))
                    .parent_id(rs.getInt("parent_id"))
                    .depth(rs.getInt("depth"))
                    .created_at(rs.getDate("created_at"))
                    .updated_at(rs.getDate("updated_at"))
                    .use_yn(rs.getInt("use_yn"))
                    .build();
                list.add(dto);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
}