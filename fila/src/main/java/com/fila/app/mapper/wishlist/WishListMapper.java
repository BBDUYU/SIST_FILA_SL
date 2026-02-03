package com.fila.app.mapper.wishlist;

import java.util.List;

import org.apache.ibatis.annotations.Param;


public interface WishListMapper {

	// 1) 위시리스트 목록
    List<com.fila.app.domain.mypage.WishListVO> selectWishListByUser(@Param("userNumber") int userNumber);

    // 2) 중복 체크 (DAO의 dupSql 그대로)
    int existsUserProduct(@Param("userNumber") int userNumber,
                          @Param("productId") String productId);

    // 3) INSERT (SIZE_TEXT 포함)
    int insertWish(@Param("userNumber") int userNumber,
                   @Param("productId") String productId,
                   @Param("sizeText") String sizeText);

    // 4) 단건 삭제
    int deleteOne(@Param("userNumber") int userNumber,
                  @Param("wishlistId") int wishlistId);

    // 5) 선택 삭제
    int deleteSelected(@Param("userNumber") int userNumber,
                       @Param("ids") List<Integer> ids);

    // 6) product_id로 삭제
    int deleteByProduct(@Param("userNumber") int userNumber,
                        @Param("productId") String productId);

    // 7) 찜 여부
    boolean existsByProduct(@Param("userNumber") int userNumber,
                            @Param("productId") String productId);

    // 8) 찜한 상품ID 목록
    List<String> selectWishedProductIds(@Param("userNumber") int userNumber);
}
