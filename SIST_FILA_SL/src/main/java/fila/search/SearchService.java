package fila.search;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SearchService {

    @Autowired
    private SearchDAO searchDAO;

    /**
     * 검색어 기록
     */
    public void recordSearchKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return;
        }

        try {
            searchDAO.upsertKeyword(keyword.trim());
        } catch (Exception e) {
            throw new RuntimeException("검색어 기록 중 오류 발생", e);
        }
    }

    /**
     * 인기 검색어 조회
     */
    public ArrayList<SearchDTO> getPopularKeywords(int limit) {
        try {
            return searchDAO.selectTopKeywords(limit);
        } catch (Exception e) {
            throw new RuntimeException("인기 검색어 조회 중 오류 발생", e);
        }
    }
}
