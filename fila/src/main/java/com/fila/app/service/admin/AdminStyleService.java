package com.fila.app.service.admin;

import java.util.List;
import com.fila.app.domain.admin.StyleVO;
import com.fila.app.domain.admin.StyleImageVO;
import com.fila.app.domain.admin.StyleProductVO;

public interface AdminStyleService {
    // 스타일 목록 및 상세 조회
    List<StyleVO> getStyleList();
    List<StyleVO> getActiveStyleList();
    StyleVO getStyleDetail(int styleId);
    StyleVO getStyleFullDetail(int styleId) throws Exception;
    
    // 이미지 및 매칭 상품 조회
    List<StyleImageVO> getStyleImages(int styleId);
    List<String> getMatchedProductIds(int styleId);
    
    // 스타일 등록 및 수정
    boolean registerStyle(StyleVO styleVo, List<StyleImageVO> imageList, List<StyleProductVO> productList);
    void updateStyleComplete(StyleVO styleVo, List<StyleImageVO> newImages, String[] productIds, boolean hasNewImages);
    
    // 상태 변경 (사용여부 토글)
    boolean updateStyleStatus(int id, int status);
    
    int registerStyleMaster(StyleVO styleVo);
}