package com.fila.app.service.member;

import com.fila.app.domain.member.MemberVO;

public interface MemberService {

    // 로그인
    MemberVO login(String id, String pw);

    // 아이디 중복 체크
    boolean isDuplicateId(String id);

    // 회원가입
    void join(MemberVO dto);

    // 비밀번호 재설정 가능 여부 (id + phone)
    boolean canResetPassword(String id, String phone);

    // 비밀번호 찾기용 재설정 (검증 후)
    boolean resetPasswordByVerify(String id, String phone, String newPw);
    
    String findIdByNameAndPhone(String name, String phone);

  }


