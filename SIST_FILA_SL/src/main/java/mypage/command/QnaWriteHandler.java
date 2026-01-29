package mypage.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.MemberDTO;
import mypage.domain.QnaDTO;
import mypage.service.QnaService;

public class QnaWriteHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
	    if (loginUser == null) {
	        response.sendRedirect(request.getContextPath() + "/login.htm");
	        return null;
	    }

	    // JSP의 <select name="categoryId">와 <input name="privacyAgree"> 확인 필수!
	    int categoryId = Integer.parseInt(request.getParameter("categoryId")); 
	    String title = request.getParameter("title");
	    String content = request.getParameter("content");
	    int privacyAgree = Integer.parseInt(request.getParameter("privacyAgree")); // 추가

	    QnaDTO dto = QnaDTO.builder()
	            .category_id(categoryId)
	            .title(title)
	            .content(content)
	            .build();

	    QnaService service = QnaService.getInstance();
	    // privacyAgree 인자 추가 전달
	    service.writeQna(loginUser, dto, privacyAgree);

	    response.sendRedirect(request.getContextPath() + "/mypage/qna.htm");
	    return null;
	}

}
