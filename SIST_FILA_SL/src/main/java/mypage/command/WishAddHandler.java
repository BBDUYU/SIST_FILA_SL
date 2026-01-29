package mypage.command;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.domain.MemberDTO;
import mypage.service.WishListService;

public class WishAddHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.htm");
            return null;
        }

        String productId = request.getParameter("product_id");
        String returnUrl = request.getParameter("returnUrl");
        String sizeText  = request.getParameter("sizeText"); // 선택 사이즈 텍스트

        if (productId == null || productId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/mypage/wishlist.htm");
            return null;
        }

        // ✅ DB 저장
        WishListService.getInstance().addWish(loginUser.getUserNumber(), productId.trim(), sizeText);

        // ✅ returnUrl 복원(디코딩) - 이거 안 하면 Tomcat 400 뜸
        String target = "/mypage/wishlist.htm";
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            target = URLDecoder.decode(returnUrl.trim(), StandardCharsets.UTF_8);
        }

        // ✅ 하트 ON 표시용 wished=1
        if (!target.contains("wished=1")) {
            target += (target.contains("?") ? "&" : "?") + "wished=1";
        }

        // ✅ ctx/외부리다이렉트/중복 방지
        target = normalizeTarget(request.getContextPath(), target);

        response.sendRedirect(target);
        return null;
    }

    private String normalizeTarget(String ctx, String target) {
        if (target == null || target.isBlank()) return ctx + "/mypage/wishlist.htm";

        // 외부로 나가는 redirect 방지
        if (target.startsWith("http://") || target.startsWith("https://")) {
            return ctx + "/mypage/wishlist.htm";
        }

        // 이미 ctx 포함이면 그대로
        if (target.startsWith(ctx + "/") || target.equals(ctx)) {
            return target;
        }

        // /로 시작하면 ctx 붙이기
        if (target.startsWith("/")) {
            return ctx + target;
        }

        // 그 외 상대경로도 ctx 붙이기
        return ctx + "/" + target;
    }
}