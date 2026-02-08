package com.fila.app.controller.wishlist;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.service.wishlist.WishListService;

@Controller
@RequestMapping("/mypage")
public class WishListController {

	private final WishListService wishListService;

    public WishListController(WishListService wishListService) {
        this.wishListService = wishListService;
    }

    @GetMapping("/wishlist.htm")
    public String wishlist(HttpSession session, Model model) {

        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        List<com.fila.app.domain.mypage.WishListVO> wishList = wishListService.getWishList(loginUser.getUserNumber());
        model.addAttribute("wishList", wishList);

        // ✅ include 구조 유지
        model.addAttribute("contentPage", "/view/mypage/wishlist.jsp");

        return "wishlist";
    }
    
    @PostMapping(value = "/wish/toggle.htm")
    @ResponseBody
    public String toggleWish(HttpSession session,
                             @RequestParam("productId") String productId,
                             @RequestParam(value="sizeText", required=false) String sizeText) {

        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser == null) {
            // 401 대신 문자열로 간단히 (pom 수정 불가라 ResponseEntity 생략해도 됨)
            return "{\"error\":\"UNAUTHORIZED\"}";
        }

        boolean wished = wishListService.toggleWished(loginUser.getUserNumber(), productId, sizeText);

        return "{\"wished\":" + wished + "}";
    }

}
