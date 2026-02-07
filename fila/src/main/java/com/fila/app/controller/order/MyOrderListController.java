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

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fila.app.domain.order.OrderItemVO;

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
    @GetMapping("/inquiry.htm")
    public String myInquiry(HttpSession session, Model model) {
        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        // DAO에서 쓰던 "CANCEL" 필터링 로직 그대로 사용
        List<OrderVO> list = oderService.getUserOrderList(auth.getUserNumber(), "CANCEL");

        model.addAttribute("orderList", list); // JSP에서 사용할 리스트
        model.addAttribute("totalCount", list.size());

        return "inquiry"; // Tiles definition name
    }
    @GetMapping(value = "/orderDetail.htm", produces = "text/html; charset=UTF-8")
    @ResponseBody
    public String getOrderDetail(@RequestParam String orderId) {
        // 1. 이미 만들어두신 OderService의 getOrderDetail 호출
        // (이 메서드는 OrderVO 안에 OrderItemVO 리스트를 채워서 반환하죠?)
        OrderVO order = oderService.getOrderDetail(orderId);

        if (order == null || order.getOrderItems() == null || order.getOrderItems().isEmpty()) {
            return "<p style='padding:20px; text-align:center;'>상세 내역이 없습니다.</p>";
        }

        // 2. HTML 조각 생성 (JSON 대신 쌩 HTML을 리턴)
        StringBuilder html = new StringBuilder();
        html.append("<div style='margin-bottom:10px; font-weight:bold; color:#00205b;'>[주문 상품 상세 내역]</div>");
        html.append("<table style='width:100%; border-collapse:collapse; background:#fff; border:1px solid #ddd;'>");
        html.append("<tr style='background:#f4f4f4; border-bottom:2px solid #ccc;'>");
        html.append("<th style='padding:10px;'>상품명</th><th>사이즈</th><th>수량</th><th>단가</th></tr>");

        for (OrderItemVO item : order.getOrderItems()) {
            String size = (item.getSize() != null && !item.getSize().isEmpty()) ? item.getSize() : "기본";
            html.append("<tr style='border-bottom:1px solid #eee; text-align:center;'>");
            html.append("<td style='padding:10px; text-align:left;'>").append(item.getProductName()).append("</td>");
            html.append("<td>").append(size).append("</td>");
            html.append("<td>").append(item.getQuantity()).append("개</td>");
            html.append("<td style='font-weight:bold;'>")
                .append(String.format("%,d원", item.getPrice())).append("</td>");
            html.append("</tr>");
        }
        html.append("</table>");

        return html.toString();
    }
    
}
