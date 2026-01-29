package event.dto;

import java.util.ArrayList;
import java.util.List;

import products.ProductsDTO;

public class SectionDTO {
    private int sectionId;
    private int eventId;
    private int sortOrder;

    private String title; // (추천) 섹션 제목 컬럼이 없으면 임시로 sectionId로 표시하거나, 컬럼 추가 추천
    private List<SectionImageDTO> images = new ArrayList<>();
    private List<ProductsDTO> products = new ArrayList<>();

    // getter/setter
    public int getSectionId() { return sectionId; }
    public void setSectionId(int sectionId) { this.sectionId = sectionId; }
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public List<SectionImageDTO> getImages() { return images; }
    public List<ProductsDTO> getProducts() { return products; }
}
