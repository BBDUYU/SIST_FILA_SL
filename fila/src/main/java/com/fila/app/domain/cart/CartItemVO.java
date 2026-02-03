package com.fila.app.domain.cart;

import com.fila.app.domain.admin.StyleImageVO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
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
