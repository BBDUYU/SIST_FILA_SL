package com.fila.app.controller.main;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fila.app.service.main.MainService;
import com.fila.app.service.mypage.WishListService;
import com.fila.app.domain.member.MemberVO;
import com.fila.app.domain.event.EventproductDTO;
import com.fila.app.domain.eventProduct.EventproductVO;

@Controller
@RequestMapping("/main/*") // 호출 주소: /main/main.htm
public class MainController {

    @Autowired
    private MainService mainService;

    @Autowired
    private WishListService wishListService;

    @RequestMapping("main.htm")
    public String mainPage(
            @RequestParam(value = "searchItem", required = false) String searchItem,
            HttpSession session, 
            Model model) {

        // 1. 서비스로부터 메인 통합 데이터 가져오기
        Map<String, Object> mainData = mainService.getMainData(searchItem);

        // 2. 공통 데이터 (헤더/검색어 - 세션 저장)
        session.setAttribute("categoryList", mainData.get("categoryList"));
        session.setAttribute("popularKeywords", mainData.get("popularKeywords"));
        session.setAttribute("recommendKeywords", mainData.get("recommendKeywords"));

        // 3. 본문 전용 데이터 (배너/태그/스타일 - 모델 저장)
        model.addAttribute("activeTags", mainData.get("activeTags"));
        model.addAttribute("activeStyles", mainData.get("activeStyles"));
        model.addAttribute("bannerList", mainData.get("bannerList"));

        // 4. 추천 상품 이미지 경로 가공 (비즈니스 로직)
        List<EventproductVO> recommendProducts = (List<EventproductVO>) mainData.get("recommendProducts");
        if (recommendProducts != null) {
            for (EventproductVO p : recommendProducts) {
                String img = p.getMainImageUrl();
                if (img != null && img.contains("path=")) {
                    p.setMainImageUrl(img.split("path=")[1].replace("\\", "/"));
                }
            }
        }
        model.addAttribute("recommendProducts", recommendProducts);

        // 5. 로그인 사용자별 위시리스트(찜) 정보 처리
        MemberVO loginUser = (MemberVO) session.getAttribute("auth");
        if (loginUser != null) {
            Set<String> wishedSet = wishListService.getWishedSet(loginUser.getUserNumber());
            model.addAttribute("wishedSet", wishedSet);
        } else {
            model.addAttribute("wishedSet", Collections.emptySet());
        }

        // 6. Tiles 설정 이름 리턴
        return "main"; 
    }
}