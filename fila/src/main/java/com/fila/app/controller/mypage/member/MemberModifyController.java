package com.fila.app.controller.mypage.member;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.ChildVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.member.MemberService;
import com.fila.app.service.mypage.member.MypageMemberService;

@Controller
@RequestMapping("/mypage")
public class MemberModifyController {

    private final MypageMemberService mypageMemberService;
    private final MemberService memberService;

    @Autowired
    public MemberModifyController(MypageMemberService mypageMemberService, MemberService memberService) {
        this.mypageMemberService = mypageMemberService;
        this.memberService = memberService;
    }

    // 모달 JSP 호출용 (기존 유지)
    @GetMapping("/pwCheckModal.htm")
    public String pwCheckModal() {
        return "mypage/pwd_chk";
    }

    @PostMapping(value = "/confirmPassword.htm")
    @ResponseBody
    public String confirmPassword(
            @RequestParam("memberPassword") String pw, 
            HttpSession session) {
        
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        
        // 1. 세션 체크
        if (auth == null) {
            return "{\"ok\": false, \"message\": \"로그인 세션이 만료되었습니다.\"}";
        }

        // 2. 비밀번호 체크
        boolean isMatch = memberService.checkCurrentPassword(auth.getId(), pw);
        
        if (isMatch) {
            session.setAttribute("passwordVerified", true);
            // 직접 JSON 문자열을 리턴 (스프링 변환기를 타지 않음)
            return "{\"ok\": true}";
        } else {
            return "{\"ok\": false, \"message\": \"비밀번호가 일치하지 않습니다.\"}";
        }
    }

    // 내 정보 변경 페이지 (인증된 사용자만 진입)
    @GetMapping("/modifyInfo.htm")
    public String modifyPage(HttpSession session, Model model) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        Boolean verified = (Boolean) session.getAttribute("passwordVerified");
        
        if (auth == null) return "redirect:/member/login.htm";
        
        // 인증 안 거치고 주소창으로 들어온 경우 차단
        if (verified == null || !verified) {
            return "redirect:/mypage/main.htm"; 
        }

        int memberNo = auth.getUserNumber();
        model.addAttribute("childList", mypageMemberService.getChildList(memberNo));
        model.addAttribute("mktMap", mypageMemberService.getMarketingStatus(memberNo));

        return "modifyInfo";
    }
    @PostMapping("/modifyInfo.htm")
    public String processModify(
            @RequestParam("userEmail") String email,
            @RequestParam(value="MemberIsSMS", defaultValue="N") String smsStr,
            @RequestParam(value="MemberIsMaillinglist", defaultValue="N") String emailMktStr,
            @RequestParam(value="ChildName", required=false) List<String> childNames,
            @RequestParam(value="birthch", required=false) List<String> childBirths,
            @RequestParam(value="MemberGender1", required=false) List<String> childGenders,
            HttpSession session) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        // 자녀 데이터 리스트화
        List<ChildVO> childList = new ArrayList<>();
        if (childNames != null) {
            for (int i = 0; i < childNames.size(); i++) {
                childList.add(ChildVO.builder()
                    .childName(childNames.get(i))
                    .childBirth(childBirths.get(i))
                    .childGender(childGenders.get(i))
                    .build());
            }
        }

        boolean smsAgreed = "Y".equals(smsStr);
        boolean mailAgreed = "Y".equals(emailMktStr);

        // 서비스 호출
        mypageMemberService.updateMemberInfo(auth.getUserNumber(), email, childList, smsAgreed, mailAgreed);

        return "redirect:/mypage/modifyInfo.htm";
    }
}