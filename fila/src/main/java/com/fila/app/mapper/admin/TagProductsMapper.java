package com.fila.app.mapper.admin;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.admin.ProductVO;



public interface TagProductsMapper {
    /**
     * 특정 태그(CategoryId)에 속한 상품 목록 조회
     */
    List<ProductVO> selectProductsByTag(@Param("tagId") int tagId);
}