package com.fila.app.service.admin;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.admin.CouponVO;
import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.mapper.admin.CouponMapper;

@Service
public class CouponServiceImpl implements CouponService {

    @Autowired
    private CouponMapper couponMapper; // MyBatis 매퍼 주입

    @Override
    @Transactional(readOnly = true)
    public List<CouponVO> getCouponList() {
        return couponMapper.selectList();
    }

    @Override
    @Transactional // 등록 로직이므로 기본 트랜잭션 설정 (Exception 발생 시 롤백)
    public void createCoupon(CouponVO vo) {
        couponMapper.insertCoupon(vo);
    }

    @Override
    @Transactional
    public void toggleCouponStatus(int couponId, String status) {
        couponMapper.updateStatus(couponId, status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<UserInfoVO> getUserCouponList(int userNum) {
        // 기존의 복잡한 예외 처리 로직이 Spring의 RuntimeException 체계로 통합되어 간결해집니다.
        return couponMapper.getUserCouponList(userNum);
    }
   

    
}