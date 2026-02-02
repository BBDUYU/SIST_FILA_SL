package com.fila.app.mapper.tag;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.fila.app.domain.categories.CategoriesVO;

@Mapper
public interface TagMapper {
    List<CategoriesVO> selectTagList();
    Integer getMaxTagId(); // 데이터가 없을 경우를 대비해 Integer 권장
    int insertTag(CategoriesVO vo);
}