package com.fila.app.controller.login;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.MemberVO;
import com.fila.app.service.member.MemberService;

@Controller
@RequestMapping("/member")
public class LoginController {

    @Autowired
    private MemberService memberService;

    /**
     * 로그인 화면
     * 기존 JoinFormHandler / LoginFormHandler 역할
     */
    @GetMapping("/login.do")
    public String loginForm(
            @RequestParam(value = "error", required = false) String error,
            Model model) {

        if (error != null) {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }

        return "login"; // login.jsp
    }

    /**
     * 로그인 처리
     * 기존 LoginService + LoginCheckFilter 일부 역할
     */
    @PostMapping("/login.do")
    public String loginProcess(
            @RequestParam("id") String id,
            @RequestParam("password") String password,
            HttpSession session) {

    	 MemberVO member = memberService.login(id, password);

        // 로그인 실패
        if (member == null) {
            return "redirect:/member/login.do?error=1";
        }

        // 로그인 성공
        session.setAttribute("loginMember", member);

        return "redirect:/"; // 메인 페이지
    }

    /**
     * 로그아웃
     * 기존 세션 invalidate 로직
     */
    @GetMapping("/logout.do")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
