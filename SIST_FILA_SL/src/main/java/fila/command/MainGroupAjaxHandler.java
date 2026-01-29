package fila.command;

import java.sql.Connection;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import fila.com.util.ConnectionProvider;
import fila.products.ProductsDTO;
import fila.products.TagProductsDAO;
import net.sf.json.JSONArray;

public class MainGroupAjaxHandler implements CommandHandler {
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    int tagId = Integer.parseInt(request.getParameter("tagId"));
	    
	    try (Connection conn = ConnectionProvider.getConnection()) {
	        TagProductsDAO dao = TagProductsDAO.getInstance();
	        List<ProductsDTO> list = dao.selectProductsByTag(conn, tagId);
	        
	        // [중요] JSON 변환 전, 모든 상품의 이미지 경로를 브라우저용으로 강제 세팅
	        for (ProductsDTO dto : list) {
	            String rawPath = dto.getProduct_id(); // 혹은 원래 image_url 필드값
	            // DTO의 getImage_url() 로직을 여기서 미리 실행해서 필드에 덮어씌웁니다.
	            String webPath = dto.getImage_url(); 
	            dto.setImage_url(webPath); 
	        }

	        response.setContentType("application/json; charset=utf-8");
	        // 이제 필드값 자체가 가공되었으므로 JSON에 정상적으로 담깁니다.
	        JSONArray jsonArray = JSONArray.fromObject(list);
	        response.getWriter().print(jsonArray);
	        
	        return null;
	    }
	}
}