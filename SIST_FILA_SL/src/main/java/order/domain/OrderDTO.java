package order.domain;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderDTO {
    private String orderId;        // 주문번호 (예: 20251230-001)
    private int userNumber;        // 회원번호
    private int addressId;         // 배송지ID (DELIVERY_ADDRESS 참조)
    private int totalAmount;       // 최종 결제 금액
    private String orderStatus;    // 주문상태 (결제완료, 배송중 등)
    private String deliveryMethod; // 배송방법 (일반, 오늘도착)
    private String deliveryRequest;// 배송요청사항
    private Date createdAt;        // 주문일시
    private int issueId;
    private Date updatedAt;
    
    // 결제 처리를 위해 추가로 필요한 필드
    private String paymentMethod;  // 결제수단 (card, kakao 등)
    private int usedPoint;         // 사용한 포인트
    private int userCouponId;      // 사용한 쿠폰ID
    private List<OrderItemDTO> orderItems;
    private String recipientName;
    private String recipientPhone;
    private String address;
}