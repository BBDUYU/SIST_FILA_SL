package com.fila.app.domain.main;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MainbannerVO {
    private int bannerId;      
    private String bannerName;  
    private String imageUrl;    
    private String linkUrl;     
}