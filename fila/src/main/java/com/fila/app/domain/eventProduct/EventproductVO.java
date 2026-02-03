package com.fila.app.domain.eventProduct;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EventproductVO {
	
	private String productId;
    private String name;        
    private int price;          
    private int discountRate;  
    
    private int eventId;
    private String eventName;  
    private String slug;        
    private String mainImageUrl;
    
}
