package fila.categories.service;

import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fila.categories.domain.CategoriesDTO;
import fila.mapper.CategoryMapper;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor // 상단 Autowired 대신 사용 가능
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public ArrayList<CategoriesDTO> getHeaderCategories() {
        try {
            return categoryMapper.selectCategoryList();
        } catch (Exception e) {
            log.error("카테고리 리스트 조회 실패", e);
            return new ArrayList<>();
        }
    }

    @Override
    public ArrayList<CategoriesDTO> getAllTags() {
        try {
            return categoryMapper.selectTagList();
        } catch (Exception e) {
            log.error("태그 리스트 조회 실패", e);
            return new ArrayList<>();
        }
    }

    @Override
    public ArrayList<CategoriesDTO> getActiveTags() {
        try {
            return categoryMapper.selectActiveTagList();
        } catch (Exception e) {
            log.error("활성 태그 조회 실패", e);
            return new ArrayList<>();
        }
    }

    @Override
    public void addNewTag(String tagName) {
        try {
            int nextId = categoryMapper.getMaxTagId() + 1;
            CategoriesDTO dto = CategoriesDTO.builder()
                    .category_id(nextId)
                    .name(tagName)
                    .build();
            categoryMapper.insertTag(dto);
            log.info("새 태그 등록 성공: " + tagName + "(ID: " + nextId + ")");
        } catch (Exception e) {
            log.error("태그 추가 실패", e);
            throw new RuntimeException("태그 등록 중 오류 발생", e);
        }
    }

    @Override
    public void modifyTag(int id, String name) {
        try {
            categoryMapper.updateTag(id, name);
            log.info("태그 수정 성공: ID " + id + " -> " + name);
        } catch (Exception e) {
            log.error("태그 수정 실패", e);
            throw new RuntimeException("태그 수정 중 오류 발생", e);
        }
    }

    @Override
    public void changeTagStatus(int id, int status) {
        try {
            int result = categoryMapper.updateTagStatus(id, status);
            if(result > 0) {
                log.info("태그 상태 변경 성공: ID " + id + " Status " + status);
            }
        } catch (Exception e) {
            log.error("태그 상태 변경 실패", e);
            throw new RuntimeException("상태 변경 중 오류 발생", e);
        }
    }
}