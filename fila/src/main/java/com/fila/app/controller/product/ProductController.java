package com.fila.app.controller.product;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.product.ProductsVO;
import com.fila.app.service.main.MainService;
import com.fila.app.service.product.ProductService;
import com.fila.app.service.wishlist.WishListService;


@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;
    
    @Autowired
    private MainService mainService;
    
    @Autowired
    private WishListService wishListService;

    /**
     * 상품 목록 및 검색 처리 (*.htm)
     */
    @RequestMapping(value = "/list.htm", method = RequestMethod.GET)
    public String list(
            @RequestParam(value = "category", required = false, defaultValue = "0") int category, 
            @RequestParam(value = "searchItem", required = false) String searchItem,
            HttpServletRequest request,
            HttpSession session,
            Model model) throws Exception {

        // 1. 검색 로직
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            List<ProductsVO> productList = productService.searchProducts(searchItem);
            model.addAttribute("productList", productList);
            model.addAttribute("mainTitle", "SEARCH");
            model.addAttribute("subTitle", "'" + searchItem + "' 검색 결과");
            
             Map<String, Object> sidebarData = productService.getSidebarAndTitles(0);
             if (sidebarData != null) model.addAllAttributes(sidebarData);
        } 
        // 2. 카테고리 로직 (일반 목록)
        else {
            List<ProductsVO> productList = productService.getProductList(category);
            model.addAttribute("productList", productList);
            
            Map<String, Object> sidebarData = productService.getSidebarAndTitles(category);
            if (sidebarData != null) {
                model.addAllAttributes(sidebarData);
            }
        }

        model.addAttribute("currentCateId", category);

        // 3. 인기 검색어 세션 갱신
        try {
            Map<String, Object> mainData = mainService.getMainData(null); 
            session.setAttribute("popularKeywords", mainData.get("popularKeywords"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 4. 찜 목록(WishList) 처리
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser != null) {
            Set<String> wishedSet = wishListService.getWishedSet(loginUser.getUserNumber());
            model.addAttribute("wishedSet", wishedSet);
        } else {
            model.addAttribute("wishedSet", Collections.emptySet());
        }

        return "list"; 
    }

    /**
     * 상품 상세 페이지 (*.htm)
     */
    @RequestMapping(value = "/detail.htm", method = RequestMethod.GET)
    public String detail(@RequestParam("productId") String productId, Model model) {
        Map<String, Object> map = productService.getProductDetail(productId);
        
        if (map != null) {
            // map에 담긴 각각의 데이터를 꺼내서 model에 개별적으로 등록합니다.
            model.addAllAttributes(map); 
            
            // 만약 위 코드가 작동하지 않는 버전이라면 아래처럼 직접 넣어주세요.
            /*
            model.addAttribute("product", map.get("product"));
            model.addAttribute("mainImages", map.get("mainImages"));
            model.addAttribute("modelImages", map.get("modelImages"));
            model.addAttribute("detailImages", map.get("detailImages"));
            model.addAttribute("sizeOptions", map.get("sizeOptions"));
            model.addAttribute("relatedList", map.get("relatedList"));
            model.addAttribute("styleTag", map.get("styleTag"));
            */
            
            // 추가 계산이 필요한 값들 (JSP에서 사용 중인 변수들)
            ProductsVO product = (ProductsVO) map.get("product");
            double finalPrice = product.getPrice() * (100 - product.getDiscountRate()) / 100.0;
            model.addAttribute("finalPrice", (int)finalPrice);
        }
        
        return "product_detail";
    }
}