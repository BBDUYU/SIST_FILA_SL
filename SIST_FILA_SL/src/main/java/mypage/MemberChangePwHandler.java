package mypage;

import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import command.CommandHandler;
import member.MemberDAO;
import member.MemberDTO;

public class MemberChangePwHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // POST 방식일 때만 비밀번호 변경 처리
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String newPassword = request.getParameter("newPassword");
            
            HttpSession session = request.getSession();
            MemberDTO auth = (MemberDTO) session.getAttribute("auth");

            if (auth == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return null;
            }

            Connection conn = null;
            try {
                conn = ConnectionProvider.getConnection();
                MemberDAO dao = MemberDAO.getInstance();
                
                // DB 비밀번호 업데이트
                dao.updatePassword(conn, auth.getUserNumber(), newPassword);
                
                // 성공 시 응답 (AJAX에서 처리할 수 있도록 성공 메세지 반환)
                response.getWriter().write("success");
                return null; // AJAX 요청이므로 뷰 페이지로 이동하지 않음
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                return null;
            } finally {
                JdbcUtil.close(conn);
            }
        }
        
        // GET 방식일 경우 (직접 접근 시)
        return "/view/mypage/modifyInfo.htm"; 
    }
}