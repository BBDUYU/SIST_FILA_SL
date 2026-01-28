package command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import search.SearchService;

public class SearchHandler implements CommandHandler {

	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String keyword = request.getParameter("keyword"); // JSP와 이름 통일!
	    
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        SearchService.getInstance().recordSearchKeyword(keyword);
	        
	        // AJAX에게 성공했다는 신호를 명확히 보냄
	        response.setContentType("text/plain; charset=UTF-8");
	        response.getWriter().write("success");
	        response.getWriter().flush(); // 버퍼 비우기
	    }
	    return null; // 뷰로 이동하지 않음 (AJAX 전용)
	}
}