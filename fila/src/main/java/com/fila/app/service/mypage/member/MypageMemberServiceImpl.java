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
    public boolean changePassword(int memberNo, String currentPw, String newPw) {

        // 1️⃣ 현재 비밀번호 검증
        int cnt = mapper.checkPasswordByMemberNo(memberNo, currentPw);
        if (cnt != 1) {
            return false;
        }

        // 2️⃣ 새 비밀번호 변경
        mapper.updatePassword(memberNo, newPw);
        return true;
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
