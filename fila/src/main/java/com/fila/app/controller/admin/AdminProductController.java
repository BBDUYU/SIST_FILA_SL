package com.fila.app.controller.admin;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    /**
     * 1. 상품 목록 조회
     */
    @RequestMapping(value = "/productList.htm", method = RequestMethod.GET)
    public String productList(Model model) throws Exception {
        List<ProductVO> list = adminProductService.getProductList(); 
        model.addAttribute("productList", list);
        return "product_list";
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

    /**
     * 3. 상품 등록/수정 처리 (POST)
     */
    @RequestMapping(value = {"/createProduct.htm", "/editProduct.htm"}, method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processProduct(MultipartHttpServletRequest request) {
        Map<String, Object> jsonResponse = new HashMap<String, Object>();
        String path = request.getServletPath();
        boolean isEdit = path.contains("editProduct");

        try {
            // 1. 카테고리 ID 수집
            String[] categoryIds = request.getParameterValues("category_ids");
            int mainCateId = (categoryIds != null && categoryIds.length > 0) ? parseSafeInt(categoryIds[0], 0) : 0;

            // 2. 상품 ID 결정 (등록 시 시퀀스 선행 호출)
            String productId;
            if (isEdit) {
                productId = request.getParameter("product_id");
            } else {
                productId = adminProductService.generateProductId(mainCateId); 
            }

            // 3. 파일 처리 (이전 Handler의 processFiles 로직 적용)
            List<CreateproductVO> imageList = processFiles(request, productId);

            // 4. 나머지 파라미터 수집 (parseSafeInt 사용)
            String[] tagIds = request.getParameterValues("tag_ids");
            int price = parseSafeInt(request.getParameter("price"), 0);
            int discountRate = parseSafeInt(request.getParameter("discount_rate"), 0);
            int styleId = parseSafeInt(request.getParameter("styleId"), 0);
            int sectionId = parseSafeInt(request.getParameter("sectionId"), 0);
            int stock = parseSafeInt(request.getParameter("stock"), 10);

            // 5. VO 생성
            CreateproductVO product = CreateproductVO.builder()
                    .productId(productId)
                    .categoryId(mainCateId)
                    .name(request.getParameter("name"))
                    .description(request.getParameter("description"))
                    .price(price)
                    .discountRate(discountRate)
                    .build();

            // 6. 서비스 호출
            if (isEdit) {
                // 물리 파일 삭제 로직
                String[] deleteImageIds = request.getParameterValues("deleteImageIds");
                if (deleteImageIds != null && deleteImageIds.length > 0) {
                    List<String> deletePaths = adminProductService.getImagePathsByIds(deleteImageIds);
                    for (String imgPath : deletePaths) {
                        String physicalPath = imgPath.replace("/upload/", "C:\\fila_upload\\");
                        File file = new File(physicalPath);
                        if (file.exists()) file.delete();
                    }
                }

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
     * 이전 Handler에서 사용하던 로직을 스프링 환경에 맞게 재구성한 파일 처리 메서드
     */
    private List<CreateproductVO> processFiles(MultipartHttpServletRequest request, String productId) throws Exception {
        List<CreateproductVO> imageList = new ArrayList<CreateproductVO>();
        
        // [중요] 경로 끝에 슬래시 확인
        String baseDiskPath = "C:/fila_upload/product/" + productId + "/";
        File saveDir = new File(baseDiskPath);

        if (!saveDir.exists()) {
            saveDir.mkdirs();
        }

        java.util.Iterator<String> fileNames = request.getFileNames();
        int currentSortOrder = 1;
        
        // 타입별 인덱스 초기화
        int mainIdx = 1;
        int modelIdx = 1;
        int detailIdx = 1;

        while (fileNames.hasNext()) {
            String paramName = fileNames.next();
            List<MultipartFile> files = request.getFiles(paramName);

            for (MultipartFile mFile : files) {
                // 파일이 없거나 이름이 비어있으면 스킵
                if (mFile == null || mFile.isEmpty() || mFile.getOriginalFilename().isEmpty()) continue;

                // 타입 결정 로직 (좀 더 확실하게)
                String type = "DETAIL"; 
                if (paramName.toLowerCase().contains("main")) {
                    type = "MAIN";
                } else if (paramName.toLowerCase().contains("model")) {
                    type = "MODEL";
                }
                
                int subIdx = type.equals("MAIN") ? mainIdx++ : (type.equals("MODEL") ? modelIdx++ : detailIdx++);

                // 확장자 추출
                String originalName = mFile.getOriginalFilename();
                String ext = "";
                if (originalName.contains(".")) {
                    ext = originalName.substring(originalName.lastIndexOf(".")).toLowerCase();
                } else {
                    ext = ".jpg"; // 확장자 없을 경우 기본값
                }
                // [파일명 생성] 여기서 productId가 정확히 들어가는지 다시 확인
                String newFileName = productId + "_" + type.toLowerCase() + "_" + subIdx + ext;
                
                // 실제 파일 저장
                File saveFile = new File(saveDir, newFileName);
                mFile.transferTo(saveFile); 

                // 리스트 추가
                imageList.add(CreateproductVO.builder()
                        .productId(productId)
                        .imageUrl("C:/fila_upload/product/" + productId + "/" + newFileName) // DB 저장 경로
                        .imageType(type)
                        .isMain(type.equals("MAIN") && subIdx == 1 ? 1 : 0)
                        .sortOrder(currentSortOrder++)
                        .build());
            }
        }
        return imageList;
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
     * 문자열 숫자를 안전하게 변환하는 유틸리티 메서드
     */
    private int parseSafeInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}