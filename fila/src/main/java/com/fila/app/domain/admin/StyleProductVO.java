package com.fila.app.domain.admin;

import java.util.List;

import lombok.Data;

@Data
public class StyleProductVO {
    private String product_id; 
    private int style_id;     
    private int sort_order;   
    
    private String product_name; 
    private String product_image;
    private int price;
    public String getProduct_image() {
        if (this.product_image == null) return "";
        return this.product_image.replace("\\", "/");
    }
    private List<String> sizeOptions;
}
