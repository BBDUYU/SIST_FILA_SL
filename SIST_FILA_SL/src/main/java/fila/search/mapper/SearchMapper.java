package fila.search.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SearchMapper {
    // 검색어 기록 (MERGE 문 실행)
    void upsertKeyword(String keyword);
    
    // 인기 검색어 상위 N개 조회
    ArrayList<fila.search.domain.SearchDTO> selectTopKeywords(int limit);
}