package com.fila.app.service.admin;

import java.util.List;

import com.fila.app.domain.eventProduct.EventproductVO;

public interface AdminEventProductService {

    List<EventproductVO> getRecommendKeywords();

 
    List<EventproductVO> getRecommendProducts();
}