package fila.mypage.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import fila.admin.domain.UserInfoDTO;
import fila.command.CommandHandler;
import fila.member.MemberDTO;
import fila.mypage.service.UserCouponService;

public class CouponListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");

        if (auth == null) {
            return "redirect:/login.htm";
        }

        UserCouponService service = UserCouponService.getInstance();
        List<UserInfoDTO> couponList = service.getCouponList(auth.getUserNumber());

        request.setAttribute("couponList", couponList);
        // 보유 쿠폰 개수 계산 (미사용만)
        long activeCount = couponList.stream().filter(c -> "0".equals(c.getIsused())).count();
        request.setAttribute("activeCount", activeCount);

        return "/view/mypage/mycoupon.jsp";
    }
}