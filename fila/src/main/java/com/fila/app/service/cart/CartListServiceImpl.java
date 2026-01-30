package com.fila.app.service.cart;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fila.app.domain.cart.CartItemVO;
import com.fila.app.mapper.cart.CartMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CartListServiceImpl implements CartListService {
	
	private final CartMapper cartMapper;

    @Override
    @Transactional
    public void insertCart(String productId, int quantity, int userNumber, Integer combinationId) throws Exception {
        cartMapper.insertCart(productId, quantity, userNumber, combinationId);
    }

    @Override
    public List<CartItemVO> selectAll(int userNumber) throws Exception {
        return cartMapper.selectAllByUser(userNumber);
    }

    @Override
    @Transactional
    public void deleteItems(String ids, int userNumber) throws Exception {
        if (ids == null || ids.trim().isEmpty()) return;
        cartMapper.deleteItems(ids, userNumber);
    }

    @Override
    @Transactional
    public void deleteAllItems(int userNumber) throws Exception {
        cartMapper.deleteAllItems(userNumber);
    }

    @Override
    @Transactional
    public void updateItem(int cartItemId, int quantity) throws Exception {
        cartMapper.updateQuantity(cartItemId, quantity);
    }

    @Override
    @Transactional
    public void updateItemOption(int cartItemId, String size, int qty) throws Exception {
        String productId = cartMapper.getProductIdByCartItemId(cartItemId);
        if (productId == null) return;

        Integer combiId = cartMapper.findCombinationIdBySize(productId, size == null ? null : size.trim());
        if (combiId == null) return;

        cartMapper.updateItemOption(cartItemId, combiId, qty);
    }
}
