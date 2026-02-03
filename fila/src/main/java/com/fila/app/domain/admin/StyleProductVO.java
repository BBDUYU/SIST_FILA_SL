package com.fila.app.domain.admin;

import java.util.List;

import lombok.Data;

@Data
public class StyleProductVO {
    private String productId; 
    private int styleId;     
    private int sortOrder;   
    
    private String productName; 
    private String productImage;
    private int price;
    public String getProductImage() {
        if (this.productImage == null) return "";
        return this.productImage.replace("\\", "/");
    }
    private List<String> sizeOptions;
}
