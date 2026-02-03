package com.fila.app.mapper.mypage.coupon;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.mypage.coupon.MypageCouponVO;

public interface MypageCouponMapper {

    List<MypageCouponVO> selectMyCouponList(@Param("userNumber") int userNumber);

    // 시리얼로 쿠폰 유효 확인
    Integer selectCouponIdBySerial(@Param("serialNo") String serialNo);

    Date selectExpireDateBySerial(@Param("serialNo") String serialNo);

    // 중복 확인
    int countUserCoupon(@Param("userNumber") int userNumber,
                        @Param("couponId") int couponId);

    // 지급(등록)
    int insertUserCoupon(@Param("couponId") int couponId,
                         @Param("userNumber") int userNumber,
                         @Param("expireDate") Date expireDate);
}
