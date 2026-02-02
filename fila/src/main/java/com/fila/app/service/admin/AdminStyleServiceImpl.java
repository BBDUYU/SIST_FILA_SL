package com.fila.app.service.admin;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.admin.StyleVO;
import com.fila.app.domain.admin.StyleImageVO;
import com.fila.app.domain.admin.StyleProductVO;
import com.fila.app.mapper.admin.StyleMapper;

@Service
public class AdminStyleServiceImpl implements AdminStyleService {

    @Autowired
    private StyleMapper styleMapper;

    @Override
    @Transactional(readOnly = true)
    public List<StyleVO> getActiveStyleList() {
        List<StyleVO> styleList = styleMapper.selectActiveStyleList();
        if (styleList != null) {
            for (StyleVO style : styleList) {
                style.setImages(styleMapper.selectStyleImages(style.getStyle_id()));
            }
        }
        return styleList;
    }

    @Override
    @Transactional
    public boolean registerStyle(StyleVO styleVo, List<StyleImageVO> imageList, List<StyleProductVO> productList) {
        // 1. 스타일 마스터 등록 (selectKey 등으로 생성된 ID가 VO에 담김)
        int result = styleMapper.insertStyle(styleVo);
        int styleId = styleVo.getStyle_id();

        if (result > 0) {
            // 2. 이미지 정보 저장
            for (StyleImageVO img : imageList) {
                img.setStyle_id(styleId);
                styleMapper.insertStyleImage(img);
            }
            // 3. 연관 상품 저장
            for (StyleProductVO prod : productList) {
                prod.setStyle_id(styleId);
                styleMapper.insertStyleProduct(prod);
            }
            return true;
        }
        return false;
    }

    @Override
    @Transactional
    public void updateStyleComplete(StyleVO styleVo, List<StyleImageVO> newImages, String[] productIds, boolean hasNewImages) {
        int styleId = styleVo.getStyle_id();
        
        // (1) 마스터 정보 수정
        styleMapper.updateStyle(styleVo);

        // (2) 이미지 업데이트 (새 파일이 있는 경우만 기존 삭제 후 재등록)
        if (hasNewImages) {
            styleMapper.deleteStyleImages(styleId);
            for (StyleImageVO img : newImages) {
                img.setStyle_id(styleId);
                styleMapper.insertStyleImage(img);
            }
        }

        // (3) 상품 매칭 업데이트 (기존 삭제 후 재등록)
        styleMapper.deleteStyleProducts(styleId);
        if (productIds != null) {
            for (int i = 0; i < productIds.length; i++) {
                StyleProductVO spVo = new StyleProductVO();
                spVo.setStyle_id(styleId);
                spVo.setProduct_id(productIds[i]);
                spVo.setSort_order(i + 1);
                styleMapper.insertStyleProduct(spVo);
            }
        }
    }

    @Override
    @Transactional(readOnly = true)
    public StyleVO getStyleFullDetail(int styleId) throws Exception {
        StyleVO style = styleMapper.selectStyleDetail(styleId);
        if (style != null) {
            style.setImages(styleMapper.selectStyleImages(styleId));
            List<StyleProductVO> products = styleMapper.selectStyleProductDetails(styleId);
            
            // 각 상품별 사이즈 옵션 로드
            for (StyleProductVO product : products) {
                product.setSizeOptions(styleMapper.getProductSizes(product.getProduct_id()));
            }
            style.setProducts(products);
        }
        return style;
    }

    // 단순 위임 메서드들
    @Override public List<StyleVO> getStyleList() { return styleMapper.selectStyleList(); }
    @Override public StyleVO getStyleDetail(int id) { return styleMapper.selectStyleDetail(id); }
    @Override public List<StyleImageVO> getStyleImages(int id) { return styleMapper.selectStyleImages(id); }
    @Override public List<String> getMatchedProductIds(int id) { return styleMapper.selectMatchedProductIds(id); }
    @Override @Transactional public boolean updateStyleStatus(int id, int status) { return styleMapper.updateStyleStatus(id, status) > 0; }
}