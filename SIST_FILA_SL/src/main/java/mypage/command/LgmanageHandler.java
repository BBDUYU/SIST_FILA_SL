package mypage.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.domain.MemberDTO;
import mypage.domain.QnaDTO;
import mypage.persistence.QnaDAO;
import mypage.persistence.QnaDAOImpl;

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
