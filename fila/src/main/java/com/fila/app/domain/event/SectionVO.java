package com.fila.app.domain.event;

import java.util.ArrayList;
import java.util.List;

import com.fila.app.domain.admin.StyleImageVO;
import com.fila.app.domain.product.ProductsVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SectionVO {
    private int sectionId;
    private int eventId;
    private int sortOrder;

    private String title; // (추천) 섹션 제목 컬럼이 없으면 임시로 sectionId로 표시하거나, 컬럼 추가 추천
    private List<SectionImageVO> images = new ArrayList<>();
    private List<ProductsVO> products = new ArrayList<>();

    // getter/setter
    public int getSectionId() { return sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public List<SectionImageVO> getImages() { return images; }
    public List<ProductsVO> getProducts() { return products; }
}
