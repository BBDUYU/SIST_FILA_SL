package com.fila.app.service.mypage.member;

import java.util.List;
import java.util.Map;

import com.fila.app.domain.member.ChildVO;
import com.fila.app.domain.member.MemberVO;

public interface MypageMemberService {

    MemberVO getMemberByUserNumber(int userNumber);

    boolean changePassword(int memberNo, String currentPw, String newPw);

    void retireMember(int memberNo);

    Map<String, Integer> getMarketingStatus(int memberNo);

    List<ChildVO> getChildList(int memberNo);
    
    void updateMemberInfo(int memberNo, String email, List<ChildVO> children, boolean sms, boolean emailAgreed);
}
