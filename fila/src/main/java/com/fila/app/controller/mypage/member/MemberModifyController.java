package com.fila.app.controller.mypage.member;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fila.app.domain.MemberVO;
import com.fila.app.service.mypage.member.MypageMemberService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage/member")
public class MemberModifyController {

    private final MypageMemberService mypageMemberService;

    @GetMapping("/modify")
    public String modifyPage(HttpSession session, Model model) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/login";  // 너희 프로젝트 로그인 URL에 맞춰 조정

        int memberNo = auth.getMemberNo();

        model.addAttribute("childList", mypageMemberService.getChildList(memberNo));
        model.addAttribute("mktMap", mypageMemberService.getMarketingStatus(memberNo));

        // JSP 경로 규칙에 맞게 리턴 (예: /WEB-INF/views/mypage/modifyInfo.jsp)
        return "mypage/modifyInfo";
    }
}
