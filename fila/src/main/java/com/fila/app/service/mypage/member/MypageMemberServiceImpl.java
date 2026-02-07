package com.fila.app.service.mypage.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Override
    public Map<String, Integer> getMarketingStatus(int memberNo) {
        return mapper.selectMarketingStatus(memberNo);
    }

    @Override
    public List<ChildVO> getChildList(int memberNo) {
        return mapper.selectChildList(memberNo);
    }
    
    @Transactional // 모든 수정이 성공해야 Commit, 하나라도 실패하면 Rollback
    @Override
    public void updateMemberInfo(int memberNo, String email, List<ChildVO> children, boolean sms, boolean emailAgreed) {
        
        // 1. 이메일 업데이트
        mapper.updateEmail(memberNo, email);

        // 2. 마케팅 정보 업데이트 (6: SMS, 7: EMAIL)
        mapper.updateMarketingStatus(memberNo, 6, sms ? 1 : 0);
        mapper.updateMarketingStatus(memberNo, 7, emailAgreed ? 1 : 0);

        // 3. 자녀 정보 업데이트 (기존 데이터 삭제 후 새로 삽입)
        mapper.deleteChildren(memberNo);
        if (children != null && !children.isEmpty()) {
            for (ChildVO child : children) {
                // 자녀 이름이 있는 경우만 삽입
                if (child.getChildName() != null && !child.getChildName().trim().isEmpty()) {
                    mapper.insertChild(memberNo, child);
                }
            }
        }
    }
}
