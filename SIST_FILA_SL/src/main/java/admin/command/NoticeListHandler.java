package admin.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler;
import notice.NoticeDAOImpl;
import notice.NoticeDTO;

public class NoticeListHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 검색 파라미터 처리
        String category = request.getParameter("category");
        String keyword = request.getParameter("keyword");

        NoticeDAOImpl dao = NoticeDAOImpl.getInstance();
        List<NoticeDTO> list = dao.selectList(category, keyword);

        request.setAttribute("noticeList", list);
        // 사용자용(이미지 크게 나오는 버전) JSP 리턴
        return "/view/notice/notice_list.jsp"; 
    }
}