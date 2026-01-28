package main;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MainbannerDTO {
    private int bannerId;      
    private String bannerName;  
    private String imageUrl;    
    private String linkUrl;     
}