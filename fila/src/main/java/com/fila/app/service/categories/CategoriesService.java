package com.fila.app.service.categories;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.domain.product.ProductsVO;

public interface CategoriesService {
    // JSP 헤더에 뿌려줄 전체 카테고리 목록 가져오기
    List<CategoriesVO> getCategoryList();
}
