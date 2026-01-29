package fila.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fila.admin.domain.StyleDTO;
import fila.admin.persistence.StyleDAO;
import fila.categories.CategoriesDAO;
import fila.categories.CategoriesDTO;
import fila.event_product.EventproductDAO;
import fila.event_product.EventproductDTO;
import fila.main.MainbannerDAO;
import fila.main.MainbannerDTO;
import fila.search.SearchDAO;
import fila.search.SearchDTO;

@Service
public class MainService {

    @Autowired
    private CategoriesDAO cDao;

    @Autowired
    private SearchDAO sDao;

    @Autowired
    private EventproductDAO epDao;

    @Autowired
    private MainbannerDAO ebDao;

    @Autowired
    private StyleDAO styleDao;

    public Map<String, Object> getMainData(String searchItem) {
        Map<String, Object> dataMap = new HashMap<>();

        // 1. 검색어 저장
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            sDao.upsertKeyword(searchItem.trim());
        }

        // 2. 카테고리
        ArrayList<CategoriesDTO> categoryList = cDao.selectCategoryList();
        dataMap.put("categoryList", categoryList);

        // 3. 인기 검색어
        ArrayList<SearchDTO> popularKeywords = sDao.selectTopKeywords(8);
        dataMap.put("popularKeywords", popularKeywords);

        // 4. 추천 키워드
        ArrayList<EventproductDTO> recommendKeywords = epDao.selectRecommendKeywords();
        dataMap.put("recommendKeywords", recommendKeywords);

        // 5. 추천 상품
        ArrayList<EventproductDTO> recommendProducts = epDao.selectRecommendProducts();
        dataMap.put("recommendProducts", recommendProducts);

        // 6. 메인 배너
        ArrayList<MainbannerDTO> bannerList = ebDao.selectMainBannerList();
        if (bannerList != null) {
            bannerList.sort((a, b) -> {
                boolean aIsVideo = a.getImageUrl().toLowerCase().endsWith(".mp4");
                boolean bIsVideo = b.getImageUrl().toLowerCase().endsWith(".mp4");
                return (aIsVideo && !bIsVideo) ? 1 : (!aIsVideo && bIsVideo) ? -1 : 0;
            });
        }
        dataMap.put("bannerList", bannerList);

        dataMap.put("activeTags", cDao.selectActiveTagList());
        dataMap.put("activeStyles", styleDao.selectActiveStyleList());

        return dataMap;
    }
}
