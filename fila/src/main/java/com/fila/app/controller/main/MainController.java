package com.fila.app.controller.main;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fila.app.service.main.MainService;
import com.fila.app.domain.member.MemberVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fila.app.domain.eventProduct.EventproductVO;

@Controller
@RequestMapping("/main/*") // 호출 주소: /main/main.htm
public class MainController {

    @Autowired
    private MainService mainService;

    @Autowired
    private com.fila.app.mapper.tag.TagMapper tagMapper;
    
    @Autowired
    private com.fila.app.service.wishlist.WishListService wishListService;
    
    @Autowired
    private com.fila.app.service.admin.AdminStyleService adminStyleService;
    
    @Autowired
    private com.fila.app.service.search.SearchService searchService;

    @RequestMapping("main.htm")
    public String mainPage(
            @RequestParam(value = "searchItem", required = false) String searchItem,
            HttpSession session, 
            Model model) {

        // 1. [유지] 검색어 DB 저장 로직 (이건 서비스 기능이므로 유지)
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            searchService.saveKeyword(searchItem);
        }

        // 2. [수정] 서비스로부터 메인 컨텐츠 전용 데이터만 가져옴
        // (이미 HeaderPreparer가 공통 데이터를 처리하므로, 여기선 본문용만 쓰면 됩니다)
        Map<String, Object> mainData = mainService.getMainData(searchItem);

        // 3. [유지] 본문 전용 데이터 (배너/태그/스타일 - 모델 저장)
        model.addAttribute("activeTags", mainData.get("activeTags"));
        model.addAttribute("activeStyles", mainData.get("activeStyles"));
        model.addAttribute("bannerList", mainData.get("bannerList"));

        // 4. [유지] 로그인 사용자별 위시리스트 처리
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser != null) {
            Set<String> wishedSet = wishListService.getWishedSet(loginUser.getUserNumber());
            model.addAttribute("wishedSet", wishedSet);
        } else {
            model.addAttribute("wishedSet", Collections.emptySet());
        }

        return "main"; 
    }
    
    @RequestMapping(value = "mainGroupAjax.htm")
    public void mainGroupAjax(@RequestParam("tagId") int tagId, HttpServletResponse response) {
        try {
            System.out.println("🚀 [최후의 수단] 직접 Response 쓰기 - tagId: " + tagId);
            
            List<com.fila.app.domain.product.ProductsVO> list = tagMapper.selectProductsByTag(tagId);
            
            // 직접 JSON 문자열 변환
            ObjectMapper mapper = new ObjectMapper();
            String jsonString = mapper.writeValueAsString(list);
            
            // 스프링의 컨버터를 거치지 않고 서블릿 레벨에서 직접 응답
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonString);
            response.getWriter().flush();
            response.getWriter().close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @RequestMapping("styleDetail.htm")
    public String styleDetail(@RequestParam(value="id", required=false) String idParam, 
                              HttpServletRequest request, Model model) {
        
        System.out.println("🚩 [StyleDetail 요청] idParam: " + idParam);

        try {
            if (idParam != null && !idParam.isEmpty()) {
                int styleId = Integer.parseInt(idParam);
                
                // 1. 서비스 호출 (이제 getProductSizes 쿼리가 추가되어 에러가 안 날 겁니다)
                com.fila.app.domain.admin.StyleVO style = adminStyleService.getStyleFullDetail(styleId);
                
                if (style != null) {
                    // 2. 경로 가공 메서드 호출 (아래에 정의되어 있어야 함)
                    processAllPaths(style);
                    
                    model.addAttribute("style", style);

                    // Ajax(모달) 요청인 경우
                    String xRequestedWith = request.getHeader("X-Requested-With");
                    if ("XMLHttpRequest".equals(xRequestedWith)) {
                        return "/product/style_modal_content"; 
                    }
                    
                    // 일반 요청인 경우에도 상세 정보를 보여주기 위해 목록 로드
                    model.addAttribute("styleList", adminStyleService.getActiveStyleList());
                    return "style_detail";
                } else {
                    System.out.println("❌ 해당 스타일 데이터가 없습니다 (ID: " + styleId + ")");
                }
            }
            
            // ID가 없거나 데이터가 없는 경우 목록 리턴
            model.addAttribute("styleList", adminStyleService.getActiveStyleList());
            return "style_detail";

        } catch (Exception e) {
            System.err.println("🔥 상세페이지 로딩 중 서버 에러 발생!");
            e.printStackTrace(); // 여기서 MyBatis 에러가 찍힐 겁니다.
            return "redirect:/main/main.htm";
        }
    }

 // 이 메서드를 클래스 하단에 추가하세요
    private void processAllPaths(com.fila.app.domain.admin.StyleVO style) {
        if (style == null) return;

        // 1. 스타일 화보 이미지들 가공
        if (style.getImages() != null) {
            for (com.fila.app.domain.admin.StyleImageVO img : style.getImages()) {
                processImagePath(img);
            }
        }
        
        // 2. 스타일 매칭 상품 이미지들 가공
        if (style.getProducts() != null) {
            for (com.fila.app.domain.admin.StyleProductVO prod : style.getProducts()) {
                processProductImagePath(prod);
            }
        }
    }
    
    // 2. 화보 이미지 경로 가공 (기존 로직)
    private void processImagePath(com.fila.app.domain.admin.StyleImageVO img) {
        String path = img.getImageUrl();
        if (path == null) return;
        if (path.contains("path=")) path = path.split("path=")[1];
        path = path.replace("C:/fila_upload/", "").replace("C:\\fila_upload\\", "").replace("\\", "/");
        img.setImageUrl(path);
    }

    // 3. 상품 이미지 경로 가공 (기존 로직)
    private void processProductImagePath(com.fila.app.domain.admin.StyleProductVO prod) {
        String path = prod.getProductImage();
        if (path == null) return;
        if (path.contains("path=")) path = path.split("path=")[1];
        path = path.replace("C:/fila_upload/", "").replace("C:\\fila_upload\\", "").replace("\\", "/");
        prod.setProductImage(path);
    }
}