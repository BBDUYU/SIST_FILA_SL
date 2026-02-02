package com.fila.app.service.mypage.member;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.fila.app.domain.member.ChildVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.mapper.mypage.member.MypageMemberMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MypageMemberServiceImpl implements MypageMemberService {

    private final MypageMemberMapper mapper;

    // ===== modify =====
    @Override
    public MemberVO getMemberByUserNumber(int userNumber) {
        return mapper.selectMemberByUserNumber(userNumber);
    }

    // ===== security =====
    @Override
    public boolean confirmPassword(String memberId, String password) {
        return mapper.checkPassword(memberId, password) == 1;
    }

    @Override
    public void changePassword(int memberNo, String newPassword) {
        mapper.updatePassword(memberNo, newPassword);
    }

    @Override
    public void retireMember(int memberNo) {
        mapper.retireMember(memberNo);
    }

    // ===== additional =====
    @Override
    public Map<String, Integer> getMarketingStatus(int memberNo) {
        return mapper.selectMarketingStatus(memberNo);
    }

    @Override
    public List<ChildVO> getChildList(int memberNo) {
        return mapper.selectChildList(memberNo);
    }
}
