package admin.command;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import mypage.domain.QnaDTO;
import mypage.service.QnaService;

public class AdminInquiryListHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        // 관리자 권한 체크 로직 (예: 세션에서 admin 여부 확인) 필요
        
        QnaService service = QnaService.getInstance();
        List<QnaDTO> list = service.getAllInquiryList();
        request.setAttribute("adminQnaList", list);
        
        return "/view/admin/inquiryList.jsp";
    }
}
