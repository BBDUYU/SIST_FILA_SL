package fila.event_product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import fila.com.util.JdbcUtil;

public class EventproductDAO {
    
    private static EventproductDAO instance = new EventproductDAO();
    public static EventproductDAO getInstance() { return instance; }
    private EventproductDAO() {}


    public ArrayList<EventproductDTO> selectRecommendKeywords(Connection conn) throws SQLException {
        ArrayList<EventproductDTO> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String sqlEvent = "SELECT EVENT_NAME, SLUG, EVENT_ID FROM EVENT " +
                              "WHERE IS_ACTIVE = 1 " + 
                              "ORDER BY EVENT_ID DESC";
            
            pstmt = conn.prepareStatement(sqlEvent);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(EventproductDTO.builder()
                        .event_name(rs.getString("EVENT_NAME"))
                        .slug(rs.getString("SLUG"))
                        .event_id(rs.getInt("EVENT_ID"))
                        .build());
            }
            JdbcUtil.close(rs);

            String sqlProduct = "SELECT p.NAME, p.PRODUCT_ID FROM EVENT_PRODUCT ep " +
                                "JOIN PRODUCTS p ON ep.PRODUCT_ID = p.PRODUCT_ID " +
                                "AND ROWNUM <= 5";
            
            pstmt = conn.prepareStatement(sqlProduct);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(EventproductDTO.builder()
                        .name(rs.getString("NAME"))
                        .product_id(rs.getString("PRODUCT_ID"))
                        .build());
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }

 
    // 추천상품용
    public ArrayList<EventproductDTO> selectRecommendProducts(Connection conn) throws SQLException {
        ArrayList<EventproductDTO> list = new ArrayList<>();
        
        String sql = "SELECT * FROM ( " +
                "  SELECT p.PRODUCT_ID, p.NAME, p.PRICE, p.DISCOUNT_RATE, " +
                "  (SELECT IMAGE_URL FROM PRODUCT_IMAGE pi WHERE pi.PRODUCT_ID = p.PRODUCT_ID AND pi.IMAGE_TYPE = 'MAIN' AND ROWNUM = 1) as IMG " +
                "  FROM EVENT_PRODUCT ep " +
                "  JOIN PRODUCTS p ON ep.PRODUCT_ID = p.PRODUCT_ID " +
                "  ORDER BY p.PRODUCT_ID DESC " + // EVENT_PRODUCT_ID 대신 p.PRODUCT_ID 사용
                ") WHERE ROWNUM <= 12";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                String rawPath = rs.getString("IMG");
                // 중복 방지를 위한 정제 (C:\... 형태만 남기기)
                if (rawPath != null && rawPath.contains("path=")) {
                    rawPath = rawPath.split("path=")[1];
                }
                if (rawPath != null) {
                    rawPath = rawPath.replace("\\", "/");
                }

                list.add(EventproductDTO.builder()
                        .product_id(rs.getString("PRODUCT_ID"))
                        .name(rs.getString("NAME"))
                        .price(rs.getInt("PRICE"))
                        .discount_rate(rs.getInt("DISCOUNT_RATE"))
                        .mainImageUrl(rawPath) // [수정] 가져온 경로 세팅
                        .build());
            }
        }
        return list;
    }
}