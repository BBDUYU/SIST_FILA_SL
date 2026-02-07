package com.fila.app.service.mypage.member;

import java.util.List;
import java.util.Map;

import com.fila.app.domain.member.ChildVO;
import com.fila.app.domain.member.MemberVO;

public interface MypageMemberService {

    // ===== modify =====
    MemberVO getMemberByUserNumber(int userNumber);

    // ===== security =====

    // ❌ confirmPassword 제거 (암호화 이후 사용 안 함)

    /**
     * 내정보 변경 - 비밀번호 변경
     * @param memberNo 로그인한 회원 번호
     * @param currentPw 현재 비밀번호 (평문)
     * @param newPw 새 비밀번호 (평문)
     * @return 성공 여부
     */
    boolean changePassword(int memberNo, String currentPw, String newPw);

    void retireMember(int memberNo);

    // ===== additional =====
    Map<String, Integer> getMarketingStatus(int memberNo);

    List<ChildVO> getChildList(int memberNo);
}
