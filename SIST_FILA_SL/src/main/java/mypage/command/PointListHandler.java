package mypage.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import admin.domain.UserInfoDTO;
import admin.service.AdminUserService;
import command.CommandHandler;
import member.MemberDTO;

public class PointListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 세션에서 로그인 정보 확인
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");

        if (auth == null) {
            return "redirect:/login.htm";
        }

        // 2. 서비스 호출 (관리자용 AdminUserService 활용)
        AdminUserService service = AdminUserService.getInstance();
        
        // getUserDetail 메서드 내부에서 이미 selectPointList를 호출하여 pointList를 채워줍니다.
        UserInfoDTO user = service.getUserDetail(auth.getUserNumber());
        
        // 3. 뷰로 데이터 전달
        request.setAttribute("user", user);
        
        return "/view/mypage/mypoint.jsp";
    }
}