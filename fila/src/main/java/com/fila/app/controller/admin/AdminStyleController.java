package com.fila.app.controller.admin;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

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

import com.fila.app.domain.admin.ProductVO;
import com.fila.app.domain.admin.StyleVO;
import com.fila.app.domain.admin.StyleImageVO;
import com.fila.app.domain.admin.StyleProductVO;
import com.fila.app.service.admin.AdminProductService;
import com.fila.app.service.admin.AdminStyleService;

@Controller
@RequestMapping("/admin")
public class AdminStyleController {

    @Autowired
    private AdminStyleService styleService;

    @Autowired
    private AdminProductService adminProductService;

    /**
     * 1. 스타일 목록 조회
     */
    @RequestMapping(value = "/styleList.htm", method = RequestMethod.GET)
    public String styleList(Model model) throws Exception {
        List<StyleVO> styleList = styleService.getStyleList();
        model.addAttribute("styleList", styleList);
        return "style_list";
    }

    /**
     * 2. 스타일 등록/수정 페이지 이동
     */
    @RequestMapping(value = {"/createStyle.htm", "/editStyle.htm"}, method = RequestMethod.GET)
    public String styleForm(HttpServletRequest request,
                           @RequestParam(value = "id", required = false) Integer styleId,
                           Model model) throws Exception {
        
        List<ProductVO> productList = adminProductService.getProductList();
        model.addAttribute("productList", productList);

        if (request.getServletPath().contains("editStyle") && styleId != null) {
            StyleVO style = styleService.getStyleDetail(styleId);
            List<StyleImageVO> imageList = styleService.getStyleImages(styleId);
            List<String> matchedProductIds = styleService.getMatchedProductIds(styleId);

            model.addAttribute("style", style);
            model.addAttribute("imageList", imageList);
            model.addAttribute("matchedProductIds", matchedProductIds);
            return "admin/style_edit";
        }
        return "style_create";
    }

    /**
     * 3. 스타일 저장 및 수정 처리 (AJAX)
     */
    @RequestMapping(value = {"/createStyle.htm", "/editStyle.htm"}, method = RequestMethod.POST)
    @ResponseBody
    public String processStyle(MultipartHttpServletRequest request) throws Exception {
        
        String path = request.getServletPath();
        boolean isEdit = path.contains("editStyle");

        String styleName = request.getParameter("style_name");
        String description = request.getParameter("description");
        int useYn = Integer.parseInt(request.getParameter("use_yn") != null ? request.getParameter("use_yn") : "1");
        String[] productIds = request.getParameterValues("match_products");

        StyleVO styleVo = StyleVO.builder()
                .styleName(styleName)
                .description(description)
                .useYn(useYn)
                .build();

        int styleId;
        
        if (isEdit) {
            styleId = Integer.parseInt(request.getParameter("style_id"));
            styleVo.setStyleId(styleId);
        } else {
            // [방법 1 적용 후] DB에 마스터를 먼저 넣고 styleId를 받아옴
            styleService.registerStyleMaster(styleVo); 
            styleId = styleVo.getStyleId(); 
        }

        // 파일 처리
        List<MultipartFile> files = request.getFiles("style_images");
        List<StyleImageVO> imageList = new ArrayList<>();
        boolean hasNewImages = (files != null && !files.isEmpty() && !files.get(0).isEmpty());

        if (hasNewImages) {
            String uploadPath = "C:/fila_upload/style/" + styleId + "/"; // 번호 기반 폴더
            File dir = new File(uploadPath);
            
            if (dir.exists()) deleteDirectory(dir);
            dir.mkdirs();

            for (int i = 0; i < files.size(); i++) {
                MultipartFile mFile = files.get(i);
                if (mFile.isEmpty()) continue;

                String fileName = mFile.getOriginalFilename();
                mFile.transferTo(new File(uploadPath + fileName));

                String dbPath = "C:/fila_upload/style/" + styleId + "/" + fileName;

                imageList.add(StyleImageVO.builder()
                        .styleId(styleId)
                        .imageUrl(dbPath)
                        .isMain(i == 0 ? 1 : 0) 
                        .sortOrder(i + 1)
                        .altText(styleName)
                        .build());
            }
        }

        // 최종 저장
        if (isEdit) {
            styleService.updateStyleComplete(styleVo, imageList, productIds, hasNewImages);
        } else {
            List<StyleProductVO> styleProducts = new ArrayList<>();
            if (productIds != null) {
                for (int i = 0; i < productIds.length; i++) {
                    styleProducts.add(StyleProductVO.builder()
                            .styleId(styleId)
                            .productId(productIds[i])
                            .sortOrder(i + 1)
                            .build());
                }
            }
            // 아까 확인한 인터페이스 메서드명 registerStyle로 호출
            styleService.registerStyle(styleVo, imageList, styleProducts);
        }

        return "success";
    }

    /**
     * 4. 노출 상태 토글
     */
    @RequestMapping(value = "/toggleStyle.htm", method = RequestMethod.GET)
    @ResponseBody
    public String toggleStyle(@RequestParam("id") int id, @RequestParam("status") int status) {
        return styleService.updateStyleStatus(id, status) ? "success" : "fail";
    }

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