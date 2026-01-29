package mypage.command;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.domain.MemberDTO;
import mypage.service.WishListService;

public class WishDeleteSelectedHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.htm");
            return null;
        }

        String idsParam = request.getParameter("ids");
        String returnUrl = request.getParameter("returnUrl");

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
            WishListService.getInstance().deleteSelected(loginUser.getUserNumber(), ids);
        }

        // 3) 이동 target 결정
        String target = "/mypage/wishlist.htm";
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            target = URLDecoder.decode(returnUrl.trim(), StandardCharsets.UTF_8);
        }

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