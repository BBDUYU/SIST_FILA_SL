package fila.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fila.admin.domain.StyleDTO;
import fila.admin.persistence.StyleDAO;
import fila.categories.CategoriesDAO;
import fila.categories.CategoriesDTO;
import fila.com.util.ConnectionProvider;
import fila.com.util.JdbcUtil;
import fila.event_product.EventproductDAO;
import fila.event_product.EventproductDTO;
import fila.main.MainbannerDAO;
import fila.main.MainbannerDTO;
import fila.search.SearchDAO;
import fila.search.SearchDTO;

public class MainService {
    private MainService() {}
    private static MainService instance = new MainService();
    public static MainService getInstance() { return instance; }

    public Map<String, Object> getMainData(String searchItem) {
        Connection conn = null;
        Map<String, Object> dataMap = new HashMap<>();
        
        try {
            conn = ConnectionProvider.getConnection();
            
            // DAO 인스턴스 준비
            CategoriesDAO cDao = CategoriesDAO.getInstance();
            SearchDAO sDao = SearchDAO.getInstance();
            EventproductDAO epDao = EventproductDAO.getInstance();
            MainbannerDAO ebDao = MainbannerDAO.getInstance();
            StyleDAO styleDao = StyleDAO.getInstance();
            
            // 1. 검색어 저장 (검색창 입력 시)
            if (searchItem != null && !searchItem.trim().isEmpty()) {
                sDao.upsertKeyword(conn, searchItem.trim());
                conn.commit();
            }

            // 2. 카테고리 리스트 조회
            ArrayList<CategoriesDTO> categoryList = cDao.selectCategoryList(conn);
            dataMap.put("categoryList", categoryList);

            // 3. 인기 검색어 조회 (TOP 8)
            ArrayList<SearchDTO> popularKeywords = sDao.selectTopKeywords(conn, 8);
            dataMap.put("popularKeywords", popularKeywords);

            // 4. 추천 키워드 (이벤트+상품) 조회
            ArrayList<EventproductDTO> recommendKeywords = epDao.selectRecommendKeywords(conn);
            dataMap.put("recommendKeywords", recommendKeywords);

            // 5. 추천 상품 (슬라이더용 12개) 조회
            ArrayList<EventproductDTO> recommendProducts = epDao.selectRecommendProducts(conn);
            dataMap.put("recommendProducts", recommendProducts);

            // 6. 메인 배너 조회 및 정렬 (비디오를 뒤로)
            ArrayList<MainbannerDTO> bannerList = ebDao.selectMainBannerList(conn);
            if (bannerList != null) {
                bannerList.sort((a, b) -> {
                    boolean aIsVideo = a.getImageUrl().toLowerCase().endsWith(".mp4");
                    boolean bIsVideo = b.getImageUrl().toLowerCase().endsWith(".mp4");
                    return (aIsVideo && !bIsVideo) ? 1 : (!aIsVideo && bIsVideo) ? -1 : 0;
                });
            }
            dataMap.put("bannerList", bannerList);

            ArrayList<CategoriesDTO> activeTags = cDao.selectActiveTagList(conn);
            dataMap.put("activeTags", activeTags);
            
            List<StyleDTO> activeStyles = styleDao.selectActiveStyleList(conn);
            dataMap.put("activeStyles", activeStyles);
            
            return dataMap;

        } catch (Exception e) {
            throw new RuntimeException("메인 데이터 로드 실패", e);
        } finally {
            JdbcUtil.close(conn);
        }
    }
}