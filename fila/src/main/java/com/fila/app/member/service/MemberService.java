package com.fila.app.member.service;

import com.fila.app.domain.MemberVO;

public interface MemberService {

    // 로그인
    MemberVO login(String id, String pw);

    // 아이디 중복 체크
    boolean isDuplicateId(String id);

    // 회원가입
    void join(MemberVO dto);

    // 비밀번호 재설정 가능 여부
    boolean canResetPassword(String id, String phone);

    // 비밀번호 변경
    void resetPassword(String id, String newPw);
  

    
}
