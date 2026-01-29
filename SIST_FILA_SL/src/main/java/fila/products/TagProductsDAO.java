package fila.products;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import fila.com.util.JdbcUtil;

public class TagProductsDAO {
    
    private static TagProductsDAO instance = new TagProductsDAO();
    public static TagProductsDAO getInstance() { return instance; }
    private TagProductsDAO() {}

    /**
     * 특정 인기 태그(CategoryId)에 속한 상품 목록 조회
     */
    public List<ProductsDTO> selectProductsByTag(Connection conn, int tagId) throws SQLException {
        List<ProductsDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = " SELECT P.PRODUCT_ID, P.NAME, P.PRICE, P.DISCOUNT_RATE, P.STATUS, "
                   + "        P.CATEGORY_ID, I.IMAGE_URL " 
                   + " FROM PRODUCTS P "
                   + " LEFT JOIN PRODUCT_IMAGE I ON P.PRODUCT_ID = I.PRODUCT_ID AND I.IS_MAIN = 1 "
                   + " WHERE P.PRODUCT_ID IN ( "
                   + "     SELECT PRODUCT_ID FROM PRODUCT_CATEGORY_REL WHERE CATEGORY_ID = ? "
                   + " ) "
                   + " AND P.STATUS != 'SOLDOUT' "
                   + " ORDER BY P.CREATED_AT DESC ";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, tagId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(makeDTO(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }

    // 기존 ProductsDAO의 makeDTO 로직을 그대로 가져와서 호환성 유지
    private ProductsDTO makeDTO(ResultSet rs) throws SQLException {
        ProductsDTO dto = new ProductsDTO();
        dto.setProduct_id(rs.getString("PRODUCT_ID"));
        dto.setName(rs.getString("NAME"));
        dto.setPrice(rs.getInt("PRICE"));
        dto.setDiscount_rate(rs.getInt("DISCOUNT_RATE"));
        dto.setStatus(rs.getString("STATUS"));
        dto.setCategory_id(rs.getInt("CATEGORY_ID")); 
        
        String img = rs.getString("IMAGE_URL");
        // 이미지 없는 경우 기본 휠라 이미지 세팅
        if(img == null) img = "//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS261FT01X001_234.jpg"; 
        dto.setImage_url(img);
        
        return dto;
    }
}