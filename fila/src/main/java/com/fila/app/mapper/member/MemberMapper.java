package com.fila.app.mapper.member;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.member.MemberVO;

public interface MemberMapper {

    // 아이디로 회원 조회 (로그인용)
    MemberVO findById(@Param("id") String id);

    // 회원가입
    int insert(MemberVO dto);

    // 아이디 중복 체크
    int isDuplicateId(String id);

    // 비밀번호 재설정 가능 여부
    int existsByIdAndPhone(
        @Param("id") String id,
        @Param("phone") String phone
    );

    // 비밀번호 변경 (일반)
    int updatePassword(
        @Param("id") String id,
        @Param("pw") String pw
    );

    // 🔥 평문 비밀번호 회원 조회 (마이그레이션용)
    List<MemberVO> findPlainPasswordUsers();

    // 🔥 비밀번호 업데이트 (id 기준, 마이그레이션용)
    int updatePasswordById(
        @Param("id") String id,
        @Param("pw") String pw
    );
    String selectIdByNameAndPhone(@Param("name") String name,
            @Param("phone") String phone);
}

