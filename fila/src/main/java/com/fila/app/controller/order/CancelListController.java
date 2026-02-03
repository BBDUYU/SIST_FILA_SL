package com.fila.app.controller.order;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.order.OrderVO;
import com.fila.app.mapper.order.OderMapper;

@Controller
@RequestMapping("/order")
public class CancelListController {

	@Autowired
    private OderMapper oderMapper;

    @GetMapping("/order/cancelList.htm")   // ✅ 필요하면 URL은 너 프로젝트에 맞게 바꿔도 됨
    public String cancelList(HttpSession session, Model model) {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm";  // ✅ 기존 핸들러와 동일 흐름

        List<OrderVO> list = new ArrayList<>();

        // ✅ "CANCEL" 타입으로 취소/반품 주문만 조회
		list = oderMapper.selectUserOrderList(auth.getUserNumber(), "CANCEL");

        model.addAttribute("orderList", list);
        model.addAttribute("totalCount", list.size());

        // ✅ 기존 핸들러와 동일 JSP
        return "/mypage/inquiry";
    }
}
