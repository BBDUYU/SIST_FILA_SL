package com.fila.app.service.mypage.coupon;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.mypage.coupon.MypageCouponVO;
import com.fila.app.mapper.mypage.coupon.MypageCouponMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MypageCouponService {

    private final MypageCouponMapper mapper;

    public List<MypageCouponVO> getMyCouponList(int userNumber) {
        return mapper.selectMyCouponList(userNumber);
    }

    @Transactional
    public Map<String, Object> registerCoupon(int userNumber, String serialNo) {

        Map<String, Object> result = new HashMap<>();

        // 1) 유효 쿠폰인지
        Integer couponId = mapper.selectCouponIdBySerial(serialNo);
        if (couponId == null) {
            result.put("status", "fail");
            result.put("message", "유효하지 않거나 중지된 쿠폰 번호입니다.");
            return result;
        }

        Date expireDate = mapper.selectExpireDateBySerial(serialNo);

        // 2) 중복인지
        int dupCount = mapper.countUserCoupon(userNumber, couponId);
        if (dupCount > 0) {
            result.put("status", "fail");
            result.put("message", "이미 등록된 쿠폰입니다.");
            return result;
        }

        // 3) 지급(등록)
        mapper.insertUserCoupon(couponId, userNumber, expireDate);

        result.put("status", "success");
        result.put("message", "쿠폰이 성공적으로 등록되었습니다.");
        return result;
    }
}
