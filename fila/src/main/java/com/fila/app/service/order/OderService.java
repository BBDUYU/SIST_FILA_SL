package com.fila.app.service.order;

import java.util.List;

import com.fila.app.domain.order.OrderItemVO;
import com.fila.app.domain.order.OrderVO;

public interface OderService {

	String processOrder(OrderVO order, List<OrderItemVO> items, String cartItemIds);

    List<OrderVO> getUserOrderList(int userNumber);

    boolean cancelOrder(String orderId, String targetStatus);

    OrderVO getOrderDetail(String orderId);
    
    List<OrderVO> getUserOrderList(int userNumber, String type);
}
