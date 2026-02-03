package com.fila.app.mapper.admin;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.fila.app.domain.admin.UserInfoVO; // DTO에서 VO로 변경 확인


public interface UserInfoMapper {
    // 회원 전체 리스트
    List<UserInfoVO> selectUserList();

    // 회원 상세 정보 (자녀 리스트 포함)
    UserInfoVO selectOne(int userNum);

    // 포인트 내역 리스트
    List<UserInfoVO> selectPointList(int userNum);

    // 각종 카운트 정보
    int getCouponCount(int userNum);
    int getWishCount(int userNum);
    int getOrderCount(int userNum);
}