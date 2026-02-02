package com.fila.app.controller.mypage.member;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fila.app.domain.member.MemberVO;
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
        if (auth == null) {
            return "redirect:/login";
        }

        // 🔴 무조건 DB 조회 (세션 재사용 ❌)
        MemberVO member =
                mypageMemberService.getMemberByUserNumber(auth.getUserNumber());

        model.addAttribute("member", member);

        return "mypage/modifyInfo";
    }
}
