package fila.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fila.search.domain.domain.SearchDTO;
import fila.search.mapper.SearchMapper;

@Service
public class MainService {

    @Autowired
    private SearchMapper searchMapper;

    // 다른 DAO들 (추후 Mapper로 전환 추천)
    @Autowired
    private CategoriesDAO cDao;
    @Autowired
    private EventproductDAO epDao;
    @Autowired
    private MainbannerDAO ebDao;
    @Autowired
    private StyleDAO styleDao;

    public Map<String, Object> getMainData(String searchItem) {
        Map<String, Object> dataMap = new HashMap<>();

        // 1. 검색어 저장 (MyBatis Mapper 호출)
        if (searchItem != null && !searchItem.trim().isEmpty()) {
            searchMapper.upsertKeyword(searchItem.trim());
        }

        // 2. 카테고리 & 인기 검색어 (상위 8개)
        dataMap.put("categoryList", cDao.selectCategoryList());
        dataMap.put("popularKeywords", searchMapper.selectTopKeywords(8));

        // 3. 추천 데이터 & 배너 로직 (기존 유지)
        dataMap.put("recommendKeywords", epDao.selectRecommendKeywords());
        dataMap.put("recommendProducts", epDao.selectRecommendProducts());
        
        ArrayList<MainbannerDTO> bannerList = ebDao.selectMainBannerList();
        if (bannerList != null) {
            bannerList.sort((a, b) -> {
                boolean aIsVideo = a.getImageUrl().toLowerCase().endsWith(".mp4");
                boolean bIsVideo = b.getImageUrl().toLowerCase().endsWith(".mp4");
                return (aIsVideo && !bIsVideo) ? 1 : (!aIsVideo && bIsVideo) ? -1 : 0;
            });
            dataMap.put("bannerList", bannerList);
        }

        dataMap.put("activeTags", cDao.selectActiveTagList());
        dataMap.put("activeStyles", styleDao.selectActiveStyleList());

        return dataMap;
    }
}