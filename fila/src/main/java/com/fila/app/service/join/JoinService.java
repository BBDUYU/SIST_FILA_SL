package com.fila.app.service.join;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.member.MemberMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JoinService {

    private final MemberMapper memberMapper;

    @Transactional
    public void join(MemberVO dto) {

        // 1️⃣ 아이디 / 비밀번호 필수
        if (dto == null) {
            throw new IllegalArgumentException("회원 정보가 없습니다.");
        }

        if (dto.getId() == null || dto.getId().isBlank()) {
            throw new IllegalArgumentException("아이디 누락");
        }

        if (dto.getPassword() == null || dto.getPassword().isBlank()) {
            throw new IllegalArgumentException("비밀번호 누락");
        }

        // 2️⃣ 이름 NULL 방어 (🔥 지금 터진 핵심 원인)
        if (dto.getName() == null || dto.getName().isBlank()) {
            dto.setName(dto.getId()); // 임시 기본값 (절대 NULL 안 들어가게)
        }

        // 3️⃣ 이메일 NULL 방어
        if (dto.getEmail() == null) {
            dto.setEmail("");
        }

        // 4️⃣ 전화번호 NULL 방어
        if (dto.getPhone() == null) {
            dto.setPhone("");
        }

        // 5️⃣ 생년월일 NULL 방어
        if (dto.getBirthday() == null) {
            dto.setBirthday("");
        }

        // 6️⃣ 성별 NULL 방어
        if (dto.getGender() == null) {
            dto.setGender("N"); // 남/여 모르면 기본값
        }

        // 7️⃣ 아이디 중복 체크
        if (memberMapper.isDuplicateId(dto.getId()) > 0) {
            throw new IllegalStateException("이미 사용 중인 아이디");
        }

        // 8️⃣ 시스템 기본값
        dto.setRole("USER");
        dto.setStatus("ACTIVE");
        dto.setGrade("BASIC");

        // 9️⃣ INSERT (여기서 이제 절대 안 터짐)
        memberMapper.insert(dto);
    }
}
