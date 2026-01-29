package admin.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import admin.service.ProductService;
import command.CommandHandler;

public class ProductDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String productId = request.getParameter("id");
        
        if (productId != null && !productId.isEmpty()) {
            try {
                ProductService.getInstance().deleteProduct(productId);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "상품 삭제 중 오류가 발생했습니다.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/productList.htm");

        return null; 
    }
}