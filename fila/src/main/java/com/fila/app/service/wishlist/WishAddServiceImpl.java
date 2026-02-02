package com.fila.app.service.wishlist;

import org.springframework.stereotype.Service;

import com.fila.app.mapper.wishlist.WishAddMapper;

@Service
public class WishAddServiceImpl implements WishAddService{

	private final WishAddMapper wishAddMapper;

    public WishAddServiceImpl(WishAddMapper wishAddMapper) {
        this.wishAddMapper = wishAddMapper;
    }

    public void addWish(int userNumber, String productId) {

        // 중복 방지
        if (wishAddMapper.exists(userNumber, productId)) return;

        wishAddMapper.insert(userNumber, productId);
    }
    
}
