package fila.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;

public class JoinEndHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {

        // ✅ joinend.jsp로 forward
        return "/view/user/joinend.jsp";
    }
}
