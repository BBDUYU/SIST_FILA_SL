package com.fila.app.controller.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.member.service.MemberService;

@Controller
@RequestMapping("/member")
public class PasswordController {

    @Autowired
    private MemberService memberService;

    /**
     * 비밀번호 찾기 화면
     * (JSP 없어도 매핑만 먼저)
     */
    @GetMapping("/pw-find.do")
    public String pwFindForm() {
        // 나중에 pw_find.jsp
        return "pw_find";
    }

    /**
     * 비밀번호 재설정 가능 여부 확인 (id + phone)
     * → AJAX 용도로도 많이 씀
     */
    @PostMapping("/pw-check.do")
    @ResponseBody
    public boolean canResetPassword(
            @RequestParam("id") String id,
            @RequestParam("phone") String phone) {

        return memberService.canResetPassword(id, phone);
    }

    /**
     * 비밀번호 재설정 처리
     */
    @PostMapping("/pw-reset.do")
    public String resetPassword(
            @RequestParam("id") String id,
            @RequestParam("newPw") String newPw) {

        memberService.resetPassword(id, newPw);

        // 나중에 완료 페이지로 이동
        return "redirect:/member/login.do";
    }
}
