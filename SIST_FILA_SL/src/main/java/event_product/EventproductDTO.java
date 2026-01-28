package event_product;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EventproductDTO {
	
	private String product_id;
    private String name;        
    private int price;          
    private int discount_rate;  
    
    private int event_id;
    private String event_name;  
    private String slug;        
    private String mainImageUrl;
    
}
