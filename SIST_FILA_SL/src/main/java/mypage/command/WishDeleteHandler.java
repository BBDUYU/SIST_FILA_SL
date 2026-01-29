package mypage.command;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.MemberDTO;
import mypage.service.WishListService;

public class WishDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.htm");
            return null;
        }

        String wid = request.getParameter("wishlist_id");
        String returnUrl = request.getParameter("returnUrl");

        // 1) 삭제
        if (wid != null && wid.matches("\\d+")) {
            WishListService.getInstance().deleteOne(loginUser.getUserNumber(), Integer.parseInt(wid));
        }

        // 2) 이동 target 결정 (returnUrl 우선)
        String target = "/mypage/wishlist.htm";
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            // JS에서 encodeURIComponent로 보내니까 디코딩해주는 게 안전
            target = URLDecoder.decode(returnUrl.trim(), StandardCharsets.UTF_8);
        }

        // 3) 오픈리다이렉트 방지 + ctx 중복 방지
        target = normalizeTarget(request.getContextPath(), target);

        response.sendRedirect(target);
        return null;
    }

    private String normalizeTarget(String ctx, String target) {
        if (target == null || target.isBlank()) return ctx + "/mypage/wishlist.htm";

        // 외부로 못 나가게 막기
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

        // 그 외(상대경로)도 ctx 붙여서 안전하게
        return ctx + "/" + target;
    }
}