package com.fila.app.controller.login;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.service.member.MemberService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberFindController {

    private final MemberService memberService; // 기존 서비스

    @PostMapping("/find-id.htm")
    @ResponseBody
    public String findId(
            @RequestParam String name,
            @RequestParam String phone
    ) {
        String id = memberService.findIdByNameAndPhone(name, phone);
        return id == null ? "" : id;
    }
}
