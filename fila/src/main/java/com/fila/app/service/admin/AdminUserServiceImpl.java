package com.fila.app.service.admin;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.mapper.admin.UserInfoMapper;

@Service
public class AdminUserServiceImpl implements AdminUserService {

    @Autowired
    private UserInfoMapper userInfoMapper; // 프레임워크가 자동으로 주입

    @Override
    public List<UserInfoVO> getUserList() {
        // 기존의 ConnectionProvider, JdbcUtil 로직이 필요 없음
        return userInfoMapper.selectUserList();
    }

    @Override
    @Transactional(readOnly = true)
    public UserInfoVO getUserDetail(int userNum) {
        // 1. 회원 기본 정보와 자녀 리스트 조회 (Mapper에서 resultMap/collection으로 자동 매핑)
        UserInfoVO user = userInfoMapper.selectOne(userNum);
        
        // 2. 포인트 내역 조회 및 세팅
        if (user != null) {
            user.setPointList(userInfoMapper.selectPointList(userNum));
        }
        return user;
    }

    @Override
    @Transactional(readOnly = true)
    public UserInfoVO getMyPageSummary(int userNum) {
        // 1. 기본 정보 조회 (포인트 잔액 포함)
        UserInfoVO summary = userInfoMapper.selectOne(userNum);
        
        // 2. 각 항목(쿠폰, 위시리스트, 주문) 개수 조회 후 세팅
        if (summary != null) {
            summary.setCouponCount(userInfoMapper.getCouponCount(userNum));
            summary.setWishCount(userInfoMapper.getWishCount(userNum));
            summary.setOrderCount(userInfoMapper.getOrderCount(userNum));
        }
        return summary;
    }
}