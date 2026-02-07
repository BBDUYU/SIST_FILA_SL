package com.fila.app.service.search;

import java.util.List;
import com.fila.app.domain.search.SearchVO;

public interface SearchService {
    void saveKeyword(String keyword);
    
    List<SearchVO> getPopularKeywords(int limit);
}