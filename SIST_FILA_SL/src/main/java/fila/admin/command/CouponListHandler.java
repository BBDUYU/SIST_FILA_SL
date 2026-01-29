package fila.admin.command;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.domain.CouponDTO;
import fila.admin.service.CouponService;
import fila.command.CommandHandler;

public class CouponListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 서비스 객체 생성 (싱글톤)
        CouponService service = CouponService.getInstance();
        
        try {
            // 2. DB에서 쿠폰 목록 가져오기
            List<CouponDTO> list = service.getCouponList();
            
            // 3. JSP에서 사용할 수 있도록 request에 저장
            request.setAttribute("couponList", list);
            
            // 4. 리스트를 보여줄 JSP 경로 리턴
            // 파일 위치에 따라 /view/admin/coupon_list.jsp 등으로 조정하세요.
            return "/view/admin/coupon_list.jsp"; 
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}