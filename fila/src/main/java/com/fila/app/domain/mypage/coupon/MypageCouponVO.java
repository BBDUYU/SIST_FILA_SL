package com.fila.app.domain.mypage.coupon;

import java.util.Date;

import com.fila.app.domain.admin.StyleImageVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MypageCouponVO {

    private int userCouponId;
    private int couponId;
    private String isUsed;      // "0" or "1"
    private Date expireDate;
    private Date receivedAt;

    private String couponName;
    private String discountType;
    private int discountValue;  // 레거시 DISCOUNT_VALUE
}
