package com.fila.app.mapper.admin;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.fila.app.domain.admin.CouponVO;
import com.fila.app.domain.admin.UserInfoVO;


public interface CouponMapper {
    // [관리자] 쿠폰 마스터 관리
    List<CouponVO> selectList();
    int insertCoupon(CouponVO vo);
    int updateStatus(@Param("couponId") int couponId, @Param("status") String status);

    // [회원/마이페이지] 보유 쿠폰 관리
    List<UserInfoVO> getUserCouponList(int userNumber);
    int useUserCoupon(int userCouponId);
}