package fila.admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;
import fila.notice.NoticeDAOImpl;

public class NoticeDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 삭제할 공지사항 번호(id) 가져오기
        String strId = request.getParameter("id");
        
        if (strId != null && !strId.isEmpty()) {
            try {
                int noticeId = Integer.parseInt(strId);
                
                // 2. DAO를 통해 삭제 실행
                NoticeDAOImpl dao = NoticeDAOImpl.getInstance();
                int result = dao.delete(noticeId);
                
                if (result > 0) {
                    System.out.println("공지사항 삭제 성공: " + noticeId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        // 3. 서블릿이 리다이렉트 처리를 못하므로 핸들러에서 직접 처리
        // 삭제 성공 여부와 상관없이 목록으로 돌아감
        response.sendRedirect(request.getContextPath() + "/admin/noticeManage.htm");
        
        // 4. null을 리턴하여 DispatcherServlet이 forward를 하지 않도록 차단
        return null;
    }
}