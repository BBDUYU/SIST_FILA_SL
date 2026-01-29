package fila.cart.service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import fila.cart.domain.CartItemDTO;
import fila.com.util.ConnectionProvider; 

public class CartListService {

	// [1] 장바구니 담기
	public void insertCart(String productId, int quantity, int userNumber, int combinationId) throws Exception {

	    // 시퀀스가 있다면 시퀀스 사용을 권장하지만, 현재 방식(MAX+1)을 유지합니다.
	    String insertSql =
	        "INSERT INTO CART_ITEMS (CART_ITEM_ID, USER_NUMBER, PRODUCT_ID, COMBINATION_ID, QUANTITY, ADDED_AT) " +
	        "VALUES ((SELECT NVL(MAX(CART_ITEM_ID), 0) + 1 FROM CART_ITEMS), ?, ?, ?, ?, SYSDATE)";

	    try (Connection conn = ConnectionProvider.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(insertSql)) {

	        pstmt.setInt(1, userNumber);
	        pstmt.setString(2, productId);

	        // ✅ 화면에서 직접 넘어온 combinationId를 그대로 사용합니다.
	        // 만약 combinationId가 0이거나 유효하지 않은 값으로 넘어올 경우를 대비해 처리합니다.
	        if (combinationId > 0) {
	            pstmt.setInt(3, combinationId);
	        } else {
	            pstmt.setNull(3, java.sql.Types.NUMERIC);
	        }

	        pstmt.setInt(4, quantity);
	        pstmt.executeUpdate();
	    }
	}

    // [2] 전체 조회 (selectAll)
	public List<CartItemDTO> selectAll(int userNumber) throws Exception { // 인자 추가!
	    // 🚩 쿼리 수정: 복잡한 중간 테이블 생략하고 직접 사이즈 명칭을 가져옵니다.
	    String sql = 
	        "SELECT " +
	        "  ci.cart_item_id, ci.user_number, ci.product_id, p.name AS product_name, " +
	        "  p.price AS origin_unit_price, NVL(p.discount_rate, 0) AS discount_rate, " +
	        "  ROUND(p.price * (100 - NVL(p.discount_rate,0)) / 100) AS sale_unit_price, " +
	        "  ci.quantity, " +
	        "  (ROUND(p.price * (100 - NVL(p.discount_rate,0)) / 100) * ci.quantity) AS line_amount, " +
	        "  (SELECT MAX(pi.image_url) FROM product_image pi WHERE pi.product_id = p.product_id AND pi.is_main = 1) AS main_image_url, " +
	        "  ovm.value_name AS option_size " +
	        "FROM cart_items ci " +
	        "JOIN products p ON p.product_id = ci.product_id " +
	        "LEFT JOIN product_option_combinations poc ON ci.combination_id = poc.combination_id " +
	        "LEFT JOIN product_option_combi_values pocv ON poc.combination_id = pocv.combination_id " +
	        "LEFT JOIN product_option_values pov ON pocv.value_id = pov.value_id " +
	        "LEFT JOIN option_value_masters ovm ON pov.v_master_id = ovm.v_master_id " +
	        "WHERE ci.user_number = ? " + // 🚩 본인 데이터만 조회
	        "ORDER BY ci.added_at DESC";

	    List<CartItemDTO> list = new ArrayList<>();

	    try (Connection conn = ConnectionProvider.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userNumber); // 🚩 유저 번호 세팅
	        
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                CartItemDTO dto = new CartItemDTO();
	                dto.setCartItemId(rs.getInt("cart_item_id"));
	                dto.setUserNumber(rs.getInt("user_number"));
	                dto.setProductId(rs.getString("product_id"));
	                dto.setProductName(rs.getString("product_name"));
	                dto.setOriginUnitPrice(rs.getInt("origin_unit_price"));
	                dto.setDiscountRate(rs.getInt("discount_rate"));
	                dto.setSaleUnitPrice(rs.getInt("sale_unit_price"));
	                dto.setQuantity(rs.getInt("quantity"));
	                dto.setLineAmount(rs.getInt("line_amount"));
	                dto.setMainImageUrl(rs.getString("main_image_url"));
	                dto.setSize(rs.getString("option_size")); 
	                list.add(dto);
	            }
	        }
	    }
	    return list;
	}



    
	private Integer findCombinationIdBySize(Connection conn, String productId, String size) throws Exception {
	    String sql =
	        "SELECT poc.combination_id " +
	        "FROM product_option_combinations poc " +
	        "JOIN product_option_combi_values pocv ON poc.combination_id = pocv.combination_id " +
	        "JOIN product_option_values pov ON pocv.value_id = pov.value_id " +
	        "WHERE poc.product_id = ? " +
	        "  AND TRIM(pov.value_name) = ?"; // 공백 문제를 방지하기 위해 TRIM 사용

	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, productId);
	        pstmt.setString(2, size.trim());

	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt("combination_id");
	            }
	        }
	    }
	    return null;
	}



    // [3] 선택 삭제 (deleteItems)
    public void deleteItems(String ids) throws Exception {
        if (ids == null || ids.trim().isEmpty()) return;
        String sql = "DELETE FROM cart_items WHERE cart_item_id IN (" + ids + ")";
        
        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.executeUpdate();
            if (!conn.getAutoCommit()) conn.commit();
        }
    }

    // [4] 전체 삭제
    public void deleteAllItems(int userNumber) throws Exception {
        String sql = "DELETE FROM cart_items WHERE user_number = ?";

        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userNumber);
            pstmt.executeUpdate();
        }
    }

    
    // [5] 수량 변경 (updateItem)
    public void updateItem(int cartItemId, int quantity) throws Exception {
        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try (Connection conn = ConnectionProvider.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartItemId);
            pstmt.executeUpdate();
            if (!conn.getAutoCommit()) conn.commit();
        } catch (SQLException e) {
            System.err.println("수량 변경 중 에러: " + e.getMessage());
            throw e;
        }
    }
 // [6] 옵션 및 수량 통합 변경
    public void updateItemOption(int cartItemId, String size, int qty) throws Exception {
        String getPidSql = "SELECT product_id FROM cart_items WHERE cart_item_id = ?";
        String updateSql = "UPDATE cart_items SET combination_id = ?, quantity = ? WHERE cart_item_id = ?";

        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String productId = null;
                try (PreparedStatement pstmt = conn.prepareStatement(getPidSql)) {
                    pstmt.setInt(1, cartItemId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) productId = rs.getString("product_id");
                    }
                }

                System.out.println("디버깅 - cartItemId: " + cartItemId + ", productId: " + productId + ", size: [" + size + "]");

                if (productId != null) {
                    // [중요] 사이즈 앞뒤 공백 제거
                    Integer newCombiId = findCombinationIdBySize(conn, productId, size.trim());
                    System.out.println("디버깅 - 찾아낸 newCombiId: " + newCombiId);

                    if (newCombiId != null) {
                        try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                            pstmt.setInt(1, newCombiId);
                            pstmt.setInt(2, qty);
                            pstmt.setInt(3, cartItemId);
                            int rowCount = pstmt.executeUpdate();
                            System.out.println("디버깅 - 업데이트된 행 개수: " + rowCount);
                        }
                    } else {
                        System.out.println("결과 - 해당 사이즈에 맞는 combination_id를 찾지 못함");
                    }
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace(); // 여기서 에러가 찍힐 수 있음
                throw e;
            }
        }
    }
}