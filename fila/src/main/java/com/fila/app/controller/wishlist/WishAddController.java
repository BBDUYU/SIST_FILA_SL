package com.fila.app.controller.wishlist;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.wishlist.WishListService;

@Controller
@RequestMapping("/mypage")
public class WishAddController {

	private final WishListService wishListService;

    public WishAddController(WishListService wishListService) {
        this.wishListService = wishListService;
    }

    @GetMapping("/mypage/wishAdd.htm")
    public String wishAdd(
            HttpSession session,
            @RequestParam(value = "product_id", required = false) String productId,
            @RequestParam(value = "returnUrl", required = false) String returnUrl,
            @RequestParam(value = "sizeText", required = false) String sizeText
    ) {
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        if (productId == null || productId.trim().isEmpty()) {
            return "redirect:/mypage/wishlist.htm";
        }

        // ✅ DB 저장
        wishListService.addWish(loginUser.getUserNumber(), productId.trim(), sizeText);

        // ✅ returnUrl 복원(디코딩)
        String target = "/mypage/wishlist.htm";
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            target = URLDecoder.decode(returnUrl.trim(), StandardCharsets.UTF_8);
        }

        // ✅ 하트 ON 표시용 wished=1
        if (!target.contains("wished=1")) {
            target += (target.contains("?") ? "&" : "?") + "wished=1";
        }

        // ✅ ctx/외부리다이렉트/중복 방지 (Controller용)
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
    
    @PostMapping(value = "/wishlist/toggle.htm", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String toggle(HttpSession session,
                         String productId,
                         String sizeText) {

        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) {
            return "{\"error\":\"UNAUTHORIZED\"}";
        }

        boolean wished =
            wishListService.toggleWished(loginUser.getUserNumber(), productId, sizeText);

        return "{\"wished\":" + wished + "}";
    }
}
