package com.fila.app.service.admin;

import java.util.List;
import com.fila.app.domain.admin.CouponVO;
import com.fila.app.domain.admin.UserInfoVO;

public interface CouponService {
    // 관리자: 쿠폰 마스터 목록 조회
    List<CouponVO> getCouponList();
    
    // 관리자: 새 쿠폰 생성
    void createCoupon(CouponVO vo);
    
    // 관리자: 쿠폰 사용 가능/불가능 상태 토글
    void toggleCouponStatus(int couponId, String status);
    
    // 마이페이지: 특정 회원의 보유 쿠폰 목록 조회
    List<UserInfoVO> getUserCouponList(int userNum);
}