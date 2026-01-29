package fila.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;

public class IdCheckHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String id = request.getParameter("id");

        response.setContentType("text/plain; charset=UTF-8");

        // 🔒 방어 코드 (null / 공백)
        if (id == null || id.trim().isEmpty()) {
            response.getWriter().write("INVALID");
            return null;
        }

        MemberDAO dao = MemberDAO.getInstance();
        boolean isDuplicate = dao.isDuplicateId(id.trim());

        response.getWriter().write(isDuplicate ? "DUPLICATE" : "OK");

        return null; // ❗ Ajax 응답 전용 (JSP 이동 X)
    }
}
