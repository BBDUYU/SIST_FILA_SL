package admin.domain;

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
public class CreateproductDTO {
	private String product_id;    
	private int category_id;       
	private String name;           
	private String description;     
	private int price;             
	private int view_count;         
	private Date created_at;        
	private Date updated_at;        
	private String status;          
	private int discount_rate;      

	private int product_image_id;
	private String image_url;
	private String image_type;
	private int is_main;
	private int sort_order;
	
	private int rel_id;
	
	
	private String[] category_ids; 
    private String sport_option;    
    private String[] size_options;
	
    private int sport_option_id;      // 기존 선택된 스포츠 옵션 ID
    private List<Integer> size_option_ids; // 기존 선택된 사이즈 ID 리스트
    private int style_id;       // 기존 연결된 스타일 ID
    private int section_id;     // 기존 연결된 이벤트 섹션 ID
    private int stock;          // 재고 수량
    private int gender_option_id;
    private String gender_name;
    private String category_type;
}
