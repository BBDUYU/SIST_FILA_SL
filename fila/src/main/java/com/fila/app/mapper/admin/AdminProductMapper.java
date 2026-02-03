package com.fila.app.mapper.admin;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.fila.app.domain.admin.ProductVO;


public interface AdminProductMapper {
    /**
     * 관리자용 상품 리스트 조회 (재고 및 메인 이미지 포함)
     */
    List<ProductVO> selectProductList();
}