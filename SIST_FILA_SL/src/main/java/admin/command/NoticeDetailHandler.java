package admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import notice.NoticeDAOImpl;
import notice.NoticeDTO;

public class NoticeDetailHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 파라미터로 넘어온 공지사항 번호(id) 받기
        String strId = request.getParameter("id");
        
        // 번호가 없으면 목록으로 튕겨내기 (방어 코드)
        if (strId == null || strId.isEmpty()) {
            return "redirect:/admin/noticeManage.htm";
        }
        
        int noticeId = Integer.parseInt(strId);

        // 2. DAO 싱글톤 객체 가져와서 상세 정보 조회
        NoticeDAOImpl dao = NoticeDAOImpl.getInstance();
        NoticeDTO dto = dao.selectOne(noticeId);

        // 3. 조회 결과가 없으면 목록으로 이동
        if (dto == null) {
            return "redirect:/admin/noticeManage.htm";
        }

        // 4. JSP에서 사용할 수 있도록 request에 담기
        request.setAttribute("dto", dto);
        request.setAttribute("pageName", "notice"); // 사이드바 활성화용

        // 5. 아까 만든 관리자 전용 상세 페이지(JSP) 리턴
        return "/view/admin/notice_detail.jsp";
    }
}