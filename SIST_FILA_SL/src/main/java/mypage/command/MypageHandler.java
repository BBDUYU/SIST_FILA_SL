package mypage.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;

public class MypageHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {

        // ✅ 마이페이지 기본 진입 화면
        // 처음엔 1:1 문의를 기본으로 보여주자
        request.setAttribute("contentPage", "/view/mypage/qna.jsp");

        return "/view/mypage/qna.jsp"; // 레이아웃 JSP
    }
}
