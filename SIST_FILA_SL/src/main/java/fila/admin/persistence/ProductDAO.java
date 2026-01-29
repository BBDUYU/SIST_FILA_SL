package fila.admin.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import fila.admin.domain.ProductDTO;
import fila.com.util.JdbcUtil;

public class ProductDAO {
	private static ProductDAO instance = new ProductDAO();

    private ProductDAO() {}

    public static ProductDAO getInstance() {
        if (instance == null) {
            instance = new ProductDAO();
        }
        return instance;
    }
	public ArrayList<ProductDTO> selectProductList(Connection conn) throws SQLException {
	    ArrayList<ProductDTO> list = new ArrayList<>();
	    String sql = "SELECT p.PRODUCT_ID, p.NAME, c.NAME as CAT_NAME, p.PRICE, p.DISCOUNT_RATE, " +
	                 "p.STATUS, p.CREATED_AT, " +
	                 "(SELECT SUM(STOCK) FROM PRODUCT_OPTION_STOCK pos " +
	                 " JOIN PRODUCT_OPTION_COMBINATIONS poc ON pos.COMBINATION_ID = poc.COMBINATION_ID " +
	                 " WHERE poc.PRODUCT_ID = p.PRODUCT_ID) as TOTAL_STOCK, " +
	                 "(SELECT IMAGE_URL FROM PRODUCT_IMAGE pi WHERE pi.PRODUCT_ID = p.PRODUCT_ID AND pi.IS_MAIN = 1 AND ROWNUM = 1) as IMG " +
	                 "FROM PRODUCTS p " +
	                 "JOIN CATEGORIES c ON p.CATEGORY_ID = c.CATEGORY_ID " +
	                 "ORDER BY p.CREATED_AT DESC";

	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	     // ProductDAO.java 수정
	        while (rs.next()) {
	            String rawPath = rs.getString("IMG"); // DB값 가져오기
	            
	            if (rawPath != null && !rawPath.isEmpty()) {
	                if (rawPath.contains("path=")) {
	                    rawPath = rawPath.split("path=")[1];
	                }
	                rawPath = rawPath.replace("\\", "/");
	            }

	            ProductDTO dto = ProductDTO.builder()
	                    .productid(rs.getString("PRODUCT_ID"))
	                    .name(rs.getString("NAME"))
	                    .categoryName(rs.getString("CAT_NAME"))
	                    .price(rs.getInt("PRICE"))
	                    .discountRate(rs.getInt("DISCOUNT_RATE"))
	                    .status(rs.getString("STATUS"))
	                    .totalStock(rs.getInt("TOTAL_STOCK"))
	                    .mainImageUrl(rawPath) 
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
