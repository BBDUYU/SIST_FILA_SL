package fila.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fila.categories.domain.CategoriesDTO;
import fila.categories.service.CategoryService; 
import fila.mapper.SearchMapper; 
import fila.search.domain.SearchDTO;    
import fila.main.MainbannerDTO;          

@Service
public class MainService {

    @Autowired
    private SearchMapper searchMapper;

    @Autowired
    private CategoryService categoryService; 

    // 아직 Mapper로 전환 전인 나머지 DAO들 (순차적으로 변경 추천)
    @Autowired
    private EventproductDAO epDao;
    
    @Autowired
    private MainbannerDAO ebDao;
    
    @Autowired
    private StyleDAO styleDao;

    public Map<String, Object> getMainData(String searchItem) {
        Map<String, Object> dataMap = new HashMap<>();

        // 1. 검색어 저장 및 기록 (MyBatis Mapper 직접 호출)
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            searchMapper.upsertKeyword(searchItem.trim());
        }

        // 2. 카테고리 데이터 (CategoryService 활용)
        // 기존: cDao.selectCategoryList() -> 변경: categoryService.getHeaderCategories()
        dataMap.put("categoryList", categoryService.getHeaderCategories());

        // 3. 인기 검색어 상위 8개 (SearchMapper 활용)
        dataMap.put("popularKeywords", searchMapper.selectTopKeywords(8));

        // 4. 추천 키워드 및 상품 (기존 DAO 유지)
        dataMap.put("recommendKeywords", epDao.selectRecommendKeywords());
        dataMap.put("recommendProducts", epDao.selectRecommendProducts());

        // 5. 메인 배너 로직 (기존 유지)
        ArrayList<MainbannerDTO> bannerList = ebDao.selectMainBannerList();
        if (bannerList != null) {
            bannerList.sort((a, b) -> {
                boolean aIsVideo = a.getImageUrl().toLowerCase().endsWith(".mp4");
                boolean bIsVideo = b.getImageUrl().toLowerCase().endsWith(".mp4");
                return (aIsVideo && !bIsVideo) ? 1 : (!aIsVideo && bIsVideo) ? -1 : 0;
            });
            dataMap.put("bannerList", bannerList);
        }

        // 6. 활성화된 태그 및 스타일 (Service 활용)
        // 기존: cDao.selectActiveTagList() -> 변경: categoryService.getActiveTags()
        dataMap.put("activeTags", categoryService.getActiveTags());
        dataMap.put("activeStyles", styleDao.selectActiveStyleList());

        return dataMap;
    }
}