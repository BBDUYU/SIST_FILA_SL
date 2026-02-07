package com.fila.app.service.member;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.member.MemberMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper memberMapper;
    private final BCryptPasswordEncoder passwordEncoder;

    @Override
    public MemberVO login(String id, String pw) {

        MemberVO member = memberMapper.findById(id);
        if (member == null) return null;

        if (!passwordEncoder.matches(pw, member.getPassword())) {
            return null;
        }

        return member;
    }

    @Override
    public boolean isDuplicateId(String id) {
        return memberMapper.isDuplicateId(id) > 0;
    }

    @Override
    public void join(MemberVO dto) {

        dto.setPassword(
            passwordEncoder.encode(dto.getPassword())
        );

        dto.setRole("USER");
        dto.setStatus("ACTIVE");
        dto.setGrade("BASIC");

        memberMapper.insert(dto);
    }

    @Override
    public boolean canResetPassword(String id, String phone) {
        return memberMapper.existsByIdAndPhone(id, phone) > 0;
    }

    /**
     * 비밀번호 찾기 (비로그인)
     */
    @Override
    public boolean resetPasswordByVerify(String id, String phone, String newPw) {

        int exists = memberMapper.existsByIdAndPhone(id, phone);
        if (exists == 0) {
            return false;
        }

        memberMapper.updatePassword(
            id,
            passwordEncoder.encode(newPw)
        );

        return true;
    }
    @Override
    public String findIdByNameAndPhone(String name, String phone) {
        return memberMapper.selectIdByNameAndPhone(name, phone);
    }
    
    @Override
    public boolean checkCurrentPassword(String id, String rawPassword) {
        MemberVO member = memberMapper.findById(id);
        if (member == null) return false;

        return passwordEncoder.matches(rawPassword, member.getPassword());
    }
    
}
