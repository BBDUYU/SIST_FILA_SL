package com.fila.app.service.mypage.member;

import java.util.List;
import java.util.Map;

import com.fila.app.domain.ChildVO;

public interface MypageMemberService {

    boolean confirmPassword(String memberId, String password);

    void changePassword(int memberNo, String newPassword);

    void retireMember(int memberNo);

    Map<String, Integer> getMarketingStatus(int memberNo);

    List<ChildVO> getChildList(int memberNo);
}
