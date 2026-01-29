package fila.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;

public class SearchIdPwHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

	    String name = request.getParameter("name");
	    String phone = request.getParameter("phone");

	    MemberDAO dao = MemberDAO.getInstance();
	    String id = dao.findIdByNameAndPhone(name, phone);

	    response.setContentType("text/plain; charset=UTF-8");
	    response.getWriter().write(id == null ? "" : id);
	    return null;
	}
}