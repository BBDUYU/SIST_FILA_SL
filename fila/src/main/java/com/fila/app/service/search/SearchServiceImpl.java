package com.fila.app.service.search;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.fila.app.domain.search.SearchVO;
import com.fila.app.mapper.search.SearchMapper;

@Service
public class SearchServiceImpl implements SearchService {

    @Autowired
    private SearchMapper searchMapper;

    @Override
    @Transactional
    public void saveKeyword(String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            searchMapper.upsertKeyword(keyword.trim());
        }
    }

    @Override
    public List<SearchVO> getPopularKeywords(int limit) {
        return searchMapper.selectTopKeywords(limit);
    }
}