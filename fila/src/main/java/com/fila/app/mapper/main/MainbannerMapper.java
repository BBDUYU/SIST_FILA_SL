package com.fila.app.mapper.main;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.fila.app.domain.main.MainbannerVO;

public interface MainbannerMapper {
    
    /**
     * 메인 상단 배너 리스트 조회
     * @return 활성화된 배너 리스트
     */
    List<MainbannerVO> selectMainBannerList();
    
}