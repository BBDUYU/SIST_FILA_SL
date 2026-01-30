package com.fila.app.domain.order;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderItemVO {

	private int orderItemId;    // PK (시퀀스)
    private String orderId;     // FK (주문번호)
    private String productId;   // 상품ID
    private int combinationId;  // 옵션ID (사이즈 등)
    private int quantity;       // 주문수량
    private int price;          // 주문 당시 판매가
    private String cancelStatus;// 취소여부 (N)
    private String productName;
    private String size;
    private int originalPrice;
}
