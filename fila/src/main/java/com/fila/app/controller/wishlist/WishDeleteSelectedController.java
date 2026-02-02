package com.fila.app.controller.wishlist;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.MemberVO;
import com.fila.app.service.wishlist.WishListService;

@Controller
public class WishDeleteSelectedController {

	private final WishListService wishListService;

    public WishDeleteSelectedController(WishListService wishListService) {
        this.wishListService = wishListService;
    }

    @GetMapping("/mypage/wishDeleteSelected.htm")
    public String wishDeleteSelected(
            HttpSession session,
            @RequestParam(value = "ids", required = false) String idsParam,
            @RequestParam(value = "returnUrl", required = false) String returnUrl
    ) {
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        // 1) ids 파싱
        List<Integer> ids = new ArrayList<>();
        if (idsParam != null && !idsParam.trim().isEmpty()) {
            String[] parts = idsParam.split(",");
            for (String p : parts) {
                p = p.trim();
                if (p.matches("\\d+")) ids.add(Integer.parseInt(p));
            }
        }

        // 2) 삭제
        if (!ids.isEmpty()) {
            wishListService.deleteSelected(loginUser.getUserNumber(), ids);
        }

        // 3) 이동 target 결정
        String target = "/mypage/wishlist.htm";
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            target = URLDecoder.decode(returnUrl.trim(), StandardCharsets.UTF_8);
        }

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
