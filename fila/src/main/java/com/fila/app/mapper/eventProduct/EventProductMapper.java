package com.fila.app.mapper.eventProduct;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;

import com.fila.app.domain.eventProduct.EventproductVO;

@Mapper
public interface EventProductMapper {
    // 1. 활성화된 이벤트 목록 (키워드용)
    List<EventproductVO> selectActiveEventKeywords();
    
    // 2. 추천 상품 목록 (키워드용 상위 5개)
    List<EventproductVO> selectRecommendProductKeywords(); 
    
    // 3. 추천 상품 리스트 (메인 진열용 12개)
    List<EventproductVO> selectRecommendProducts();
}