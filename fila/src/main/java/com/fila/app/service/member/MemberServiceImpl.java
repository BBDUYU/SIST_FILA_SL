package com.fila.app.service.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.member.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public MemberVO login(String id, String pw) {
        return memberMapper.login(id, pw);
    }

    @Override
    public boolean isDuplicateId(String id) {
        return memberMapper.isDuplicateId(id) > 0;
    }

    @Override
    public void join(MemberVO dto) {
        dto.setRole("USER");
        dto.setStatus("ACTIVE");
        dto.setGrade("BASIC");

        memberMapper.insert(dto);
   
    }

    @Override
    public boolean canResetPassword(String id, String phone) {
        return memberMapper.existsByIdAndPhone(id, phone) > 0;
    }

    @Override
    public void resetPassword(String id, String newPw) {
        memberMapper.updatePassword(id, newPw);
    }
}
