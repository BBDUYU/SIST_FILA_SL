package com.fila.app.mapper.member;

import org.apache.ibatis.annotations.Param;
import com.fila.app.domain.MemberDTO;

public interface MemberMapper {

    // 로그인
    MemberDTO login(
        @Param("id") String id,
        @Param("pw") String pw
    );

    // 회원가입
    int insert(MemberDTO dto);

    // 아이디 중복 체크
    int isDuplicateId(String id);

    // 비밀번호 재설정 가능 여부
    int existsByIdAndPhone(
        @Param("id") String id,
        @Param("phone") String phone
    );

    // 비밀번호 변경
    int updatePassword(
        @Param("id") String id,
        @Param("pw") String pw
    );
}
