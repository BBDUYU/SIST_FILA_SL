package com.fila.app.service.order;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.order.OrderItemVO;
import com.fila.app.domain.order.OrderVO;
import com.fila.app.mapper.cart.CartMapper;
import com.fila.app.mapper.order.OrderMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class OderServiceImpl implements OderService {
	
	@Autowired
	private OrderMapper orderMapper; 
	@Autowired
	private CartMapper cartMapper;
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public String processOrder(OrderVO order, List<OrderItemVO> items, String cartItemIds) {
		
		// 1. 주문번호 생성
        String generatedOrderId = orderMapper.generateOrderId();
        order.setOrderId(generatedOrderId);

        // 2. ORDERS 저장
        orderMapper.insertOrder(order);

        // 3. ORDER_ITEMS 저장
        for (OrderItemVO item : items) {
            item.setOrderId(generatedOrderId);
        }
        orderMapper.insertOrderItems(items);

        // 3-1. 재고 차감 + 부족하면 예외(롤백)
        for (OrderItemVO item : items) {
            int stockResult = orderMapper.updateDecreaseStock(item.getCombinationId(), item.getQuantity());
            if (stockResult == 0) {
                throw new RuntimeException("상품[" + item.getCombinationId() + "]의 재고가 부족합니다.");
            }
        }

        // 4. PAYMENT 저장
        orderMapper.insertPayment(generatedOrderId, order.getTotalAmount(), order.getPaymentMethod());

        // 5. 포인트 처리
        if (order.getUsedPoint() > 0) {
            // 포인트 사용: 차감만
            orderMapper.insertPointHistory(order.getUserNumber(), generatedOrderId, order.getUsedPoint());
        } else {
            // 포인트 미사용: 5% 적립
            int rewardPoint = (int) (order.getTotalAmount() * 0.05);
            if (rewardPoint > 0) {
                orderMapper.insertOrderPoint(order.getUserNumber(), rewardPoint, generatedOrderId);
            }
        }

        // 6. 쿠폰 사용 처리
        System.out.println("DEBUG: 전달된 쿠폰 ID = " + order.getUserCouponId());
        if (order.getUserCouponId() > 0) {
            System.out.println("DEBUG: 쿠폰 업데이트 시작!");
            orderMapper.updateCouponUsed(order.getUserCouponId());
        }

        // 7. 장바구니 비우기
        if (cartItemIds != null && !cartItemIds.isEmpty()) {
            try {
                cartMapper.deleteCartItems(cartItemIds, order.getUserNumber());
            } catch (SQLException e) {
                throw new RuntimeException("장바구니 삭제 실패", e);
            }
        }

        System.out.println("✅ 주문 완료: " + generatedOrderId);
        return generatedOrderId;
	}

	@Override
	public List<OrderVO> getUserOrderList(int userNumber) {
		
		return orderMapper.selectUserOrderList(userNumber, null);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean cancelOrder(String orderId, String targetStatus) {
		
		try {
            // 1. 주문 상품 목록 조회
            List<OrderItemVO> items = orderMapper.selectOrderItemsDetail(orderId);

            // 2. 주문 상태 업데이트
            orderMapper.updateOrderStatus(orderId, targetStatus);

            // 3. 취소완료면 재고 복구
            if ("취소완료".equals(targetStatus)) {
                for (OrderItemVO item : items) {
                    if (item.getCombinationId() > 0) {
                        orderMapper.updateIncreaseStock(item.getCombinationId(), item.getQuantity());
                    }
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            // @Transactional이라 여기서 false로 삼켜버리면 롤백 안 될 수 있어서
            // 안전하게 예외를 다시 던지는 방식이 더 정석입니다.
            // 근데 "내용 변경 최소"라서 기존처럼 boolean 반환 유지.
            return false;
        }
	}

	@Override
	public OrderVO getOrderDetail(String orderId) {
		
		// 1. 주문 기본 정보
        OrderVO order = orderMapper.selectOrderById(orderId);

        if (order != null) {
            // 2. 주문 상품 목록
            List<OrderItemVO> items = orderMapper.selectOrderItemsDetail(orderId);
            order.setOrderItems(items);
        }

        return order;
    }

	@Override
	public List<OrderVO> getUserOrderList(int userNumber, String type) {
		
		return orderMapper.selectUserOrderList(userNumber, type);
	}

}
