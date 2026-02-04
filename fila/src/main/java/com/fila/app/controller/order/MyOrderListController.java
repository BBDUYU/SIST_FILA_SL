package com.fila.app.controller.order;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.order.OrderVO;
import com.fila.app.service.order.OderService;

@Controller
@RequestMapping("/mypage")
public class MyOrderListController {

	@Autowired
	private OderService oderService;

    @GetMapping("/orders.htm")
    public String myOrders(HttpSession session, Model model) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        // ✅ 기존 "ORDER" 필터 유지
        List<OrderVO> list = oderService.getUserOrderList(auth.getUserNumber(), "ORDER");

        model.addAttribute("orderList", list);
        model.addAttribute("totalCount", list.size());

        return "orders";
    }
    
}
