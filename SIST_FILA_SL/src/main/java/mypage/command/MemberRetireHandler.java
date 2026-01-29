package mypage.command;

import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import command.CommandHandler;
import member.MemberDAO;
import member.MemberDTO;

public class MemberRetireHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");

        if (auth == null) {
            return "redirect:/login.htm";
        }

        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            MemberDAO dao = MemberDAO.getInstance();
            
            // 1. DB 상태 변경
            int result = dao.retireMember(conn, auth.getUserNumber());
            
            if (result > 0) {
                // 2. 탈퇴 성공 시 세션 무효화 (로그아웃)
                session.invalidate();
                
                // 3. 알림창을 띄우기 위해 전용 페이지로 이동하거나 응답
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('회원탈퇴가 완료되었습니다. 그동안 이용해주셔서 감사합니다.'); location.href='" + request.getContextPath() + "/index.htm';</script>");
                return null; 
            } else {
                return "redirect:/mypage/modifyInfo.htm?error=retire_fail";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/mypage/modifyInfo.htm?error=server";
        } finally {
            JdbcUtil.close(conn);
        }
    }
}