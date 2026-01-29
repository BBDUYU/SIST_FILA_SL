package fila.admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.service.StyleService;
import fila.command.CommandHandler;

public class StyleToggleHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // GET 방식으로 넘어온 파라미터 수집
        int id = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));

        StyleService service = StyleService.getInstance();
        
        // 🚩 DB 상태 업데이트 (Service -> DAO 호출)
        boolean result = service.updateStyleStatus(id, status);

        if (result) {
            response.getWriter().print("success"); // JSP의 res.trim() === "success"와 매칭
        } else {
            response.getWriter().print("fail");
        }
        
        return null; // AJAX 응답이므로 null 리턴
    }
}