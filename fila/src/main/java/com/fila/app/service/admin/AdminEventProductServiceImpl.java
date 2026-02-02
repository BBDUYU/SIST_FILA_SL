package com.fila.app.service.admin;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fila.app.domain.eventProduct.EventproductVO;
import com.fila.app.mapper.eventProduct.EventProductMapper;

@Service
public class AdminEventProductServiceImpl implements AdminEventProductService {

    @Autowired
    private EventProductMapper eventProductMapper;

    // 추천 키워드 통합 로직
    public List<EventproductVO> getRecommendKeywords() {
        List<EventproductVO> combinedList = new ArrayList<>();
        
        // 1. 이벤트 명칭들 추가
        combinedList.addAll(eventProductMapper.selectActiveEventKeywords());
        // 2. 상품 명칭들 추가
        combinedList.addAll(eventProductMapper.selectRecommendProductKeywords());
        
        return combinedList;
    }

    // 추천 상품 로직 (이미지 경로 정제 포함)
    public List<EventproductVO> getRecommendProducts() {
        List<EventproductVO> list = eventProductMapper.selectRecommendProducts();
        
        for (EventproductVO vo : list) {
            String path = vo.getMainImageUrl();
            if (path != null) {
                // path= 문구 제거 및 역슬래시 변환
                if (path.contains("path=")) {
                    path = path.split("path=")[1];
                }
                vo.setMainImageUrl(path.replace("\\", "/"));
            }
        }
        return list;
    }
}