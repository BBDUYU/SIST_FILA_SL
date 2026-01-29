package fila.login;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;

public class JoinFormHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        return "/view/user/join.jsp";
    }
}
