package com.fila.app.domain.cart;

import lombok.Data;

@Data
public class CartItemVO {

	private int cartItemId;
    private int userNumber;
    private String productId;

    private String productName;

    private int originUnitPrice;
    private int discountRate;
    private int saleUnitPrice;

    private String size;    
    private int quantity;
    private int lineAmount;

    private String mainImageUrl;
}
