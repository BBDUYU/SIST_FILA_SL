package com.fila.app.service.admin;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.categories.CategoriesVO;
import com.fila.app.domain.admin.ProductVO; // 상품 VO 경로 확인 필요
import com.fila.app.mapper.admin.TagProductsMapper;

@Service
public class AdminTagServiceImpl implements AdminTagService {

    @Autowired
    private com.fila.app.mapper.tag.TagMapper tagMapper; // 태그 관리 매퍼 (Categories 테이블)

    @Autowired
    private TagProductsMapper tagProductsMapper; // 태그 상품 조회 매퍼 (Join/Subquery)

    // 1. 관리자 페이지용 태그 목록 조회
    @Override
    @Transactional(readOnly = true)
    public List<CategoriesVO> getTagList() {
        return tagMapper.selectTagList();
    }

    // 2. 신규 태그 생성 (ID 자동 생성 로직 포함)
    @Override
    @Transactional
    public int createTag(String tagName) {
        // 기존 최대 ID값 조회 후 +1
        int maxId = tagMapper.getMaxTagId();
        int newId = maxId + 1;
        
        CategoriesVO vo = CategoriesVO.builder()
                            .categoryId(newId)
                            .name(tagName)
                            .build();
        
        return tagMapper.insertTag(vo);
    }

    // 3. 특정 태그에 속한 상품 리스트 조회 (추가된 기능)
    @Override
    @Transactional(readOnly = true)
    public List<ProductVO> getProductsByTag(int tagId) {
        return tagProductsMapper.selectProductsByTag(tagId);
    }
}