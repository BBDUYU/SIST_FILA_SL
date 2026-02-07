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

    // 스프링 3버전에서는 의존성 주입을 위해 @Autowired를 명시적으로 사용하는 것이 가장 안전합니다.
    @Autowired
    private ProductService productService;
    
    @Autowired
    private MainService mainService;
    
    @Autowired
    private WishListService wishListService;

    @Autowired // [추가] 검색어 저장을 위해 주입
    private com.fila.app.service.search.SearchService searchService;
    
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
        	searchService.saveKeyword(searchItem);
            List<ProductsVO> productList = productService.searchProducts(searchItem);
            model.addAttribute("productList", productList);
            model.addAttribute("mainTitle", "SEARCH");
            model.addAttribute("subTitle", "'" + searchItem + "' 검색 결과");
        } 
        else {
            List<ProductsVO> productList = productService.getProductList(category);
            
            model.addAttribute("productList", productList);
        }


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
    public String detail(@RequestParam("product_id") String productId, Model model) {
        Map<String, Object> map = productService.getProductDetail(productId);
        model.addAttribute("map", map);
        return "detail";
    }
}