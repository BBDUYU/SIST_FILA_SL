package fila.mypage.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;
import fila.member.MemberDTO;
import fila.mypage.domain.QnaDTO;
import fila.mypage.persistence.QnaDAO;
import fila.mypage.persistence.QnaDAOImpl;

public class LgmanageHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {

        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser == null) {
            return "redirect:/login.htm";
        }


        // 🔥 핵심: mypage.jsp가 이걸 include 하게 만든다
        request.setAttribute("contentPage", "/view/mypage/lgmanage.jsp");

        // 🔥 반드시 mypage.jsp로 간다 (단독 렌더링 금지)
        return "/view/mypage/lgmanage.jsp";
    }
}
