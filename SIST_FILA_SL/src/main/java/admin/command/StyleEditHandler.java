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

public class StyleEditHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        StyleService service = StyleService.getInstance();
        
        if (request.getMethod().equalsIgnoreCase("GET")) {
            // 1. 수정할 스타일 ID 파라미터 수집
            int styleId = Integer.parseInt(request.getParameter("id"));
            
            try (Connection conn = ConnectionProvider.getConnection()) {
                // 2. 스타일 기본 정보 조회
                StyleDTO styleDto = service.getStyleDetail(styleId);
                // 3. 스타일 이미지 리스트 조회
                List<StyleImageDTO> imageList = service.getStyleImages(styleId);
                // 4. 전체 상품 리스트 (선택용)
                ProductDAO pDao = ProductDAO.getInstance();
                List<ProductDTO> productList = pDao.selectProductList(conn);
                // 5. 현재 매칭된 상품 ID 리스트 (JSP에서 checked 처리용)
                List<String> matchedProductIds = service.getMatchedProductIds(styleId);

                request.setAttribute("style", styleDto);
                request.setAttribute("imageList", imageList);
                request.setAttribute("productList", productList);
                request.setAttribute("matchedProductIds", matchedProductIds);
            }
            return "/view/admin/style_edit.jsp";
        } 

        else { // POST 요청 (수정 실행)
            request.setCharacterEncoding("UTF-8");
            
            int styleId = Integer.parseInt(request.getParameter("style_id"));
            String styleName = request.getParameter("style_name");
            String description = request.getParameter("description");
            int useYn = Integer.parseInt(request.getParameter("use_yn") != null ? request.getParameter("use_yn") : "1");
            String[] matchProducts = request.getParameterValues("match_products");
            if (matchProducts == null) matchProducts = new String[0];

            // 1. DTO 생성 및 기본 정보 업데이트
            StyleDTO styleDto = StyleDTO.builder()
                    .style_id(styleId)
                    .style_name(styleName)
                    .description(description)
                    .use_yn(useYn)
                    .build();
            
            // 2. 파일 업로드 처리 (새로운 파일이 있는지 확인)
            Collection<Part> parts = request.getParts();
            List<StyleImageDTO> newImageList = new ArrayList<>();
            boolean hasNewImages = false;

            for (Part part : parts) {
                if (part.getName().equals("style_images") && part.getSize() > 0) {
                    hasNewImages = true;
                    break;
                }
            }

            if (hasNewImages) {
                // [신규 파일이 있는 경우] 기존 물리 파일 및 폴더 삭제 후 재생성
                String uploadPath = "C:\\fila_upload\\style\\" + styleId;
                deleteDirectory(new File(uploadPath)); // 기존 폴더 삭제 유틸 호출
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                int order = 1;
                for (Part part : parts) {
                    if (part.getName().equals("style_images") && part.getSize() > 0) {
                        String fileName = getFileName(part);
                        if (fileName != null && !fileName.isEmpty()) {
                            part.write(uploadPath + File.separator + fileName);

                            StyleImageDTO imgDto = new StyleImageDTO();
                            imgDto.setStyle_id(styleId);
                            // 등록 때와 마찬가지로 안전한 슬래시(/) 경로 사용
                            imgDto.setImage_url("C:/fila_upload/style/" + styleId + "/" + fileName);
                            imgDto.setIs_main(order == 1 ? 1 : 0);
                            imgDto.setSort_order(order++);
                            imgDto.setAlt_text(styleName);
                            newImageList.add(imgDto);
                        }
                    }
                }
            }

            // 3. 서비스 호출 (Master 정보 수정 + 이미지/상품 정보 갱신)
            // hasNewImages가 true면 기존 이미지를 DB에서 지우고 새로 등록하도록 서비스에서 처리해야 함
            service.updateStyleComplete(styleDto, newImageList, matchProducts, hasNewImages);

            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().print("success");
            return null;
        }
    }

    // 파일명 추출 유틸리티
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

    // 기존 폴더 및 하위 파일 삭제 유틸리티
    private void deleteDirectory(File directory) {
        if (directory.exists()) {
            File[] files = directory.listFiles();
            if (files != null) {
                for (File file : files) {
                    if (file.isDirectory()) deleteDirectory(file);
                    else file.delete();
                }
            }
            directory.delete();
        }
    }
}