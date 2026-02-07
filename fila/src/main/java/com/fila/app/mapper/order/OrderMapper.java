package com.fila.app.mapper.order;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.order.OrderItemVO;
import com.fila.app.domain.order.OrderVO;

public interface OrderMapper {

	// 1. 주문번호 생성
    String generateOrderId();

    // 2. ORDERS INSERT
    int insertOrder(OrderVO dto);

    // 3. ORDER_ITEMS INSERT (Batch)
    int insertOrderItems(@Param("items") List<OrderItemVO> items);

    // 4. PAYMENT INSERT
    void insertPayment(
    	    @Param("orderId") String orderId, 
    	    @Param("amount") int amount, 
    	    @Param("paymentMethod") String paymentMethod // XML의 #{paymentMethod}와 이름을 맞춤
    	);
    // 5. 쿠폰 사용 처리
    int updateCouponUsed(@Param("userCouponId") int userCouponId);

    // 포인트 사용 내역 INSERT
    void insertPointHistory(
    	    @Param("userNumber") int userNumber, 
    	    @Param("orderId") String orderId, 
    	    @Param("usedPoint") int usedPoint
    	);
    // 주문 적립 포인트 INSERT
    void insertOrderPoint(
    	    @Param("userNumber") int userNumber, 
    	    @Param("rewardPoint") int rewardPoint, 
    	    @Param("orderId") String orderId
    	);
    // 재고 차감
    int updateDecreaseStock(@Param("combinationId") int combinationId,
                            @Param("quantity") int quantity);

    int getUserPointBalance(@Param("userNumber") int userNumber);
   

    // 6. 주문 목록 조회
    List<OrderVO> selectUserOrderList(@Param("userNumber") int userNumber,
                                       @Param("type") String type);

    // 7. 주문 상태 업데이트
    int updateOrderStatus(@Param("orderId") String orderId,
                          @Param("status") String status);

    // 주문 상세 상품 목록
    List<OrderItemVO> selectOrderItemsDetail(@Param("orderId") String orderId);

    // 재고 증가
    int updateIncreaseStock(@Param("combinationId") int combinationId,
                            @Param("quantity") int quantity);

    // (안쓴다 했지만) 마스터 쿠폰 상태 변경
    int updateMasterCouponStatus(@Param("userCouponId") int userCouponId);

    // 주문 단건 조회
    OrderVO selectOrderById(@Param("orderId") String orderId);
    
    List<OrderVO> getUserOrderList(@Param("userNumber") int userNumber, @Param("type") String type);
}
