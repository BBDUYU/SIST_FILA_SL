package fila.order.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import fila.order.domain.OrderDTO;
import fila.order.domain.OrderItemDTO;

public class OrderDAO {

    private static OrderDAO dao = null;
    private OrderDAO() {}
    public static OrderDAO getInstance() {
        if (dao == null) dao = new OrderDAO();
        return dao;
    }

    /**
     * 1. 주문번호 생성 (오늘날짜 + 시퀀스 조합 등)
     * 예: 20260108-0001
     */
    public String generateOrderId(Connection conn) throws SQLException {
        String sql = "SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(SEQ_ORDER_ID.NEXTVAL, 4, '0') FROM DUAL";
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getString(1);
        }
        return null;
    }

    /**
     * 2. ORDERS 테이블 INSERT (주문 기본 정보)
     */
    public int insertOrder(Connection conn, OrderDTO dto) throws SQLException {
        String sql = "INSERT INTO ORDERS (ORDER_ID, USER_NUMBER, ADDRESS_ID, TOTAL_AMOUNT, "
                   + "ORDER_STATUS, CREATED_AT, DELIVERY_METHOD, DELIVERY_REQUEST) "
                   + "VALUES (?, ?, ?, ?, '결제완료', SYSDATE, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dto.getOrderId());
            pstmt.setInt(2, dto.getUserNumber());
            pstmt.setInt(3, dto.getAddressId());
            pstmt.setInt(4, dto.getTotalAmount());
            pstmt.setString(5, dto.getDeliveryMethod());
            pstmt.setString(6, dto.getDeliveryRequest());
            return pstmt.executeUpdate();
        }
    }

    /**
     * 3. ORDER_ITEMS 테이블 INSERT (주문 상품 목록 - Batch 사용)
     */
    public void insertOrderItems(Connection conn, List<OrderItemDTO> items) throws SQLException {
        String sql = "INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ID, PRODUCT_ID, "
                   + "COMBINATION_ID, QUANTITY, PRICE, CANCEL_STATUS, STATUS_UPDATED_AT) "
                   + "VALUES (SEQ_ORDER_ITEM.NEXTVAL, ?, ?, ?, ?, ?, 'N', SYSDATE)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (OrderItemDTO item : items) {
                pstmt.setString(1, item.getOrderId());
                pstmt.setString(2, item.getProductId());
                if (item.getCombinationId() > 0) {
                    pstmt.setInt(3, item.getCombinationId());
                } else {
                    pstmt.setNull(3, java.sql.Types.NUMERIC);
                }
                pstmt.setInt(4, item.getQuantity());
                pstmt.setInt(5, item.getPrice());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    /**
     * 4. PAYMENT 테이블 INSERT (결제 기록)
     */
    public int insertPayment(Connection conn, String orderId, int amount, String method) throws SQLException {
        String sql = "INSERT INTO PAYMENT (PAYMENT_ID, ORDER_ID, AMOUNT, PAYMENT_METHOD, "
                   + "PAYMENT_STATUS, PAID_AT) "
                   + "VALUES (SEQ_PAYMENT.NEXTVAL, ?, ?, ?, 'PAID', SYSDATE)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, orderId);
            pstmt.setInt(2, amount);
            pstmt.setString(3, method);
            return pstmt.executeUpdate();
        }
    }

    /**
     * 5. 쿠폰 사용 처리 (USER_COUPON 상태 업데이트)
     */
    public void updateCouponUsed(Connection conn, int userCouponId) throws SQLException {
        String sql = "UPDATE USER_COUPON SET IS_USED = 1, USED_AT = SYSDATE WHERE USER_COUPON_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userCouponId);
            pstmt.executeUpdate();
        }
    }

    public void insertPointHistory(Connection conn, int userNumber, String orderId, int usedAmount) throws SQLException {
        String sql = "INSERT INTO USERPOINTS (POINT_ID, USER_NUMBER, ORDER_ID, POINT_TYPE, AMOUNT, BALANCE, DESCRIPTION, CREATED_AT) "
                   + "VALUES (SEQ_POINT.NEXTVAL, ?, ?, 'USED', ?, "
                   + "(SELECT NVL((SELECT BALANCE FROM (SELECT BALANCE FROM USERPOINTS WHERE USER_NUMBER = ? ORDER BY POINT_ID DESC) WHERE ROWNUM = 1), 0) - ? FROM DUAL), "
                   + "'상품 구매 사용', SYSDATE)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNumber);
            pstmt.setString(2, orderId);
            pstmt.setInt(3, -usedAmount);
            pstmt.setInt(4, userNumber); // 서브쿼리용
            pstmt.setInt(5, usedAmount); // 차감액
            pstmt.executeUpdate();
        }
    }
    /* 재고 관련 DAO 메서드 */
    public int updateDecreaseStock(Connection conn, int combinationId, int quantity) throws SQLException {
        String sql = "UPDATE PRODUCT_OPTION_STOCK " +
                     "SET STOCK = STOCK - ?, " +
                     "    IS_SOLDOUT = CASE WHEN (STOCK - ?) <= 0 THEN 1 ELSE 0 END " +
                     "WHERE COMBINATION_ID = ? AND STOCK >= ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, quantity);
            pstmt.setInt(3, combinationId);
            pstmt.setInt(4, quantity); // 재고가 주문수량보다 많을 때만 실행
            return pstmt.executeUpdate();
        }
    }

    public void insertOrderPoint(Connection conn, int userNumber, int amount, String orderId) throws SQLException {
        String sql = "INSERT INTO USERPOINTS (POINT_ID, USER_NUMBER, ORDER_ID, AMOUNT, POINT_TYPE, BALANCE, DESCRIPTION, CREATED_AT) "
                   + "VALUES (SEQ_POINT.NEXTVAL, ?, ?, ?, 'EARN', "
                   + "(SELECT NVL((SELECT BALANCE FROM (SELECT BALANCE FROM USERPOINTS WHERE USER_NUMBER = ? ORDER BY POINT_ID DESC) WHERE ROWNUM = 1), 0) + ? FROM DUAL), "
                   + "?, SYSDATE)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userNumber);
            pstmt.setString(2, orderId);
            pstmt.setInt(3, amount);
            pstmt.setInt(4, userNumber); // 서브쿼리용
            pstmt.setInt(5, amount);    // 적립액
            pstmt.setString(6, "주문 번호[" + orderId + "] 결제 적립(5%)");
            pstmt.executeUpdate();
        }
    }
    /**
     * 6. 주문 목록 조회 (관리자/사용자 공용)
     */
 // OrderDAO.java 내의 메서드 수정

    public List<OrderDTO> selectUserOrderList(Connection conn, int userNumber, String type) throws SQLException {
        List<OrderDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ORDERS WHERE USER_NUMBER = ? ");

        if ("ORDER".equals(type)) {
            sql.append(" AND ORDER_STATUS IN ('결제완료', '상품준비중', '배송준비중', '배송중', '배송완료') ");
        } 
        else if ("CANCEL".equals(type)) {
            sql.append(" AND ORDER_STATUS IN ('취소요청', '반품요청', '취소완료', '반품완료') ");
        }

        sql.append(" ORDER BY CREATED_AT DESC ");

        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setInt(1, userNumber); // 파라미터 설정을 고정
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderDTO dto = new OrderDTO();
                    dto.setOrderId(rs.getString("ORDER_ID"));
                    dto.setTotalAmount(rs.getInt("TOTAL_AMOUNT"));
                    dto.setOrderStatus(rs.getString("ORDER_STATUS"));
                    dto.setCreatedAt(rs.getTimestamp("CREATED_AT"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    /**
     * 7. 관리자 전용: 주문 상태 및 송장 번호 업데이트
     */
    public int updateOrderStatus(Connection conn, String orderId, String status) throws SQLException {
        String sql = "UPDATE ORDERS SET ORDER_STATUS = ?, UPDATED_AT = SYSDATE WHERE ORDER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, orderId);
            return pstmt.executeUpdate();
        }
    }
    /**
     * 특정 주문의 상세 상품 목록 조회
     */
    public List<OrderItemDTO> selectOrderItemsDetail(Connection conn, String orderId) throws SQLException {
        List<OrderItemDTO> list = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT i.PRODUCT_ID, p.NAME AS PRODUCT_NAME, i.QUANTITY, i.PRICE,i.COMBINATION_ID, ");
        sql.append("       v.VALUE_NAME AS OPTION_SIZE ");
        sql.append("FROM ORDER_ITEMS i ");
        sql.append("JOIN PRODUCTS p ON i.PRODUCT_ID = p.PRODUCT_ID "); 
        sql.append("LEFT JOIN PRODUCT_OPTION_COMBI_VALUES cv ON i.COMBINATION_ID = cv.COMBINATION_ID ");
        sql.append("LEFT JOIN PRODUCT_OPTION_VALUES v ON cv.VALUE_ID = v.VALUE_ID ");
        sql.append("WHERE i.ORDER_ID = ? ");

        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setString(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItemDTO item = OrderItemDTO.builder()
                        .productId(rs.getString("PRODUCT_ID"))
                        .productName(rs.getString("PRODUCT_NAME")) 
                        .quantity(rs.getInt("QUANTITY"))
                        .price(rs.getInt("PRICE"))
                        .combinationId(rs.getInt("COMBINATION_ID"))
                        .size(rs.getString("OPTION_SIZE") == null ? "기본" : rs.getString("OPTION_SIZE"))
                        .build();
                    list.add(item);
                }
            }
        }
        return list;
    }
    public int updateIncreaseStock(Connection conn, int combinationId, int quantity) throws SQLException {
        String sql = "UPDATE PRODUCT_OPTION_STOCK " +
                     "SET STOCK = STOCK + ?, " +
                     "    IS_SOLDOUT = CASE WHEN (STOCK + ?) > 0 THEN 0 ELSE 1 END " +
                     "WHERE COMBINATION_ID = ? AND STORE_ID = 4"; // 매장 ID 조건 확인 필요
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, quantity);
            pstmt.setInt(3, combinationId);
            return pstmt.executeUpdate();
        }
    }
 // OrderDAO.java 하단에 추가
    public void updateMasterCouponStatus(Connection conn, int userCouponId) throws SQLException {
        // 유저가 가진 쿠폰 ID(userCouponId)를 통해 해당 마스터 쿠폰(COUPON_ID)을 찾아 STATUS를 'N'으로 변경
        String sql = "UPDATE COUPON SET STATUS = 'N' " +
                     "WHERE COUPON_ID = (SELECT COUPON_ID FROM USER_COUPON WHERE USER_COUPON_ID = ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userCouponId);
            pstmt.executeUpdate();
        }
    }//이건안씀
    /**
     * 주문번호로 주문 마스터 정보 단건 조회 (주문 완료/상세 페이지용)
     */
    public OrderDTO selectOrderById(Connection conn, String orderId) throws SQLException {
    	String sql = "SELECT o.*, a.RECIPIENT_NAME, a.RECIPIENT_PHONE, a.ZIPCODE, a.MAIN_ADDR, a.DETAIL_ADDR, p.PAYMENT_METHOD " +
                "FROM ORDERS o " +
                "JOIN DELIVERY_ADDRESS a ON o.ADDRESS_ID = a.ADDRESS_ID " +
                "LEFT JOIN PAYMENT p ON o.ORDER_ID = p.ORDER_ID " + // 결제 정보 조인 추가
                "WHERE o.ORDER_ID = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return OrderDTO.builder()
                            .orderId(rs.getString("ORDER_ID"))
                            .totalAmount(rs.getInt("TOTAL_AMOUNT"))
                            .orderStatus(rs.getString("ORDER_STATUS"))
                            .deliveryMethod(rs.getString("DELIVERY_METHOD"))
                            .deliveryRequest(rs.getString("DELIVERY_REQUEST"))
                            .createdAt(rs.getTimestamp("CREATED_AT"))
                            .recipientName(rs.getString("RECIPIENT_NAME"))
                            .recipientPhone(rs.getString("RECIPIENT_PHONE"))
                            .address("(" + rs.getString("ZIPCODE") + ") " + rs.getString("MAIN_ADDR") + " " + rs.getString("DETAIL_ADDR"))
                            .paymentMethod(rs.getString("PAYMENT_METHOD"))
                            .build();
                }
            }
        }
        return null;
    }
}