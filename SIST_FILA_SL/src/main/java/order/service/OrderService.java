package order.service;

import java.sql.Connection;
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import order.domain.OrderDTO;
import order.domain.OrderItemDTO;
import order.persistence.OrderDAO;

public class OrderService {
    private OrderService() {}
    private static OrderService instance = new OrderService();
    public static OrderService getInstance() { return instance; }

    private OrderDAO orderDao = OrderDAO.getInstance();
    
    // 장바구니 비우기 등을 위해 필요 (기존에 만드신 DAO가 있다면 사용)
    // private CartListDAO cartDao = CartListDAO.getInstance();

    /**
     * [결제 프로세스 통합 관리]
     * @param order 주문 기본 정보 및 결제 수단
     * @param items 주문할 상품 리스트
     * @return 생성된 주문번호
     */
    public String processOrder(OrderDTO order, List<OrderItemDTO> items, String cartItemIds) {
        Connection conn = null;
        String generatedOrderId = null;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 🚩 트랜잭션 시작

            // 1. 주문번호 생성
            generatedOrderId = orderDao.generateOrderId(conn);
            order.setOrderId(generatedOrderId);

            // 2. ORDERS 테이블 저장
            orderDao.insertOrder(conn, order);

            // 3. ORDER_ITEMS 테이블 저장 (Batch 실행)
            for (OrderItemDTO item : items) {
                item.setOrderId(generatedOrderId); // 생성된 주문번호 매핑
            }
            orderDao.insertOrderItems(conn, items);
            for (OrderItemDTO item : items) {
                int stockResult = orderDao.updateDecreaseStock(conn, item.getCombinationId(), item.getQuantity());
                if (stockResult == 0) {
                    // 재고가 부족하거나 없으면 예외를 던져 Catch문으로 이동(롤백)시킴
                    throw new RuntimeException("상품[" + item.getCombinationId() + "]의 재고가 부족합니다.");
                }
            }
            // 4. PAYMENT 테이블 저장
            orderDao.insertPayment(conn, generatedOrderId, order.getTotalAmount(), order.getPaymentMethod());

         // 5. 포인트 사용 처리 (사용한 포인트가 0보다 크면)
         // OrderService.java 일부

            if (order.getUsedPoint() > 0) {
                // [CASE 1] 포인트 사용 시: 차감만 하고 '적립 로직'은 아예 실행 안 함
                orderDao.insertPointHistory(conn, order.getUserNumber(), generatedOrderId, order.getUsedPoint());
            } else {
                // [CASE 2] 포인트 미사용 시: 5% 적립 수행
                int rewardPoint = (int)(order.getTotalAmount() * 0.05);
                if (rewardPoint > 0) {
                    orderDao.insertOrderPoint(conn, order.getUserNumber(), rewardPoint, generatedOrderId);
                }
            }
            System.out.println("DEBUG: 전달된 쿠폰 ID = " + order.getUserCouponId());
            // 6. 쿠폰 사용 처리 (쿠폰을 선택했을 경우만)
            if (order.getUserCouponId() > 0) {
            	System.out.println("DEBUG: 쿠폰 업데이트 시작!");
                orderDao.updateCouponUsed(conn, order.getUserCouponId());
            }
            
            // 7. 장바구니 비우기 (주문 완료된 상품들)
            if (cartItemIds != null && !cartItemIds.isEmpty()) {
                cart.persistence.CartDAO cartDao = cart.persistence.CartDAO.getInstance();
                cartDao.deleteCartItems(conn, cartItemIds, order.getUserNumber());
            }
            conn.commit(); // ✅ 모든 작업 성공 시 최종 확정
            System.out.println("✅ 주문 완료: " + generatedOrderId);

        } catch (Exception e) {
            JdbcUtil.rollback(conn); // ❌ 하나라도 실패 시 전체 롤백
            e.printStackTrace();
            throw new RuntimeException("주문 처리 중 오류 발생: " + e.getMessage());
        } finally {
            JdbcUtil.close(conn);
        }

        return generatedOrderId;
    }
    public List<OrderDTO> getUserOrderList(int userNumber) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            
            // 🚩 수정 포인트 1: 메서드명을 selectUserOrderList로 변경 (DAO와 일치)
            // 🚩 수정 포인트 2: 세 번째 인자에 null을 넣어 상태 필터 없이 전체 조회
            return orderDao.selectUserOrderList(conn, userNumber, null);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("주문 내역 조회 중 오류 발생");
        } finally {
            JdbcUtil.close(conn);
        }
    }
    public boolean cancelOrder(String orderId, String targetStatus) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 🚩 트랜잭션 시작

            // 1. 해당 주문의 상품 리스트와 수량, combinationId를 가져옴
            List<OrderItemDTO> items = orderDao.selectOrderItemsDetail(conn, orderId);

            // 2. 주문 상태를 '취소완료' 등으로 업데이트
            orderDao.updateOrderStatus(conn, orderId, targetStatus);

            // 3. 재고 복구 로직 (취소완료인 경우에만 재고를 돌려줌)
            if ("취소완료".equals(targetStatus)) {
                for (OrderItemDTO item : items) {
                    // combinationId가 있는 옵션 상품인 경우에만 재고 복구
                    if (item.getCombinationId() > 0) {
                        orderDao.updateIncreaseStock(conn, item.getCombinationId(), item.getQuantity());
                    }
                }
            }

            conn.commit(); // ✅ 성공 시 커밋
            return true;
        } catch (Exception e) {
            JdbcUtil.rollback(conn); // ❌ 실패 시 롤백
            e.printStackTrace();
            return false;
        } finally {
            JdbcUtil.close(conn);
        }
    }
 // 주문 상세 정보 가져오기 (주문 완료 페이지용)
    public OrderDTO getOrderDetail(String orderId) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            // 1. 주문 기본 정보 조회
            OrderDTO order = orderDao.selectOrderById(conn, orderId);
            
            if (order != null) {
                // 2. 주문한 상품 목록 조회 (이미 DAO에 있는 메서드 활용)
                List<OrderItemDTO> items = orderDao.selectOrderItemsDetail(conn, orderId);
                order.setOrderItems(items); // OrderDTO에 List<OrderItemDTO> 필드가 있어야 합니다.
            }
            
            return order;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("주문 상세 조회 중 오류 발생");
        } finally {
            JdbcUtil.close(conn);
        }
    }
    
}