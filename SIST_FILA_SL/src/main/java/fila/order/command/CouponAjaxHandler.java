package fila.order.command;

import java.io.PrintWriter;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import fila.admin.domain.UserInfoDTO;
import fila.admin.service.CouponService;
import fila.command.CommandHandler;
import fila.member.MemberDTO;
import net.sf.json.JSONArray;

public class CouponAjaxHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        
        // 1. 세션에서 'auth' 객체 꺼내기
        MemberDTO member = (MemberDTO) session.getAttribute("auth");

        // 2. 로그인 여부 체크 (방어 코드)
        if (member == null) {
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print("[]");
            return null;
        }

        // 3. MemberDTO의 메서드명 'getUserNumber()' 사용
        int userNum = member.getUserNumber(); 

        // 4. 서비스 호출 (CouponService에 해당 메서드가 있는지 확인 필수)
        CouponService service = CouponService.getInstance();
        List<UserInfoDTO> list = service.getUserCouponList(userNum);

        // 5. JSON 출력
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        JSONArray jsonArray = JSONArray.fromObject(list);
        out.print(jsonArray);
        out.flush();
        
        return null; 
    }
}