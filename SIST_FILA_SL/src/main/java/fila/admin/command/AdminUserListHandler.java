package fila.admin.command;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.domain.UserInfoDTO;
import fila.admin.service.AdminUserService;
import fila.command.CommandHandler;

public class AdminUserListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 서비스 호출하여 데이터 가져오기
        AdminUserService service = AdminUserService.getInstance();
        ArrayList<UserInfoDTO> userList = service.getUserList();
        
        // 2. 결과 데이터를 request에 저장
        request.setAttribute("userList", userList);
        
        // 3. 뷰 페이지(JSP) 경로 리턴
        return "/view/admin/admin_user.jsp";
    }
}