package com.fila.app.mapper.cart;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.cart.CartItemVO;
import com.fila.app.domain.order.OrderItemVO;

public interface CartMapper {

	// [1] 전체 조회
    public List<CartItemVO> selectAll() throws SQLException;

    // [2] 주문 전환용 조회 (유저 장바구니 -> 주문아이템)
    public List<OrderItemVO> selectCartForOrder(@Param("userNumber") int userNumber) throws SQLException;

    // [3] 장바구니 비우기
    public int deleteCartAfterOrder(@Param("userNumber") int userNumber) throws SQLException;

    // [4] 수량 변경
    public int updateQuantity(
            @Param("cartItemId") int cartItemId,
            @Param("quantity") int quantity
    ) throws SQLException;

    // [5] 선택 구매용 조회 (ids: "1,2,3" 형태)
    public List<OrderItemVO> selectSelectedCartItems(@Param("ids") String ids) throws SQLException;

    // [6] 선택 삭제 (cartItemIds: "1,2,3" 형태)
    public int deleteCartItems(
            @Param("cartItemIds") String cartItemIds,
            @Param("userNumber") int userNumber
    ) throws SQLException;

	
    
}
