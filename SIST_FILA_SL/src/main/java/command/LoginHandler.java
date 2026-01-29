package command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import login.ILogin;
import login.LoginService;
import member.domain.MemberDTO;

public class LoginHandler implements CommandHandler {
    
    // 인터페이스 타입으로 선언, 구현체 생성
    private ILogin loginService = new LoginService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // GET 방식: 로그인 페이지 이동
        if (request.getMethod().equalsIgnoreCase("GET")) {
            return "/view/user/login.jsp";
        } 
        
        // POST 방식: 실제 로그인 처리
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String id = request.getParameter("mb_id");
            String pw = request.getParameter("password");

            // 서비스를 통해 로그인 검증
            MemberDTO member = loginService.login(id, pw);

            if (member == null) {
                // 실패 시 에러 파라미터를 들고 다시 로그인창으로
                return "/view/user/login.jsp?error=fail";
            }

            // 성공 시 세션에 'auth' 이름으로 저장
            HttpSession session = request.getSession();
            session.setAttribute("auth", member);
            session.setMaxInactiveInterval(60 * 30); // 30분 유지

            String returnUrl = request.getParameter("returnUrl");
            if (returnUrl != null && !returnUrl.trim().isEmpty()
                    && returnUrl.startsWith("/")
                    && !returnUrl.startsWith("//")) {
                response.sendRedirect(request.getContextPath() + returnUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/index.htm");
            }
            return null;
        }
        return null;
    }
}