package com.fila.app.controller.mypage.member;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.mypage.member.MypageMemberService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/mypage/member")
public class MemberSecurityController {

    // ❗❗ 이 줄이 없으면 무조건 이 에러 남
    private final MypageMemberService mypageMemberService;

    @PostMapping("/confirm-password")
    public Map<String, Object> confirmPassword(
            @RequestParam("password") String password,
            HttpSession session) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");

        boolean ok =
            mypageMemberService.confirmPassword(auth.getId(), password);

        return Map.of("ok", ok);
    }
}
