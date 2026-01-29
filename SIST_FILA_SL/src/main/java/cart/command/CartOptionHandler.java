package cart.command; // 패키지 경로 확인하세요

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.util.DBConn;
import products.service.ProductService;
import command.CommandHandler; // 사용하는 인터페이스

public class CartOptionHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // ProductService에 미리 만들어둔 메서드를 호출하여 데이터를 request에 담습니다.
        // (앞서 ProductService에 getCartOptionInfo 메서드를 추가했었죠?)
        ProductService.getInstance().getCartOptionInfo(request);
        
        // 데이터가 담긴 상태로 jsp를 보여줍니다.
        return "/view/pay/cart_option_modal.jsp"; 
    }
}