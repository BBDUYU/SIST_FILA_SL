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
                style.setImages(styleMapper.selectStyleImages(style.getStyleId()));
            }
        }
        return styleList;
    }

    @Override
    @Transactional
    public boolean registerStyle(StyleVO styleVo, List<StyleImageVO> imageList, List<StyleProductVO> productList) {

        if (styleVo.getStyleId() == 0) {
            styleMapper.insertStyle(styleVo);
        }

        for (StyleImageVO img : imageList) {
            styleMapper.insertStyleImage(img); 
        }

        for (StyleProductVO prod : productList) {
            styleMapper.insertStyleProduct(prod);
        }

        return true;
    }

    @Override
    @Transactional
    public void updateStyleComplete(StyleVO styleVo, List<StyleImageVO> newImages, String[] productIds, boolean hasNewImages) {
        int styleId = styleVo.getStyleId();
        
        // (1) 마스터 정보 수정
        styleMapper.updateStyle(styleVo);

        // (2) 이미지 업데이트 (새 파일이 있는 경우만 기존 삭제 후 재등록)
        if (hasNewImages) {
            styleMapper.deleteStyleImages(styleId);
            for (StyleImageVO img : newImages) {
                img.setStyleId(styleId);
                styleMapper.insertStyleImage(img);
            }
        }

        // (3) 상품 매칭 업데이트 (기존 삭제 후 재등록)
        styleMapper.deleteStyleProducts(styleId);
        if (productIds != null) {
            for (int i = 0; i < productIds.length; i++) {
                StyleProductVO spVo = new StyleProductVO();
                spVo.setStyleId(styleId);
                spVo.setProductId(productIds[i]);
                spVo.setSortOrder(i + 1);
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
                product.setSizeOptions(styleMapper.getProductSizes(product.getProductId()));
            }
            style.setProducts(products);
        }
        return style;
    }
    
    @Override
    public int registerStyleMaster(StyleVO styleVo) {
        styleMapper.insertStyle(styleVo); 
        return styleVo.getStyleId();
    }

    // 단순 위임 메서드들
    @Override public List<StyleVO> getStyleList() { return styleMapper.selectStyleList(); }
    @Override public StyleVO getStyleDetail(int id) { return styleMapper.selectStyleDetail(id); }
    @Override public List<StyleImageVO> getStyleImages(int id) { return styleMapper.selectStyleImages(id); }
    @Override public List<String> getMatchedProductIds(int id) { return styleMapper.selectMatchedProductIds(id); }
    @Override @Transactional public boolean updateStyleStatus(int id, int status) { return styleMapper.updateStyleStatus(id, status) > 0; }
}