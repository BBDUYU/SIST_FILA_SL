package com.fila.app.controller.login;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class LgmanageController {

    @GetMapping("/lgmanage.htm")
    public String lgmanage(HttpSession session) {

        Object loginMember = session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/member/login.htm";
        }

        return "lgmanage"; // tiles definition name
    }
}
