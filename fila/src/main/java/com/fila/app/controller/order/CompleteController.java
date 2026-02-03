package com.fila.app.controller.order;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.order.OrderVO;
import com.fila.app.service.order.OderService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CompleteController {

	@Autowired
	private OderService oderService;

    @GetMapping("/order/complete.htm")
    public String complete(@RequestParam("orderId") String orderId, Model model) {

        OrderVO order = oderService.getOrderDetail(orderId);

        model.addAttribute("order", order);
        model.addAttribute("orderId", orderId);

        return "order/complete";
    }
}
