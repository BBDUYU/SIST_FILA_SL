package com.fila.app.controller.cart;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.cart.CartItemVO;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.cart.CartListService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/pay")
public class CartListController {
	
	private final CartListService cartService;

    @GetMapping("/cart.htm")
    public String cartPage(HttpSession session, HttpServletRequest request) throws Exception {

        Object auth = (session == null) ? null : session.getAttribute("auth");
        if (auth == null) return "redirect:/member/login.htm";

        int userNumber = ((MemberVO) auth).getUserNumber();

        List<CartItemVO> cartList = cartService.selectAll(userNumber);

        request.setAttribute("cartList", cartList);   // ★ 이 줄 추가
        request.setAttribute("activeTab", "normal");

        return "pay";

    }

    @PostMapping("/cart/add.htm")
    public String addCart(HttpSession session, HttpServletRequest request) throws Exception {

        Object auth = (session == null) ? null : session.getAttribute("auth");
        if (auth == null) {
            String returnUrl = request.getRequestURI();
            if (request.getQueryString() != null) returnUrl += "?" + request.getQueryString();
            String encoded = URLEncoder.encode(returnUrl, StandardCharsets.UTF_8.name());
            return "redirect:/login.htm?returnUrl=" + encoded;
        }

        int userNumber = ((MemberVO) auth).getUserNumber();

        String productId = request.getParameter("productId");
        String qtyStr = request.getParameter("quantity");
        String combiIdStr = request.getParameter("combinationId");

        int qty = (qtyStr != null) ? Integer.parseInt(qtyStr) : 1;
        Integer combinationId = (combiIdStr != null && !combiIdStr.isBlank())
                ? Integer.parseInt(combiIdStr)
                : null;

        try {
            cartService.insertCart(productId, qty, userNumber, combinationId);
            return "redirect:/pay/cart.htm";
        } catch (Exception e) {
            e.printStackTrace();
            String pidEnc = URLEncoder.encode(productId, StandardCharsets.UTF_8.name());
            return "redirect:/product/detail.htm?product_id=" + pidEnc;
        }
    }
    
    @GetMapping("/cart/add.htm")
    public String addCartGet(HttpSession session, HttpServletRequest request) throws Exception {
        return addCart(session, request);
    }

    @PostMapping("/cart/delete.htm")
    public String deleteSelected(HttpSession session,
                                 @RequestParam("ids") String ids) throws Exception {

        Object auth = (session == null) ? null : session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm";

        int userNumber = ((MemberVO) auth).getUserNumber();

        cartService.deleteItems(ids, userNumber);
        return "redirect:/pay/cart.htm";
    }

    @PostMapping("/cart/clear.htm")
    public String clearAll(HttpSession session) throws Exception {

        Object auth = session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm";

        int userNumber = ((MemberVO) auth).getUserNumber();
        cartService.deleteAllItems(userNumber);

        return "redirect:/pay/cart.htm";
    }

    @PostMapping("/cart/update.htm")
    public String updateOption(
            HttpSession session,
            int cartItemId,
            int qty,
            String size) throws Exception {

        MemberVO auth = (MemberVO) session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm";

        cartService.updateItemOption(cartItemId, size, qty);
        return "redirect:/pay/cart.htm";
    }

    @PostMapping("/cart/updateQty.htm")
    public String updateQty(
            @RequestParam("cartItemId") int cartItemId,
            @RequestParam("quantity") int quantity,
            HttpSession session
    ) throws Exception {

        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        cartService.updateItemQty(cartItemId, loginUser.getUserNumber(), quantity);

        return "redirect:/pay/cart.htm";
    }
    
    @GetMapping("/cart2.htm")
    public String cart2Page(HttpSession session, HttpServletRequest request) throws Exception {

        Object auth = (session == null) ? null : session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm";

        int userNumber = ((MemberVO) auth).getUserNumber();

        List<CartItemVO> cartList = cartService.selectAll(userNumber); // 우선 임시: 전체
        request.setAttribute("activeTab", "today");
        return "pay2";

    }

}
