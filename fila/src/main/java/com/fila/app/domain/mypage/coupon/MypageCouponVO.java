package com.fila.app.domain.mypage.coupon;

import java.util.Date;

import lombok.Data;

@Data
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
