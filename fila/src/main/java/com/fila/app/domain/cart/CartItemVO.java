package com.fila.app.domain.cart;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
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

	public int getCartItemId() { return cartItemId; }
	public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }

	public int getUserNumber() { return userNumber; }
	public void setUserNumber(int userNumber) { this.userNumber = userNumber; }

	public String getProductId() { return productId; }
	public void setProductId(String productId) { this.productId = productId; }

	public String getProductName() { return productName; }
	public void setProductName(String productName) { this.productName = productName; }

	public int getOriginUnitPrice() { return originUnitPrice; }
	public void setOriginUnitPrice(int originUnitPrice) { this.originUnitPrice = originUnitPrice; }

	public int getDiscountRate() { return discountRate; }
	public void setDiscountRate(int discountRate) { this.discountRate = discountRate; }

	public int getSaleUnitPrice() { return saleUnitPrice; }
	public void setSaleUnitPrice(int saleUnitPrice) { this.saleUnitPrice = saleUnitPrice; }

	public String getSize() { return size; }
	public void setSize(String size) { this.size = size; }

	public int getQuantity() { return quantity; }
	public void setQuantity(int quantity) { this.quantity = quantity; }

	public int getLineAmount() { return lineAmount; }
	public void setLineAmount(int lineAmount) { this.lineAmount = lineAmount; }

	public String getMainImageUrl() { return mainImageUrl; }
	public void setMainImageUrl(String mainImageUrl) { this.mainImageUrl = mainImageUrl; }
}
