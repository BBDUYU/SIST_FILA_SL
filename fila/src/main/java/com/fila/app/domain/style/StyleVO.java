package com.fila.app.domain.style;

import lombok.Data;

@Data
public class StyleVO {
    private int styleId;      
    private String styleName; 
    private String description;
    private int useYn;        
}
