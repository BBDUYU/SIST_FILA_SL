package com.fila.app.service.categories;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.mapper.categories.CategoriesMapper;

@Service
public class CategoriesServiceImpl implements CategoriesService {

    @Autowired
    private CategoriesMapper categoriesMapper; // MyBatis 매퍼 주입

    @Override
    public List<CategoriesVO> getCategoryList() {
        // DB에서 전체 카테고리 리스트 조회
        return categoriesMapper.selectCategoryList();
    }
}
