package com.fila.app.service.main;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

// 기존 DTO들을 VO로 이름 변경하여 사용한다고 가정합니다.
import com.fila.app.domain.main.CategoriesVO;
import com.fila.app.domain.main.MainbannerVO;
import com.fila.app.domain.event.EventproductVO;
import com.fila.app.persistence.main.CategoriesDAO;
import com.fila.app.persistence.main.MainbannerDAO;
import com.fila.app.persistence.main.SearchDAO;
import com.fila.app.persistence.event.EventproductDAO;
import com.fila.app.persistence.admin.StyleDAO;

@Service
public class MainServiceImpl implements MainService {

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

    @Override
    @Transactional(readOnly = true) // 읽기 전용 트랜잭션 최적화
    public Map<String, Object> getMainData(String searchItem) {
        Map<String, Object> dataMap = new HashMap<>();

        try {
            // 1. 검색어 저장 (검색창 입력 시)
            if (searchItem != null && !searchItem.trim().isEmpty()) {
                sDao.upsertKeyword(searchItem.trim());
            }

            // 2. 기본 데이터 로드 (Spring MyBatis 구조이므로 Connection 전달 불필요)
            dataMap.put("categoryList", cDao.selectCategoryList());
            dataMap.put("popularKeywords", sDao.selectTopKeywords(8));
            dataMap.put("recommendKeywords", epDao.selectRecommendKeywords());
            dataMap.put("activeTags", cDao.selectActiveTagList());
            dataMap.put("activeStyles", styleDao.selectActiveStyleList());

            // 3. 메인 배너 조회 및 비디오 정렬 로직
            List<MainbannerVO> bannerList = ebDao.selectMainBannerList();
            if (bannerList != null) {
                bannerList.sort((a, b) -> {
                    boolean aIsVideo = a.getImageUrl().toLowerCase().endsWith(".mp4");
                    boolean bIsVideo = b.getImageUrl().toLowerCase().endsWith(".mp4");
                    return (aIsVideo && !bIsVideo) ? 1 : (!aIsVideo && bIsVideo) ? -1 : 0;
                });
            }
            dataMap.put("bannerList", bannerList);

            // 4. [비즈니스 로직 고도화] 추천 상품 이미지 경로 가공
            // 자소서에 쓴 '결합도를 낮추는 경험'의 핵심 부분입니다.
            List<EventproductVO> recommendProducts = epDao.selectRecommendProducts();
            if (recommendProducts != null) {
                for (EventproductVO p : recommendProducts) {
                    processProductImage(p);
                }
            }
            dataMap.put("recommendProducts", recommendProducts);

            return dataMap;

        } catch (Exception e) {
            throw new RuntimeException("메인 데이터 가공 중 오류 발생", e);
        }
    }

    // 이미지 경로 가공 공통 메서드 (내부 로직)
    private void processProductImage(EventproductVO p) {
        String img = p.getMainImageUrl();
        if (img != null && img.contains("path=")) {
            p.setMainImageUrl(img.split("path=")[1].replace("\\", "/"));
        }
    }
}