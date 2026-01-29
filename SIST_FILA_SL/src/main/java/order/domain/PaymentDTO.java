package order.domain;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentDTO {
    private int paymentId;      // PK
    private String orderId;     // 주문번호
    private int amount;         // 결제금액
    private String paymentMethod; // 결제수단
    private String paymentStatus; // 결제상태 (PAID)
    private Date paidAt;        // 결제일시
}