package com.fila.app.service.wishlist;

import java.util.List;
import java.util.Set;

import com.fila.app.domain.wishlist.WishListVO;

public interface WishListService {

	List<WishListVO> getWishList(int userNumber);

    void addWish(int userNumber, String productId, String sizeText);

    void addWish(int userNumber, String productId);

    void deleteOne(int userNumber, int wishlistId);

    void deleteSelected(int userNumber, List<Integer> ids);

    void deleteByProduct(int userNumber, String productId);

    boolean isWished(int userNumber, String productId);

    Set<String> getWishedSet(int userNumber);

    boolean toggleWished(int userNumber, String productId, String sizeText);

    boolean toggleWished(int userNumber, String productId);
}
