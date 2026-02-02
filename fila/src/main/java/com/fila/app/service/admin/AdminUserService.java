package com.fila.app.service.admin;

import java.util.List;
import com.fila.app.domain.admin.UserInfoVO;

public interface AdminUserService {
    // 회원 전체 목록 조회
    List<UserInfoVO> getUserList();
    
    // 회원 상세 정보 조회 (기본정보 + 자녀 + 포인트)
    UserInfoVO getUserDetail(int userNum);
    
    // 마이페이지 요약 정보 조회 (잔액 + 각종 카운트)
    UserInfoVO getMyPageSummary(int userNum);
}