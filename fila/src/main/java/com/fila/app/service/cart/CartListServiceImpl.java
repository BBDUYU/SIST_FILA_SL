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
        cartMapper.deleteCartItems(ids, userNumber);
    }

    @Override
    @Transactional
    public void deleteAllItems(int userNumber) throws Exception {
        cartMapper.deleteAllItems(userNumber);
    }

    @Override
    @Transactional
    public void updateItemOption(int cartItemId, String size, int quantity) throws Exception {

        // 1. cartItemId → productId
        String productId = cartMapper.getProductIdByCartItemId(cartItemId);

        // 2. productId + size → combinationId
        Integer combinationId = cartMapper.findCombinationIdBySize(productId, size);

        if (combinationId == null) {
            throw new IllegalStateException("해당 옵션 조합이 존재하지 않습니다.");
        }

        // 3. update
        cartMapper.updateItemOption(cartItemId, combinationId, quantity);
    }

	@Override
	@Transactional
	public void updateItem(int cartItemId, int quantity) throws Exception {
		cartMapper.updateQuantity(cartItemId, quantity);
	}
	
	@Override
    @Transactional
    public void updateItemQty(int cartItemId, int userNumber, int qty) throws Exception {
        if (qty < 1) {
            throw new IllegalArgumentException("수량은 1 이상이어야 합니다.");
        }

        cartMapper.updateQty(cartItemId, userNumber, qty);
    }
}
