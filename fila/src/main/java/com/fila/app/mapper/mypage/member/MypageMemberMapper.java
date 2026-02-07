package com.fila.app.mapper.mypage.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.member.ChildVO;
import com.fila.app.domain.member.MemberVO;

public interface MypageMemberMapper {

    // 회원 조회
    MemberVO selectMemberByUserNumber(int userNumber);

    // 🔥 현재 비밀번호 검증 (추가)
    int checkPasswordByMemberNo(
        @Param("memberNo") int memberNo,
        @Param("currentPw") String currentPw
    );

    // 비밀번호 변경
    void updatePassword(
        @Param("memberNo") int memberNo,
        @Param("newPw") String newPw
    );

    // 회원 탈퇴
    void retireMember(int memberNo);

    // 마케팅 수신 여부
    Map<String, Integer> selectMarketingStatus(int memberNo);

    // 자녀 정보
    List<ChildVO> selectChildList(int memberNo);
}
