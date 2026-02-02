package com.fila.app.mapper.search;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.fila.app.domain.search.SearchVO; // 기존 SearchDTO -> SearchVO

//@Mapper
public interface SearchMapper {

    void upsertKeyword(@Param("keyword") String keyword);

    List<SearchVO> selectTopKeywords(@Param("limit") int limit);
}