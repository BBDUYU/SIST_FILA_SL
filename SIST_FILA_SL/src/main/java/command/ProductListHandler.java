package command;

import java.util.List;
import java.util.Map;
import java.util.Set; // wishedSet(Set<String>)

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.MemberDTO; // 세션 auth에서 로그인 유저 꺼내려고
import mypage.WishListService; // 유저별 찜 목록 조회 서비스
import products.ProductsDTO;
import products.service.ProductService;
import service.MainService;

public class ProductListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // 1. 서비스 객체 준비
        ProductService productService = ProductService.getInstance();
        
        // 2. 검색어 파라미터 확인
        String searchItem = request.getParameter("searchItem");
        
        // 3. 비즈니스 로직 수행
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            // [A] 검색어가 있는 경우: 검색 전용 메서드만 실행
            List<ProductsDTO> productList = productService.searchProducts(searchItem);
            request.setAttribute("productList", productList);
            
            // 검색 결과 페이지를 위한 제목 설정
            request.setAttribute("mainTitle", "SEARCH");
            request.setAttribute("subTitle", "'" + searchItem + "' 검색 결과");
        } else {
            // [B] 검색어가 없는 경우: 기존 카테고리/전체보기 로직 수행
            // 이 메서드 내부에서 request.setAttribute("productList", ...) 등을 처리함
            productService.getProductList(request);
        }

        // 4. 인기 검색어 세션 갱신 (헤더용)
        try {
            Map<String, Object> mainData = MainService.getInstance().getMainData(null); 
            request.getSession().setAttribute("popularKeywords", mainData.get("popularKeywords"));
        } catch (Exception e) {
            // 메인 데이터 조회 실패 시 로그만 남기고 중단되지 않도록 처리
            e.printStackTrace();
        }
        
        // 5. 로그인 유저 기준 wishedSet 내려주기 (리스트 상품 카드 하트 표시용)
        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser != null) {
            // 로그인 유저가 찜한 product_id 목록(Set<String>)을 가져와서 JSP로 내려줌
            Set<String> wishedSet = WishListService.getInstance()
                    .getWishedSet(loginUser.getUserNumber());
            request.setAttribute("wishedSet", wishedSet);
        } else {
            // 비로그인: 비어있는 Set 내려줌 (JSP/JS에서 전부 OFF 처리)
            request.setAttribute("wishedSet", java.util.Collections.emptySet());
        }
        
        // 6. 뷰 페이지(JSP) 경로 리턴 (경로가 /view/product/ 인지 /product/ 인지 다시 확인!)
        return "/view/product/list.jsp";
    }
}