package com.fila.app.service.mypage.member;

import java.util.List;
import java.util.Map;

import com.fila.app.domain.member.ChildVO;
import com.fila.app.domain.member.MemberVO;

public interface MypageMemberService {

    // ===== modify =====
    MemberVO getMemberByUserNumber(int userNumber);

    // ===== security =====
    boolean confirmPassword(String memberId, String password);

    void changePassword(int memberNo, String newPassword);

    void retireMember(int memberNo);

    // ===== additional =====
    Map<String, Integer> getMarketingStatus(int memberNo);

    List<ChildVO> getChildList(int memberNo);
}
