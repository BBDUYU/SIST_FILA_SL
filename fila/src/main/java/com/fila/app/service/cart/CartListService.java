package com.fila.app.service.cart;

import java.util.List;

import com.fila.app.domain.cart.CartItemVO;

public interface CartListService {

	void insertCart(String productId, int quantity, int userNumber, Integer combinationId) throws Exception;

    List<CartItemVO> selectAll(int userNumber) throws Exception;

    void deleteItems(String ids, int userNumber) throws Exception;

    void deleteAllItems(int userNumber) throws Exception;

    void updateItem(int cartItemId, int quantity) throws Exception;

    void updateItemOption(int cartItemId, String size, int quantity) throws Exception;

	void updateItemQty(int cartItemId, int userNumber, int quantity) throws Exception;
}
