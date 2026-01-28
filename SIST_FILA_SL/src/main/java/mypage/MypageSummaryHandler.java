package mypage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import member.MemberDTO;
import admin.domain.UserInfoDTO;
import admin.service.AdminUserService;
import command.CommandHandler;

public class MypageSummaryHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 세션에서 로그인한 유저 정보(MemberDTO) 가져오기
        HttpSession session = request.getSession();
        MemberDTO member = (MemberDTO) session.getAttribute("auth");

        if (member == null) {
            // 로그인 안 되어 있으면 401 에러
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        AdminUserService userService = AdminUserService.getInstance();
        UserInfoDTO summary = userService.getMyPageSummary(member.getUserNumber());


        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"couponCount\": ").append(summary.getCouponCount()).append(",");
        json.append("\"pointBalance\": ").append(summary.getBalance()).append(",");
        json.append("\"wishCount\": ").append(summary.getWishCount()).append(",");
        json.append("\"orderCount\": ").append(summary.getOrderCount());
        json.append("}");

        // 4. Content-Type 및 인코딩 설정 후 출력
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json.toString());
        
        return null;
    }
}