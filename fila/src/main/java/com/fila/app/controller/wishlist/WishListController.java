package com.fila.app.controller.wishlist;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
}
