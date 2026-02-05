package com.fila.app.mapper.admin;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.fila.app.domain.admin.*; // VO 패키지 경로에 맞게 수정


public interface StyleMapper {
    // 조회 관련
    List<StyleVO> selectStyleList();
    StyleVO selectStyleDetail(int styleId);
    List<StyleImageVO> selectStyleImages(int styleId);
    List<String> selectMatchedProductIds(int styleId);
    List<StyleVO> selectActiveStyleList();
    List<StyleProductVO> selectStyleProductDetails(int styleId);
    List<String> getProductSizes(String productId);

    // 등록/수정/삭제 관련
    int insertStyle(StyleVO vo); // insert 후 vo의 style_id에 시퀀스 값이 채워짐
    int insertStyleImage(StyleImageVO imgVo);
    int insertStyleProduct(StyleProductVO prodVo);
    int updateStyle(StyleVO vo);
    int updateStyleStatus(@Param("id") int id, @Param("status") int status);
    void deleteStyleImages(int styleId);
    void deleteStyleProducts(int styleId);
    
}