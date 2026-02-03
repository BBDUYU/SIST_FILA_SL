package com.fila.app.controller.admin;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fila.app.domain.admin.CreateproductVO;
import com.fila.app.domain.admin.ProductVO;
import com.fila.app.service.admin.AdminProductService;

@Controller
@RequestMapping("/admin")
public class AdminProductController {

    @Autowired
    private AdminProductService adminProductService;

    /**
     * 1. 상품 목록 조회
     */
    @RequestMapping(value = "/productList.htm", method = RequestMethod.GET)
    public String productList(Model model) throws Exception {
        // ProductVO 리스트를 가져와서 목록 화면에 전달
        List<ProductVO> list = adminProductService.getProductList(); 
        model.addAttribute("productList", list);
        return "admin/product_list";
    }

    /**
     * 2. 상품 등록/수정 페이지 이동
     */
    @RequestMapping(value = {"/createProduct.htm", "/editProduct.htm"}, method = RequestMethod.GET)
    public String productForm(HttpServletRequest request, 
                             @RequestParam(value = "id", required = false) String productId, 
                             Model model) throws Exception {
        
        String path = request.getServletPath();
        boolean isEdit = path.contains("editProduct");

        // 공통 폼 데이터(옵션 리스트, 스타일 리스트 등) 로드
        adminProductService.getAdminFullFormData(request);

        if (isEdit && productId != null) {
            CreateproductVO product = adminProductService.getProductDetail(productId);
            List<CreateproductVO> imageList = adminProductService.getProductImages(productId);
            List<Map<String, Object>> productCategories = adminProductService.getProductCategories(productId);
            
            model.addAttribute("product", product);
            model.addAttribute("imageList", imageList);
            model.addAttribute("productCategories", productCategories);
            model.addAttribute("mode", "edit");
            return "admin/product_edit";
        }

        model.addAttribute("mode", "create");
        return "admin/product_create";
    }

    /**
     * 3. 상품 등록/수정 처리 (AJAX)
     */
    @RequestMapping(value = {"/createProduct.htm", "/editProduct.htm"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> processProduct(MultipartHttpServletRequest request) {
        Map<String, Object> jsonResponse = new HashMap<String, Object>();
        String path = request.getServletPath();
        boolean isEdit = path.contains("editProduct");

        try {
            // 1. 기본 파라미터 수집
            String productId = isEdit ? request.getParameter("product_id") : "TEMP_" + System.currentTimeMillis();
            String[] categoryIds = request.getParameterValues("category_ids");
            String[] tagIds = request.getParameterValues("tag_ids");
            
            // 2. 파일 처리 (MultipartFile 이용)
            List<CreateproductVO> imageList = handleFileUpload(request, productId);

            // 3. VO 생성 및 기본 데이터 세팅
            CreateproductVO product = CreateproductVO.builder()
                    .productId(isEdit ? productId : null) // 신규등록시 Service에서 ID 생성 로직 탈 수 있게 null 처리 가능
                    .name(request.getParameter("name"))
                    .description(request.getParameter("description"))
                    .price(Integer.parseInt(request.getParameter("price")))
                    .discountRate(Integer.parseInt(request.getParameter("discount_rate")))
                    .build();

            // 4. 서비스 호출
            if (isEdit) {
                String[] deleteImageIds = request.getParameterValues("deleteImageIds");
                adminProductService.updateProduct(product, imageList, deleteImageIds, categoryIds, tagIds,
                        request.getParameter("gender_option"), request.getParameter("sport_option"),
                        request.getParameterValues("size_options"), 
                        Integer.parseInt(request.getParameter("styleId")), 
                        Integer.parseInt(request.getParameter("sectionId")), 
                        Integer.parseInt(request.getParameter("stock")));
            } else {
                adminProductService.createProduct(product, categoryIds, tagIds,
                        request.getParameter("gender_option"), request.getParameter("sport_option"),
                        request.getParameterValues("size_options"), imageList, 
                        Integer.parseInt(request.getParameter("styleId")), 
                        Integer.parseInt(request.getParameter("sectionId")), 
                        Integer.parseInt(request.getParameter("stock")));
            }

            jsonResponse.put("status", "success");
            jsonResponse.put("redirect", request.getContextPath() + "/admin/productList.htm");

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "처리 실패: " + e.getMessage());
        }
        return jsonResponse;
    }

    /**
     * 4. 상품 삭제 (상태 변경)
     */
    @RequestMapping(value = "/deleteProduct.htm", method = RequestMethod.GET)
    public String deleteProduct(@RequestParam("id") String productId) {
        if (productId != null) {
            adminProductService.deleteProduct(productId);
        }
        return "redirect:/admin/productList.htm";
    }

    /**
     * 파일 업로드 유틸리티 (Spring MultipartFile 방식)
     */
    private List<CreateproductVO> handleFileUpload(MultipartHttpServletRequest request, String productId) throws Exception {
        List<CreateproductVO> imageList = new ArrayList<CreateproductVO>();
        String baseDiskPath = "C:/fila_upload/product/" + productId + "/";
        File saveDir = new File(baseDiskPath);
        if (!saveDir.exists()) saveDir.mkdirs();

        Map<String, MultipartFile> fileMap = request.getFileMap();
        int sortOrder = 1;
        
        for (Map.Entry<String, MultipartFile> entry : fileMap.entrySet()) {
            MultipartFile mFile = entry.getValue();
            if (mFile.isEmpty()) continue;

            String paramName = entry.getKey();
            String type = paramName.toLowerCase().contains("main") ? "MAIN" : 
                          (paramName.toLowerCase().contains("model") ? "MODEL" : "DETAIL");
            
            String originalName = mFile.getOriginalFilename();
            String ext = originalName.substring(originalName.lastIndexOf("."));
            String newFileName = productId + "_" + type.toLowerCase() + "_" + System.currentTimeMillis() + ext;

            // 물리적 파일 저장
            mFile.transferTo(new File(baseDiskPath + newFileName));

            // VO에 이미지 정보 담기
            imageList.add(CreateproductVO.builder()
                    .productId(productId)
                    .imageUrl("/upload/product/" + productId + "/" + newFileName) // 웹에서 접근 가능한 경로로 저장 권장
                    .imageType(type)
                    .is_main(type.equals("MAIN") ? 1 : 0)
                    .sortOrder(sortOrder++)
                    .build());
        }
        return imageList;
    }
}