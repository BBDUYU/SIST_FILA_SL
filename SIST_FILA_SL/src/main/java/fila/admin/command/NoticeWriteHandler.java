package fila.admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import fila.command.CommandHandler;
import fila.notice.NoticeDAOImpl;
import fila.notice.NoticeDTO;

public class NoticeWriteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.setAttribute("pageName", "notice");
            return "/view/admin/notice_admin_write.jsp";
        } 
        
        else if (request.getMethod().equalsIgnoreCase("POST")) {
            request.setCharacterEncoding("UTF-8");

            String category = request.getParameter("category_name");
            String title = request.getParameter("title");
            String imageUrl = request.getParameter("image_url");
            
            // JSP에서 전달된 created_id 받기
            String createdId = request.getParameter("created_id");

            // [방어 코드] 만약 세션이 끊겨서 null이 넘어오면 에러 방지를 위해 강제 세팅
            if (createdId == null || createdId.isEmpty()) {
                createdId = "admin"; // 혹은 세션 체크 로직 추가
            }

            NoticeDTO dto = new NoticeDTO();
            dto.setCategory_name(category);
            dto.setTitle(title);
            dto.setImage_url(imageUrl);
            dto.setCreated_id(createdId); // 여기가 NULL이면 ORA-01400 에러 발생

            NoticeDAOImpl dao = NoticeDAOImpl.getInstance();
            int result = dao.insert(dto);

            if (result > 0) {
            	response.sendRedirect(request.getContextPath() + "/admin/noticeManage.htm");
                return null;
            } else {
                return "/view/admin/notice_admin_write.jsp";
            }
        }
        return null;
    }
}