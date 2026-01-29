package command;

import java.util.List;
import java.util.Map;
import java.util.Set; // wishedSet 타입(Set)

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import event_product.EventproductDTO;
import member.MemberDTO; // 세션 auth 꺼내서 유저번호 쓰려고
import mypage.service.WishListService;
import service.MainService;

public class MainHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 검색 파라미터 받기
        String searchItem = request.getParameter("searchItem");
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            search.SearchService.getInstance().recordSearchKeyword(searchItem);
        }
        
        // 2. 서비스를 통해 데이터 뭉치 가져오기
        MainService service = MainService.getInstance();
        Map<String, Object> mainData = service.getMainData(searchItem);
        
        request.setAttribute("activeTags", mainData.get("activeTags"));
        request.setAttribute("activeStyles", mainData.get("activeStyles"));
        
        // 3. View(JSP)에 전달할 데이터 세팅
        // 카테고리는 헤더에서 공통으로 쓰므로 세션에 저장 (기존 서블릿 로직 유지)
        request.getSession().setAttribute("list", mainData.get("categoryList"));
        request.setAttribute("activeTags", mainData.get("activeTags"));
        
        // 나머지 데이터는 request에 저장
        request.getSession().setAttribute("popularKeywords", mainData.get("popularKeywords"));
        request.getSession().setAttribute("recommendKeywords", mainData.get("recommendKeywords"));
        request.setAttribute("bannerList", mainData.get("bannerList"));

        List<EventproductDTO> recommendProducts = (List<EventproductDTO>) mainData.get("recommendProducts");
        
        if (recommendProducts != null) {
            for (EventproductDTO p : recommendProducts) {
                String img = p.getMainImageUrl(); // DTO에 해당 필드가 있다면
                if (img != null && img.contains("path=")) {
                    p.setMainImageUrl(img.split("path=")[1].replace("\\", "/"));
                }
            }
        }
        
        request.getSession().setAttribute("recommendProducts", recommendProducts);
        
        // 4. 로그인 유저 기준 wishedSet 내려주기 (메인 상품 카드 하트 표시용)
        MemberDTO loginUser = (MemberDTO) request.getSession().getAttribute("auth");
        if (loginUser != null) {
            // 로그인 유저가 찜한 product_id 목록(Set<String>)을 가져와서 JSP로 내려줌
            Set<String> wishedSet = WishListService.getInstance()
                    .getWishedSet(loginUser.getUserNumber());
            request.setAttribute("wishedSet", wishedSet);
        } else {
            // 비로그인: 비어있는 Set 내려줌 (JS에서 전부 OFF 처리)
            request.setAttribute("wishedSet", java.util.Collections.emptySet());
        }
        
        // 5. 이동할 JSP 경로 리턴
        return "/view/main.jsp";
    }
}