package com.fila.app.controller.login;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.member.MemberService;

@Controller
@RequestMapping("/member")
public class LoginController {

    @Autowired
    private MemberService memberService;

    /**
     * 로그인 화면
     */
    @GetMapping("/login.htm")
    public String loginForm(
            @RequestParam(value = "error", required = false) String error,
            Model model) {

        if (error != null) {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }

        return "login";
    }

    /**
     * 로그인 처리 (암호화 대응)
     */
    @PostMapping("/login.htm")
    public String loginProcess(
            @RequestParam("id") String id,
            @RequestParam("password") String password,
            HttpSession session) {

        MemberVO member = memberService.login(id, password);

        if (member == null) {
            return "redirect:/member/login.htm?error=1";
        }

        session.setAttribute("auth", member);
        return "redirect:/";
    }

    /**
     * 로그아웃
     */
    @GetMapping("/logout.htm")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
