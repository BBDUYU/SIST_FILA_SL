package fila.search.service;

import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fila.mapper.SearchMapper;
import fila.search.domain.SearchDTO;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class SearchServiceImpl implements SearchService {

    @Autowired
    private SearchMapper searchMapper; // DAO 대신 Mapper 인터페이스 사용

    @Override
    public void recordSearchKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return;
        }

        try {
            // MyBatis Mapper 호출
            searchMapper.upsertKeyword(keyword.trim());
            log.info("검색어 기록 성공: " + keyword);
        } catch (Exception e) {
            log.error("검색어 기록 중 오류 발생", e);
            throw new RuntimeException("검색어 기록 중 오류 발생", e);
        }
    }

    @Override
    public ArrayList<SearchDTO> getPopularKeywords(int limit) {
        try {
            return searchMapper.selectTopKeywords(limit);
        } catch (Exception e) {
            log.error("인기 검색어 조회 중 오류 발생", e);
            throw new RuntimeException("인기 검색어 조회 중 오류 발생", e);
        }
    }
}