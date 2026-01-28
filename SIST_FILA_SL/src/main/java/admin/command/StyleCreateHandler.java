package admin.command;

import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.util.ConnectionProvider;

import admin.domain.ProductDTO;
import admin.domain.StyleDTO;
import admin.domain.StyleImageDTO;
import admin.persistence.ProductDAO;
import admin.service.StyleService;
import command.CommandHandler;

public class StyleCreateHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (request.getMethod().equalsIgnoreCase("GET")) {
            ProductDAO pDao = ProductDAO.getInstance();
            try (Connection conn = ConnectionProvider.getConnection()) {
                List<ProductDTO> productList = pDao.selectProductList(conn);
                request.setAttribute("productList", productList);
            }
            return "/view/admin/style_create.jsp";
        } 

        else { // POST 요청
            request.setCharacterEncoding("UTF-8"); // 한글 깨짐 방지
            
            String styleName = request.getParameter("style_name");
            String description = request.getParameter("description");
            int useYn = Integer.parseInt(request.getParameter("use_yn") != null ? request.getParameter("use_yn") : "1");
            
            // 상품 선택 안 했을 때 에러 방지
            String[] matchProducts = request.getParameterValues("match_products");
            if (matchProducts == null) matchProducts = new String[0];

            StyleDTO styleDto = StyleDTO.builder()
                    .style_name(styleName)
                    .description(description)
                    .use_yn(useYn)
                    .build();

            StyleService service = StyleService.getInstance();
            int styleId = service.registerStyleMaster(styleDto);

            if (styleId > 0) {
                // 1. 물리적 저장 경로는 윈도우 형식을 따름
                String uploadPath = "C:\\fila_upload\\style\\" + styleId;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                List<StyleImageDTO> imageList = new ArrayList<>();
                int order = 1;

                Collection<Part> parts = request.getParts();
                for (Part part : parts) {
                    if (part.getName().equals("style_images") && part.getSize() > 0) {
                        String fileName = getFileName(part); 
                        if (fileName != null && !fileName.isEmpty()) {
                            // 실제 파일 쓰기
                            part.write(uploadPath + File.separator + fileName);

                            StyleImageDTO imgDto = new StyleImageDTO();
                            imgDto.setStyle_id(styleId);
                            
                            // [핵심수정] DB에는 슬래시(/)로 저장해야 톰캣 에러(RFC 7230)가 발생하지 않습니다.
                            // 윈도우 OS도 C:/fila_upload/... 경로를 문제없이 인식합니다.
                            String dbPath = "C:/fila_upload/style/" + styleId + "/" + fileName;
                            imgDto.setImage_url(dbPath);
                            
                            imgDto.setIs_main(order == 1 ? 1 : 0);
                            imgDto.setSort_order(order++);
                            imgDto.setAlt_text(styleName);
                            imageList.add(imgDto);
                        }
                    }
                }

                service.registerStyleDetails(styleId, imageList, matchProducts);
                
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().print("success");
            }
            return null;
        }    
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}