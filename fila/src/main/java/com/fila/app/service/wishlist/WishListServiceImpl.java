package com.fila.app.service.wishlist;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;

import com.fila.app.mapper.wishlist.WishListMapper;

@Service
public class WishListServiceImpl implements WishListService{

	private final WishListMapper wishListMapper;

    public WishListServiceImpl(WishListMapper wishListMapper) {
        this.wishListMapper = wishListMapper;
    }

    public List<com.fila.app.domain.mypage.WishListVO> getWishList(int userNumber) {
        return wishListMapper.selectWishListByUser(userNumber);
    }

    // 2) 위시리스트 추가 (SIZE_TEXT 저장 포함)
    public void addWish(int userNumber, String productId, String sizeText) {
        if (sizeText == null) sizeText = "";
        // DAO는 내부에서 중복체크 했었는데,
        // Mapper로 오면서 서비스에서 중복 체크하는 방식이 더 자연스럽습니다.
        int exists = wishListMapper.existsUserProduct(userNumber, productId);
        if (exists == 1) return;

        wishListMapper.insertWish(userNumber, productId, sizeText);
    }

    public void addWish(int userNumber, String productId) {
        addWish(userNumber, productId, "");
    }

    // 3) 단건 삭제
    public void deleteOne(int userNumber, int wishlistId) {
        wishListMapper.deleteOne(userNumber, wishlistId);
    }

    // 4) 선택 삭제
    public void deleteSelected(int userNumber, List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return;
        wishListMapper.deleteSelected(userNumber, ids);
    }

    // 5) 찜 취소(삭제) - product_id로
    public void deleteByProduct(int userNumber, String productId) {
        wishListMapper.deleteByProduct(userNumber, productId);
    }

    // 6) 상세페이지: 찜 여부
    public boolean isWished(int userNumber, String productId) {
        return wishListMapper.existsByProduct(userNumber, productId);
    }

    // 7) 메인/리스트용: 찜 상품ID Set
    public Set<String> getWishedSet(int userNumber) {
        List<String> ids = wishListMapper.selectWishedProductIds(userNumber);
        return new HashSet<>(ids);
    }

    // 8) 찜 토글
    public boolean toggleWished(int userNumber, String productId, String sizeText) {

        boolean exists = wishListMapper.existsByProduct(userNumber, productId);

        if (exists) {
            wishListMapper.deleteByProduct(userNumber, productId);
            return false;
        } else {
            // ✅ 유지: sizeText 빈값이면 null로 저장되게
            if (sizeText == null || sizeText.trim().isEmpty()) sizeText = null;
            wishListMapper.insertWish(userNumber, productId, sizeText);
            return true;
        }
    }

    public boolean toggleWished(int userNumber, String productId) {
        return toggleWished(userNumber, productId, "미선택");
    }
}
