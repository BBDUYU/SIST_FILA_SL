package com.fila.app.mapper.wishlist;

import org.apache.ibatis.annotations.Param;

public interface WishAddMapper {

	// 중복 체크
    boolean exists(@Param("userNumber") int userNumber,
                   @Param("productId") String productId);

    // INSERT
    int insert(@Param("userNumber") int userNumber,
               @Param("productId") String productId);
}
