package com.fila.app.controller.main;

import java.util.List;
import java.util.Map;

import org.apache.tiles.AttributeContext;
import org.apache.tiles.preparer.ViewPreparer;
import org.apache.tiles.request.Request;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import com.fila.app.service.main.MainService;
import com.fila.app.domain.eventProduct.EventproductVO;

public class HeaderPreparer implements ViewPreparer {

    @Override
    public void execute(Request tilesRequest, AttributeContext attributeContext) {
        WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();
        
        // 1. 필요한 서비스들 가져오기
        MainService mainService = context.getBean(MainService.class);

        // 2. 통합 데이터 가져오기 (카테고리, 인기검색어, 추천상품 등 포함)
        Map<String, Object> mainData = mainService.getMainData(null);

        // 3. 추천 상품 이미지 경로 가공 (Controller에 있던 로직을 여기로 이동)
        List<EventproductVO> recommendProducts = (List<EventproductVO>) mainData.get("recommendProducts");
        if (recommendProducts != null) {
            for (EventproductVO p : recommendProducts) {
                String img = p.getMainImageUrl();
                if (img != null && img.contains("path=")) {
                    p.setMainImageUrl(img.split("path=")[1].replace("\\", "/"));
                }
            }
        }

        // 4. Request Scope에 데이터 주입 (JSP에서 쓸 이름들)
        Map<String, Object> requestScope = tilesRequest.getContext("request");
        
        requestScope.put("list", mainData.get("categoryList")); // 카테고리
        requestScope.put("popularKeywords", mainData.get("popularKeywords")); // 인기검색어
        requestScope.put("recommendKeywords", mainData.get("recommendKeywords")); // 추천검색어
        requestScope.put("recommendProducts", recommendProducts); // 추천상품 (가공완료)

        System.out.println(">>> [Tiles Preparer] 헤더 통합 데이터 주입 완료");
    }
}