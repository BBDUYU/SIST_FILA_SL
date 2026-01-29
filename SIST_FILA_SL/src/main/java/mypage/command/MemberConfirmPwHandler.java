package mypage.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import command.CommandHandler;
import login.LoginService;
import member.domain.MemberDTO;
import net.sf.json.JSONObject;

public class MemberConfirmPwHandler implements CommandHandler {
    
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 세션에서 로그인된 정보 가져오기
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");
        
        // 2. 사용자가 모달에서 입력한 비밀번호
        String inputPw = request.getParameter("memberPassword");
        JSONObject json = new JSONObject();

        if (auth == null) {
            json.put("ok", false);
            json.put("message", "세션이 만료되었습니다. 다시 로그인해주세요.");
        } else {
            // 3. 기존 LoginService를 활용하여 본인 확인
            LoginService loginService = new LoginService();
            // 세션의 ID와 입력받은 PW로 로그인 시도
            MemberDTO confirmUser = loginService.login(auth.getId(), inputPw);

            if (confirmUser != null) {
                // 본인 확인 성공
                json.put("ok", true);
            } else {
                // 비밀번호 불일치
                json.put("ok", false);
                json.put("message", "비밀번호가 일치하지 않습니다.");
            }
        }

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().print(json.toString());
        return null; 
    }
}