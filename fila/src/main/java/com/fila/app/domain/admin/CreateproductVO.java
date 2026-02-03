package com.fila.app.domain.admin;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CreateproductVO {
	private String productId;    
	private int categoryId;       
	private String name;           
	private String description;     
	private int price;             
	private int viewCount;         
	private Date createdAt;        
	private Date updatedAt;        
	private String status;          
	private int discountRate;      

	private int productImageId;
	private String imageUrl;
	private String imageType;
	private int is_main;
	private int sortOrder;
	
	private int relId;
	
	
	private String[] categoryIds; 
    private String sportOption;    
    private String[] sizeOptions;
	
    private int sportOption_id;      // 기존 선택된 스포츠 옵션 ID
    private List<Integer> sizeOptionIds; // 기존 선택된 사이즈 ID 리스트
    private int styleId;       // 기존 연결된 스타일 ID
    private int sectionId;     // 기존 연결된 이벤트 섹션 ID
    private int stock;          // 재고 수량
    private int genderOptionId;
    private String genderName;
    private String categoryType;
}
