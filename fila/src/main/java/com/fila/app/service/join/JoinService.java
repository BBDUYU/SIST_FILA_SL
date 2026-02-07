package com.fila.app.service.join;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.member.MemberMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JoinService {

    private final MemberMapper memberMapper;
    private final PasswordEncoder passwordEncoder; // 🔥 여기 주입

    @Transactional
    public void join(MemberVO dto) {

        if (dto == null) {
            throw new IllegalArgumentException("회원 정보가 없습니다.");
        }

        if (dto.getId() == null || dto.getId().isBlank()) {
            throw new IllegalArgumentException("아이디 누락");
        }

        if (dto.getPassword() == null || dto.getPassword().isBlank()) {
            throw new IllegalArgumentException("비밀번호 누락");
        }

        // 🔥 여기서 암호화
        dto.setPassword(
            passwordEncoder.encode(dto.getPassword())
        );

        // NULL 방어
        if (dto.getName() == null || dto.getName().isBlank()) {
            dto.setName(dto.getId());
        }
        if (dto.getEmail() == null) dto.setEmail("");
        if (dto.getPhone() == null) dto.setPhone("");
        if (dto.getBirthday() == null) dto.setBirthday("");
        if (dto.getGender() == null) dto.setGender("N");

        // 중복 체크
        if (memberMapper.isDuplicateId(dto.getId()) > 0) {
            throw new IllegalStateException("이미 사용 중인 아이디");
        }

        // 기본값
        dto.setRole("USER");
        dto.setStatus("ACTIVE");
        dto.setGrade("BASIC");

        // INSERT
        memberMapper.insert(dto);
    }
}