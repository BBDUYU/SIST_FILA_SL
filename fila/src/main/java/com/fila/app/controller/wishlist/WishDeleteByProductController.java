package com.fila.app.controller.wishlist;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.wishlist.WishListService;

@Controller
public class WishDeleteByProductController {

	private final WishListService wishListService;

    public WishDeleteByProductController(WishListService wishListService) {
        this.wishListService = wishListService;
    }

    @GetMapping("/mypage/wishDeleteByProduct.htm")
    public String wishDeleteByProduct(
            HttpSession session,
            @RequestParam(value = "product_id", required = false) String productId,
            @RequestParam(value = "returnUrl", required = false) String returnUrl
    ) {
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        if (productId != null && !productId.trim().isEmpty()) {
            wishListService.deleteByProduct(loginUser.getUserNumber(), productId.trim());
        }

        // ✅ 돌아갈 페이지 (returnUrl 우선)
        String target;
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            target = URLDecoder.decode(returnUrl.trim(), StandardCharsets.UTF_8);
        } else {
            target = "/product/product_detail.htm?product_id=" + productId;
        }

        // ✅ 하트 OFF 표시용 wished=0
        if (!target.contains("wished=")) {
            target += (target.contains("?") ? "&" : "?") + "wished=0";
        }

        // ✅ ctx/외부리다이렉트/중복 방지
        target = normalizeTarget(target);

        return "redirect:" + target;
    }

    private String normalizeTarget(String target) {
        if (target == null || target.isBlank()) return "/mypage/wishlist.htm";

        if (target.startsWith("http://") || target.startsWith("https://")) {
            return "/mypage/wishlist.htm";
        }

        if (target.startsWith("/")) return target;

        return "/" + target;
    }
}
