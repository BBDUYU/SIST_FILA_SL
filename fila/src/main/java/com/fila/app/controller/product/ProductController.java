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

    /**
     * 상품 목록 및 검색 처리 (*.htm)
     */
    @RequestMapping(value = "/list.htm", method = RequestMethod.GET)
    public String list(
            // String으로 들어오는 category 파라미터를 int로 자동 형변환합니다.
            // 만약 값이 없거나 숫자가 아니면 defaultValue인 0이 들어갑니다.
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
        } 
        // 2. 카테고리 로직 (이제 int category를 그대로 던지면 됩니다!)
        else {
            // 이제 타입이 int이므로 ProductService.getProductList(int)와 일치합니다.
            List<ProductsVO> productList = productService.getProductList(category);
            
            // 가져온 리스트를 model에 담아 JSP로 보냅니다.
            model.addAttribute("productList", productList);
        }

        // 3. 인기 검색어 세션 갱신 (헤더용)
        try {
            // MainService가 빈으로 등록되어 있어야 합니다.
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

        // servlet-context.xml의 ViewResolver에 의해 /view/product/list.jsp 등으로 연결
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