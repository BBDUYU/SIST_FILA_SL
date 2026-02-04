package com.fila.app.controller.mypage.member;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.mypage.member.MypageMemberService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/mypage/member")
public class MemberModifyController {

    private final MypageMemberService mypageMemberService;

    @Autowired
    public MemberModifyController(MypageMemberService mypageMemberService) {
        this.mypageMemberService = mypageMemberService;
    }

    @GetMapping("/modify")
    public String modifyPage(HttpSession session, Model model) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/login";

        int memberNo = auth.getUserNumber();
        model.addAttribute("childList", mypageMemberService.getChildList(memberNo));
        model.addAttribute("mktMap", mypageMemberService.getMarketingStatus(memberNo));

        return "mypage/modifyInfo";
    }
}
