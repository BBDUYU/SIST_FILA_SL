package com.fila.app.controller.admin;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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

    @RequestMapping(value = "/productList.htm", method = RequestMethod.GET)
    public String productList(Model model) throws Exception {
        List<ProductVO> list = adminProductService.getProductList(); 
        model.addAttribute("productList", list);
        return "product_list";
    }

    @RequestMapping(value = {"/createProduct.htm", "/editProduct.htm"}, method = RequestMethod.GET)
    public String productForm(HttpServletRequest request, 
                              @RequestParam(value = "id", required = false) String productId, 
                              Model model) throws Exception {
        
        String path = request.getServletPath();
        boolean isEdit = path.contains("editProduct");
        adminProductService.getAdminFullFormData(request);

        if (isEdit && productId != null) {
            CreateproductVO product = adminProductService.getProductDetail(productId);
            List<CreateproductVO> imageList = adminProductService.getProductImages(productId);
            List<Map<String, Object>> productCategories = adminProductService.getProductCategories(productId);
            
            model.addAttribute("product", product);
            model.addAttribute("imageList", imageList);
            model.addAttribute("productCategories", productCategories);
            model.addAttribute("mode", "edit");
            return "product_edit";
        }

        model.addAttribute("mode", "create");
        return "product_create";
    }

    @RequestMapping(value = {"/createProduct.htm", "/editProduct.htm"}, method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processProduct(MultipartHttpServletRequest request) {
        Map<String, Object> jsonResponse = new HashMap<String, Object>();
        String path = request.getServletPath();
        boolean isEdit = path.contains("editProduct");

        try {
            String[] categoryIds = request.getParameterValues("category_ids");
            int mainCateId = (categoryIds != null && categoryIds.length > 0) ? parseSafeInt(categoryIds[0], 0) : 0;
            String productId = isEdit ? request.getParameter("product_id") : adminProductService.generateProductId(mainCateId);

            // 1. [수정] 삭제 로직: 물리 파일 삭제 실패해도 중단되지 않게 try-catch
            String[] deleteImageIds = request.getParameterValues("deleteImageIds");
            if (isEdit && deleteImageIds != null && deleteImageIds.length > 0) {
                List<String> deletePaths = adminProductService.getImagePathsByIds(deleteImageIds);
                for (String imgPath : deletePaths) {
                    try {
                        File file = new File(imgPath);
                        if (file.exists()) {
                            file.delete(); // 점유 중이면 false 리턴하겠지만 무시하고 진행
                        }
                    } catch (Exception e) {
                        System.err.println("파일 삭제 실패(무시하고 진행): " + imgPath);
                    }
                }
            }

            // 2. 새 파일 저장 (파일명에 유니크 값 추가하여 충돌 방지)
            List<CreateproductVO> imageList = processFiles(request, productId);

            String[] tagIds = request.getParameterValues("tag_ids");
            int price = parseSafeInt(request.getParameter("price"), 0);
            int discountRate = parseSafeInt(request.getParameter("discount_rate"), 0);
            int styleId = parseSafeInt(request.getParameter("styleId"), 0);
            int sectionId = parseSafeInt(request.getParameter("sectionId"), 0);
            int stock = parseSafeInt(request.getParameter("stock"), 10);

            CreateproductVO product = CreateproductVO.builder()
                    .productId(productId)
                    .categoryId(mainCateId)
                    .name(request.getParameter("name"))
                    .description(request.getParameter("description"))
                    .price(price)
                    .discountRate(discountRate)
                    .build();

            if (isEdit) {
                adminProductService.updateProduct(product, imageList, deleteImageIds, categoryIds, tagIds,
                        request.getParameter("gender_option"), 
                        request.getParameter("sport_option"),
                        request.getParameterValues("size_options"), 
                        styleId, sectionId, stock);
            } else {
                adminProductService.createProduct(product, categoryIds, tagIds,
                        request.getParameter("gender_option"), 
                        request.getParameter("sport_option"),
                        request.getParameterValues("size_options"), 
                        imageList, styleId, sectionId, stock);
            }

            jsonResponse.put("status", "success");
            jsonResponse.put("redirect", request.getContextPath() + "/admin/productList.htm");

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "처리 실패: " + e.getMessage());
        }
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(new MediaType("application", "json", StandardCharsets.UTF_8));
        return new ResponseEntity<>(jsonResponse, headers, HttpStatus.OK);
    }

    /**
     * [핵심 수정] 파일 저장 로직
     */
    private List<CreateproductVO> processFiles(MultipartHttpServletRequest request, String productId) throws Exception {
        List<CreateproductVO> imageList = new ArrayList<>();
        String rootPath = "C:/fila_upload/product/" + productId;
        File saveDir = new File(rootPath);
        if (!saveDir.exists()) saveDir.mkdirs();

        String[] types = {"MAIN", "MODEL", "DETAIL"};
        String[] paramNames = {"mainImages[]", "modelImages[]", "detailImages[]"};

        // 파일명에 쓸 시간값 (루프 밖에서 생성하여 동일 루프 내 일관성 유지 가능)
        long timestamp = System.currentTimeMillis();

        for (int i = 0; i < types.length; i++) {
            String type = types[i];
            List<MultipartFile> files = request.getFiles(paramNames[i]);
            if (files == null) continue;

            int subIdx = 1; 

            for (MultipartFile mFile : files) {
                if (mFile == null || mFile.isEmpty()) continue;

                String originalName = mFile.getOriginalFilename();
                String ext = originalName.contains(".") ? originalName.substring(originalName.lastIndexOf(".")).toLowerCase() : ".jpg";
                
                // [변경] productId + 타입 + 시간값 + 인덱스 + 확장자
                // 이렇게 하면 기존 파일명과 절대 겹칠 수 없습니다.
                String newFileName = productId + "_" + type.toLowerCase() + "_" + timestamp + "_" + subIdx + ext;
                File saveFile = new File(saveDir, newFileName);

                try {
                    mFile.transferTo(saveFile);
                    System.out.println("✅ [물리 저장 성공] " + newFileName);

                    imageList.add(CreateproductVO.builder()
                            .productId(productId)
                            .imageUrl("C:/fila_upload/product/" + productId + "/" + newFileName)
                            .imageType(type)
                            // isMain 로직: MAIN 타입의 루프 중 첫 번째 파일만 1
                            .isMain(type.equals("MAIN") && subIdx == 1 ? 1 : 0)
                            .sortOrder(subIdx)
                            .build());
                    
                    subIdx++;
                } catch (Exception e) {
                    System.err.println("❌ [물리 저장 실패] " + e.getMessage());
                    throw e;
                }
            }
        }
        return imageList;
    }

    @RequestMapping(value = "/deleteProduct.htm", method = RequestMethod.GET)
    public String deleteProduct(@RequestParam("id") String productId) {
        if (productId != null) {
            adminProductService.deleteProduct(productId);
        }
        return "redirect:/admin/productList.htm";
    }

    private int parseSafeInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) return defaultValue;
        try { return Integer.parseInt(value); } catch (NumberFormatException e) { return defaultValue; }
    }
}