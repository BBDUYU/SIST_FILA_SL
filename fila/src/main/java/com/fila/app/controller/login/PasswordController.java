	package com.fila.app.controller.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.service.member.MemberService;

@Controller
@RequestMapping("/member")
public class PasswordController {

    @Autowired
    private MemberService memberService;

    /**
     * 비밀번호 찾기 화면
     */
    @GetMapping("/pw-find.htm")
    public String pwFindForm() {
        return "user/SearchIdPw";
    }


    /**
     * 본인 확인 (id + phone)
     * - AJAX 호출
     * - true / false 반환
     */
    @PostMapping("/pw-check.htm")
    @ResponseBody
    public boolean canResetPassword(
            @RequestParam("id") String id,
            @RequestParam("phone") String phone) {

        return memberService.canResetPassword(id, phone);
    }

    /**
     * 비밀번호 재설정
     * - AJAX 호출
     * - "OK" / "FAIL" 문자열 반환
     */
    @PostMapping("/pw-reset.htm")
    @ResponseBody
    public String resetPassword(
            @RequestParam("id") String id,
            @RequestParam("phone") String phone,
            @RequestParam("newPw") String newPw) {

        boolean success =
            memberService.resetPasswordByVerify(id, phone, newPw);

        return success ? "OK" : "FAIL";
    }
}
