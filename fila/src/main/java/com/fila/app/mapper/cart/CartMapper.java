package com.fila.app.mapper.cart;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.fila.app.domain.cart.CartItemVO;
import com.fila.app.domain.order.OrderItemVO;


public interface CartMapper {

	// [1] 전체 조회(원래 DAO에 있던 SELECT)
    List<CartItemVO> selectAll() throws SQLException;

    // [2] 주문 전환용 조회
    List<OrderItemVO> selectCartForOrder(@Param("userNumber") int userNumber) throws SQLException;

    // [3] 주문 후 장바구니 비우기
    int deleteCartAfterOrder(@Param("userNumber") int userNumber) throws SQLException;

    // [4] 수량 변경
    int updateQuantity(@Param("cartItemId") int cartItemId,
                       @Param("quantity") int quantity) throws SQLException;

    // [5] 선택 구매용 조회(ids: "1,2,3")
    List<OrderItemVO> selectSelectedCartItems(@Param("ids") String ids) throws SQLException;

    // [6] 선택 삭제(ids: "1,2,3")
    int deleteCartItems(@Param("cartItemIds") String cartItemIds,
                        @Param("userNumber") int userNumber) throws SQLException;

    // ============================
    // CartListService 기능(추가)
    // ============================

    // [7] 장바구니 담기
    int insertCart(@Param("productId") String productId,
                   @Param("quantity") int quantity,
                   @Param("userNumber") int userNumber,
                   @Param("combinationId") Integer combinationId) throws SQLException;

    // [8] 유저 장바구니 조회(화면용) - 너가 쓰던 SELECT 그대로
    List<CartItemVO> selectAllByUser(@Param("userNumber") int userNumber) throws SQLException;

    // [9] 전체 삭제
    int deleteAllItems(@Param("userNumber") int userNumber) throws SQLException;

    // [10] 옵션 변경용: cartItemId -> productId
    String getProductIdByCartItemId(@Param("cartItemId") int cartItemId) throws SQLException;

    // [11] 옵션 변경용: productId + size -> combinationId
    Integer findCombinationIdBySize(@Param("productId") String productId,
                                    @Param("size") String size) throws SQLException;

    // [12] 옵션 + 수량 업데이트
    int updateItemOption(@Param("cartItemId") int cartItemId,
                         @Param("combinationId") int combinationId,
                         @Param("quantity") int quantity) throws SQLException;
    
    int updateQty(@Param("cartItemId") int cartItemId,
            @Param("userNumber") int userNumber,
            @Param("qty") int qty) throws SQLException;

}
