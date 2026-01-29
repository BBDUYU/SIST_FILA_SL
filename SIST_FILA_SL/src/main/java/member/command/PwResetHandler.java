package member.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.persistence.MemberDAO;

public class PwResetHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        response.setContentType("text/plain; charset=UTF-8");

        String id = request.getParameter("id");
        String newPw = request.getParameter("newPw");

        System.out.println("▶ PwResetHandler 호출됨");
        System.out.println("▶ id = " + id);
        System.out.println("▶ newPw = " + newPw);

        if (id == null || newPw == null || newPw.length() < 4) {
            response.getWriter().write("FAIL");
            return null;
        }

        MemberDAO dao = MemberDAO.getInstance();
        boolean result = dao.updatePassword(id, newPw);

        if (result) {
            response.getWriter().write("OK");
        } else {
            response.getWriter().write("FAIL");
        }

        return null; // 🔥 중요
    }
}
