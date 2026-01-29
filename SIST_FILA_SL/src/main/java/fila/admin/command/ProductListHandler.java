package fila.admin.command;

import java.sql.Connection;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.admin.domain.ProductDTO;
import fila.admin.persistence.ProductDAO;
import fila.com.util.ConnectionProvider;
import fila.command.CommandHandler;

public class ProductListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        try (Connection conn = ConnectionProvider.getConnection()) {
            ProductDAO dao = ProductDAO.getInstance();
            ArrayList<ProductDTO> list = dao.selectProductList(conn);
            
            request.setAttribute("productList", list);
            return "/view/admin/product_list.jsp"; // 이동할 JSP 경로
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}