package com.fila.app.controller.main;

import java.util.List;
import java.util.Map;

import org.apache.tiles.AttributeContext;
import org.apache.tiles.preparer.ViewPreparer;
import org.apache.tiles.request.Request;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.service.categories.CategoriesService;

public class HeaderPreparer implements ViewPreparer {

    @Override
    public void execute(Request tilesRequest, AttributeContext attributeContext) {
        WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();
        CategoriesService categoriesService = context.getBean(CategoriesService.class);

        List<CategoriesVO> list = categoriesService.getCategoryList();

        // 1. Tiles 전용 Attribute 주입 (필요시 유지)
        attributeContext.putAttribute("list", new org.apache.tiles.Attribute(list), true);

        // 2. 핵심: JSP에서 바로 ${list}로 쓰려면 Request Scope에 담아야 함
        // Tiles Request를 서블릿 리퀘스트로 변환하여 주입
        Map<String, Object> requestScope = tilesRequest.getContext("request");
        requestScope.put("list", list);

        System.out.println(">>> [Tiles Preparer] 카테고리 주입 완료 (Size: " + list.size() + ")");
    }
}