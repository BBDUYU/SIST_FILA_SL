package com.fila.app.service.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

// VO 경로들을 프로젝트 구조에 맞게 import 하세요.
import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.domain.eventProduct.EventproductVO;
import com.fila.app.domain.main.MainbannerVO;
import com.fila.app.mapper.admin.StyleMapper;
import com.fila.app.mapper.categories.CategoriesMapper;
import com.fila.app.mapper.eventProduct.EventProductMapper;
import com.fila.app.mapper.main.MainbannerMapper;
import com.fila.app.mapper.search.SearchMapper;
import com.fila.app.mapper.tag.TagMapper;
import com.fila.app.domain.admin.StyleVO;



@Service
public class MainServiceImpl implements MainService {

    @Autowired private CategoriesMapper categoriesMapper; // CategoriesDAO 대체 (카테고리 & 활성태그)
    @Autowired private SearchMapper searchMapper;         // SearchDAO 대체
    @Autowired private EventProductMapper epMapper;       // EventproductDAO 대체
    @Autowired private MainbannerMapper bannerMapper;     // MainbannerDAO 대체
    @Autowired private StyleMapper styleMapper;           // StyleDAO 대체

    @Override
    @Transactional
    public Map<String, Object> getMainData(String searchItem) {
        Map<String, Object> dataMap = new HashMap<>();

        // 1. 검색어 저장
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            searchMapper.upsertKeyword(searchItem.trim());
        }

        // 2. 카테고리 리스트 (categoriesMapper 사용)
        dataMap.put("categoryList", categoriesMapper.selectCategoryList());

        // 3. 활성 태그 리스트 (categoriesMapper 사용)
        dataMap.put("activeTags", categoriesMapper.selectActiveTagList());

        // 4. 인기 검색어 / 추천 키워드
        dataMap.put("popularKeywords", searchMapper.selectTopKeywords(8));
        dataMap.put("recommendKeywords", epMapper.selectActiveEventKeywords());

        // 5. 추천 상품 & 이미지 가공
        List<EventproductVO> recommendProducts = epMapper.selectRecommendProducts();
        if (recommendProducts != null) {
            recommendProducts.forEach(this::processImagePath);
        }
        dataMap.put("recommendProducts", recommendProducts);

        // 6. 메인 배너 & 정렬
        List<MainbannerVO> bannerList = bannerMapper.selectMainBannerList();
        if (bannerList != null) {
            bannerList.sort((a, b) -> {
                boolean aIsVideo = a.getImageUrl().toLowerCase().endsWith(".mp4");
                boolean bIsVideo = b.getImageUrl().toLowerCase().endsWith(".mp4");
                return Boolean.compare(aIsVideo, bIsVideo);
            });
        }
        dataMap.put("bannerList", bannerList);

        // 7. 활성 스타일
        dataMap.put("activeStyles", styleMapper.selectActiveStyleList());

        return dataMap;
    }

    // 이미지 경로 가공 공통 메서드
    private void processImagePath(EventproductVO p) {
        String img = p.getMainImageUrl();
        if (img != null && img.contains("path=")) {
            p.setMainImageUrl(img.split("path=")[1].replace("\\", "/"));
        }
    }

}