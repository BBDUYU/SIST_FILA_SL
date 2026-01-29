package fila.mypage.command;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;
import fila.member.MemberDTO;
import fila.mypage.service.WishListService;

public class WishDeleteByProductHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.htm");
            return null;
        }

        String productId = request.getParameter("product_id");
        String returnUrl = request.getParameter("returnUrl");

        if (productId != null && !productId.trim().isEmpty()) {
            WishListService.getInstance().deleteByProduct(loginUser.getUserNumber(), productId.trim());
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
        target = normalizeTarget(request.getContextPath(), target);

        response.sendRedirect(target);
        return null;
    }

    private String normalizeTarget(String ctx, String target) {
        if (target == null || target.isBlank()) return ctx + "/mypage/wishlist.htm";

        if (target.startsWith("http://") || target.startsWith("https://")) {
            return ctx + "/mypage/wishlist.htm";
        }

        if (target.startsWith(ctx + "/") || target.equals(ctx)) {
            return target;
        }

        if (target.startsWith("/")) {
            return ctx + target;
        }

        return ctx + "/" + target;
    }
}