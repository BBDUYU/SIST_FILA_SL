package mypage.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.domain.MemberDTO;
import mypage.domain.WishListDTO;
import mypage.service.WishListService;

public class WishListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) return "redirect:/login.htm";

        WishListService service = WishListService.getInstance();
        List<WishListDTO> wishList = service.getWishList(loginUser.getUserNumber());
        request.setAttribute("wishList", wishList);

        // ✅ mypage.jsp가 가운데 내용으로 wishlist.jsp를 include 하게
        request.setAttribute("contentPage", "/view/mypage/wishlist.jsp");

        return "/view/mypage/wishlist.jsp";
    }
}