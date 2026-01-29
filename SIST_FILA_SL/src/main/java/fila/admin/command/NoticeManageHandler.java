package fila.admin.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.command.CommandHandler;
import fila.notice.NoticeDAOImpl;
import fila.notice.NoticeDTO;

public class NoticeManageHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setAttribute("pageName", "notice"); // 사이드바 활성화

        NoticeDAOImpl dao = NoticeDAOImpl.getInstance();
        List<NoticeDTO> list = dao.selectList(null, null); // 관리자는 일단 전체보기

        request.setAttribute("noticeList", list);
        // 관리자용(표 형식) JSP 리턴
        return "/view/admin/notice_admin_list.jsp"; 
    }
}