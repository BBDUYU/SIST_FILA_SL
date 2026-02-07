package com.fila.app.service.mypage.coupon;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.admin.CouponVO;
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

        CouponVO couponMaster = mapper.selectCouponMasterBySerial(serialNo);

        // 1) 유효성 체크 (번호가 없거나 STATUS='N'인 경우)
        if (couponMaster == null) {
            result.put("status", "fail");
            result.put("message", "유효하지 않거나 기간이 만료된 쿠폰 번호입니다.");
            return result;
        }

        int couponId = couponMaster.getCouponId();
        Date expireDate = couponMaster.getExpiresAt();

        // 2) 날짜 체크
        if (expireDate != null) {
            Date today = new Date(System.currentTimeMillis());
            if (expireDate.before(today)) {
                result.put("status", "fail");
                result.put("message", "이미 만료된 쿠폰 번호입니다.");
                return result;
            }
        }

        // 3) [중복 체크] 이미 가지고 있는 쿠폰인지 확인
        int dupCount = mapper.countUserCoupon(userNumber, couponId);
        if (dupCount > 0) {
            result.put("status", "fail");
            result.put("message", "이미 등록된 쿠폰입니다.");
            return result;
        }

        // 4) [최종 등록] 모든 관문을 통과했을 때만 실행
        try {
            mapper.insertUserCoupon(couponId, userNumber, expireDate);
            result.put("status", "success");
            result.put("message", "쿠폰이 성공적으로 등록되었습니다.");
        } catch (Exception e) {
            // 실제 DB 에러 발생 시
            result.put("status", "error");
            result.put("message", "시스템 오류로 등록에 실패했습니다.");
        }

        return result;
    }
}
