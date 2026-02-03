package com.fila.app.controller.point;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fila.app.domain.admin.UserInfoVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.admin.AdminUserService;

@Controller
@RequestMapping("/mypage")
public class PointListController  {

	@Autowired
	private AdminUserService service;

    public PointListController(AdminUserService service) {
        this.service = service;
    }

    @GetMapping("/mypoint")
    public String myPoint(HttpSession session, Model model) throws Exception {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm";

        UserInfoVO user = service.getUserDetail(auth.getUserNumber());
        model.addAttribute("user", user);

        return "/mypage/mypoint";
    }
}
