package fila.search.service;

import java.util.ArrayList;
import fila.search.domain.SearchDTO;

public interface SearchService {
    // 검색어 기록
    void recordSearchKeyword(String keyword);
    
    // 인기 검색어 조회
    ArrayList<SearchDTO> getPopularKeywords(int limit);
}