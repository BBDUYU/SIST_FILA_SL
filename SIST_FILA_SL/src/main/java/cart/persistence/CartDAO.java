package cart.persistence;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import cart.domain.CartItemDTO;
import order.domain.OrderItemDTO;

public class CartDAO {
	private static CartDAO dao = null;
    private CartDAO() {}
    public static CartDAO getInstance() {
        if (dao == null) dao = new CartDAO();
        return dao;
    }

    // [1] 전체 조회
    public List<CartItemDTO> selectAll(Connection conn) throws Exception {
        String sql = "SELECT ci.cart_item_id, ci.user_number, ci.product_id, " +
                     "p.name AS product_name, p.price AS origin_unit_price, " +
                     "NVL(p.discount_rate, 0) AS discount_rate, " +
                     "ROUND(p.price * (100 - NVL(p.discount_rate,0)) / 100) AS sale_unit_price, " +
                     "ci.quantity, " +
                     "(ROUND(p.price * (100 - NVL(p.discount_rate,0)) / 100) * ci.quantity) AS line_amount, " +
                     "NULL AS main_image_url, " + // 임시 처리
                     "NULL AS size " +
                     "FROM cart_items ci " +
                     "JOIN products p ON ci.product_id = p.product_id";

        List<CartItemDTO> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                CartItemDTO dto = new CartItemDTO();
                dto.setCartItemId(rs.getInt("cart_item_id"));
                dto.setUserNumber(rs.getInt("user_number"));
                dto.setProductId(rs.getString("product_id"));
                dto.setProductName(rs.getString("product_name"));
                dto.setOriginUnitPrice(rs.getInt("origin_unit_price"));
                dto.setDiscountRate(rs.getInt("discount_rate"));
                dto.setSaleUnitPrice(rs.getInt("sale_unit_price"));
                dto.setSize(rs.getString("size"));
                dto.setQuantity(rs.getInt("quantity"));
                dto.setLineAmount(rs.getInt("line_amount"));
                dto.setMainImageUrl(rs.getString("main_image_url"));
                list.add(dto);
            }
        }
        return list;
    }

    // [2] 주문 전환용 조회 (중요: 테이블명을 CART_ITEMS로 통일)
    public List<OrderItemDTO> selectCartForOrder(Connection conn, int userNumber) throws SQLException {
        // p.NAME 컬럼을 추가로 조회합니다.
        String sql = "SELECT ci.PRODUCT_ID, p.NAME, ci.COMBINATION_ID, ci.QUANTITY, " +
                     "ROUND(p.price * (100 - NVL(p.discount_rate,0)) / 100) AS PRICE " +
                     "FROM CART_ITEMS ci " +
                     "JOIN PRODUCTS p ON ci.PRODUCT_ID = p.PRODUCT_ID " +
                     "WHERE ci.USER_NUMBER = ?"; 
        
        List<OrderItemDTO> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(OrderItemDTO.builder()
                            .productId(rs.getString("PRODUCT_ID"))
                            .productName(rs.getString("NAME")) // <-- 여기서 상품명을 담아줍니다!
                            .combinationId(rs.getInt("COMBINATION_ID"))
                            .quantity(rs.getInt("QUANTITY"))
                            .price(rs.getInt("PRICE"))
                            .build());
                }
            }
        }
        return list;
    }

    // [3] 장바구니 비우기 (Service에서 호출용)
    public void deleteCartAfterOrder(Connection conn, int userNumber) throws SQLException {
        String sql = "DELETE FROM CART_ITEMS WHERE USER_NUMBER = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNumber);
            pstmt.executeUpdate();
        }
    }

    // [4] 수량 변경 (Connection 추가)
    public int updateQuantity(Connection conn, int cartItemId, int quantity) throws Exception {
        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartItemId);
            return pstmt.executeUpdate();
        }
    }
    public List<OrderItemDTO> selectSelectedCartItems(Connection conn, String ids) throws SQLException {
        // p.PRICE는 정가, 계산된 값은 할인가(PRICE)로 가져옵니다.
        String sql = "SELECT ci.PRODUCT_ID, p.NAME, ci.COMBINATION_ID, ci.QUANTITY, " +
                     "p.PRICE AS ORIGINAL_PRICE, " + // 정가 추가
                     "ROUND(p.PRICE * (100 - NVL(p.DISCOUNT_RATE, 0)) / 100) AS SALE_PRICE " +
                     "FROM CART_ITEMS ci " +
                     "JOIN PRODUCTS p ON ci.PRODUCT_ID = p.PRODUCT_ID " +
                     "WHERE ci.CART_ITEM_ID IN (" + ids + ")";
        
        List<OrderItemDTO> list = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(OrderItemDTO.builder()
                        .productId(rs.getString("PRODUCT_ID"))
                        .productName(rs.getString("NAME"))
                        .combinationId(rs.getInt("COMBINATION_ID"))
                        .quantity(rs.getInt("QUANTITY"))
                        .originalPrice(rs.getInt("ORIGINAL_PRICE")) // 정가 세팅
                        .price(rs.getInt("SALE_PRICE"))             // 할인가 세팅
                        .build());
            }
        }
        return list;
    }
    public void deleteCartItems(Connection conn, String cartItemIds, int userNumber) throws Exception {
        // 1. 테이블명: CART -> CART_ITEMS
        // 2. 컬럼명: CART_ID -> CART_ITEM_ID
        String sql = "DELETE FROM CART_ITEMS WHERE USER_NUMBER = ? AND CART_ITEM_ID IN (" + cartItemIds + ")";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNumber);
            pstmt.executeUpdate();
            System.out.println("장바구니 삭제 완료: " + cartItemIds);
        } catch (SQLException e) {
            System.out.println("장바구니 삭제 중 DB 에러: " + e.getMessage());
            throw e;
        }
    }
}