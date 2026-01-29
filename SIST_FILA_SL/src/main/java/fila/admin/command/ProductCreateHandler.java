package fila.admin.command;

import java.io.File;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import fila.admin.domain.CreateproductDTO;
import fila.admin.persistence.CreateproductDAO;
import fila.admin.service.ProductService;
import fila.categories.CategoriesDAO;
import fila.categories.CategoriesDTO;
import fila.com.util.ConnectionProvider;
import fila.command.CommandHandler;

public class ProductCreateHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String command = request.getServletPath();
        boolean isEdit = command.contains("editProduct");

        // --- [GET] 등록/수정 페이지 이동 ---
        if (request.getMethod().equalsIgnoreCase("GET")) {
            ProductService service = ProductService.getInstance();
            service.getAdminFullFormData(request);

            try (Connection conn = ConnectionProvider.getConnection()) {
                CategoriesDAO categoryDao = CategoriesDAO.getInstance();
                ArrayList<CategoriesDTO> tagList = categoryDao.selectTagList(conn);
                request.setAttribute("tagList", tagList);
            }

            if (isEdit) {
                String productId = request.getParameter("id");
                CreateproductDTO product = ProductService.getInstance().getProductDetail(productId);
                request.setAttribute("product", product);
                ArrayList<CreateproductDTO> imageList = service.getProductImages(productId);
                request.setAttribute("imageList", imageList);
                request.setAttribute("mode", "edit");
                List<Map<String, Object>> productCategories = service.getProductCategories(productId);
                request.setAttribute("productCategories", productCategories);
                return "/view/admin/product_edit.jsp";
            }
            request.setAttribute("mode", "create");
            return "/view/admin/product_create.jsp";
        }

        // --- [POST] AJAX 상품 등록/수정 처리 ---
        else {
            // AJAX 응답을 위한 JSON 설정
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            Map<String, Object> jsonResponse = new HashMap<>();


            try (Connection conn = ConnectionProvider.getConnection()) {
                ProductService service = ProductService.getInstance();
                CreateproductDAO dao = CreateproductDAO.getInstance();

                // 1. 파라미터 수집 (MultipartConfig 설정 시 일반 request로 가능)
                String[] categoryIds = request.getParameterValues("category_ids");
                String[] tagIds = request.getParameterValues("tag_ids");
                String styleParam = request.getParameter("styleId");
                String sectionParam = request.getParameter("sectionId");
                
                int styleId = (styleParam != null && !styleParam.isEmpty()) ? Integer.parseInt(styleParam) : 0;
                int sectionId = (sectionParam != null && !sectionParam.isEmpty()) ? Integer.parseInt(sectionParam) : 0;
                int mainCateId = (categoryIds != null && categoryIds.length > 0) ? Integer.parseInt(categoryIds[0]) : 0;

                // 2. 상품 ID 결정
                String productId = isEdit ? request.getParameter("product_id") : dao.generateProductId(conn, mainCateId);

                // 3. 상품 기본 정보 DTO 생성
                CreateproductDTO product = CreateproductDTO.builder()
                        .product_id(productId)
                        .category_id(mainCateId)
                        .name(request.getParameter("name"))
                        .description(request.getParameter("description"))
                        .price(Integer.parseInt(request.getParameter("price")))
                        .discount_rate(Integer.parseInt(request.getParameter("discount_rate")))
                        .build();

                // 4. 파일 처리 (C:\fila_upload\product\ID 폴더로 이동)
                ArrayList<CreateproductDTO> imageList = processFiles(request, productId, isEdit);

                // 5. 부가 정보 수집
                String stockStr = request.getParameter("stock");
                int stock = (stockStr != null && !stockStr.isEmpty()) ? Integer.parseInt(stockStr) : 10;
                String[] deleteImageIds = request.getParameterValues("deleteImageIds");

                // 6. 서비스 호출
                if (isEdit) {
                    service.updateProduct(
                            product, imageList, deleteImageIds, categoryIds, tagIds,
                            request.getParameter("gender_option"),
                            request.getParameter("sport_option"),
                            request.getParameterValues("size_options"),
                            styleId, sectionId, stock
                    );
                } else {
                    service.createProduct(
                            product, categoryIds, tagIds,
                            request.getParameter("gender_option"),
                            request.getParameter("sport_option"),
                            request.getParameterValues("size_options"),
                            imageList, styleId, sectionId, stock
                    );
                }

                // 성공 응답 전송
                jsonResponse.put("status", "success");
                jsonResponse.put("redirect", request.getContextPath() + "/admin/productList.htm");
                out.print(jsonResponse.toString());

            } catch (Exception e) {
                e.printStackTrace();
                jsonResponse.put("status", "error");
                jsonResponse.put("message", e.getMessage());
                out.print(jsonResponse.toString());
            }
            return null; // AJAX 응답이므로 뷰 경로 리턴 안 함
        }
    }

    /**
     * 서블릿 3.0 getParts()를 이용한 파일 저장 로직
     */
    private ArrayList<CreateproductDTO> processFiles(HttpServletRequest request, String productId, boolean isEdit) throws Exception {
        ArrayList<CreateproductDTO> imageList = new ArrayList<>();
        String baseDiskPath = "C:/fila_upload/product/" + productId + "/";
        File saveDir = new File(baseDiskPath);

        // 폴더 생성 및 기존 파일 관리
        if (!saveDir.exists()) {
            saveDir.mkdirs();
        } else if (isEdit) {
            // 수정 시 기존 파일 로직은 필요에 따라 유지/삭제 결정 (일단 예시로 보존)
        }

        Collection<Part> parts = request.getParts();
        int currentSortOrder = 1;
        int mainIdx = 1, modelIdx = 1, detailIdx = 1;

        for (Part part : parts) {
            String paramName = part.getName(); // JSP input의 name
            String fileName = part.getSubmittedFileName();

            // 파일 파트가 아니거나 파일명이 없는 경우 건너뜀
            if (fileName == null || fileName.isEmpty()) continue;

            // 타입 구분
            String type = paramName.toLowerCase().contains("main") ? "MAIN" : 
                          (paramName.toLowerCase().contains("model") ? "MODEL" : "DETAIL");
            
            int subIdx = type.equals("MAIN") ? mainIdx++ : (type.equals("MODEL") ? modelIdx++ : detailIdx++);

            // 새 파일명 생성
            String ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            String newFileName = productId + "_" + type.toLowerCase() + "_" + subIdx + ext;
            
            // 물리 디스크 저장
            part.write(baseDiskPath + newFileName);
            System.out.println("✅ 물리 저장 성공: " + baseDiskPath + newFileName);

            // DB 저장을 위한 DTO 생성
            imageList.add(CreateproductDTO.builder()
                    .product_id(productId)
                    .image_url(baseDiskPath + newFileName)
                    .image_type(type)
                    .is_main(type.equals("MAIN") && subIdx == 1 ? 1 : 0)
                    .sort_order(currentSortOrder++)
                    .build());
        }
        return imageList;
    }
}