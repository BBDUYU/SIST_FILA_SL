<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="common__layer _option" style="display: block !important;">
    <div class="layer-bg__wrap"></div>
    <div class="inner2">
        <form name="form99" id="form99">
            <input type="hidden" name="cartItemId" value="${param.cartItemId}">
            <input type="hidden" name="productId" value="${product.productId}">
            <input type="hidden" name="cartPrice" value="${product.price * (100 - product.discount_rate) / 100}">

            <div class="head __line">
                <p class="tit">옵션 / 수량변경</p>
                <button type="button" class="close__btn">close</button>
            </div>

            <div class="con">
                <div class="goods-info-box">
                    <p class="name">${product.name}</p> <p class="option">현재 선택: ${currentSize}</p> </div>
                <section class="cart-box">
                    <h5>사이즈</h5>
                    <ul class="size-list cartVsize" id="vSize">
                        <c:forEach var="opt" items="${sizeOptions}">
                            <li>
                                <input type="radio" class="size__style1" 
                                       id="popOptionSize${opt.optionValue}" 
                                       name="ProductSize_Cart" 
                                       value="${opt.optionValue}" 
                                       ${opt.optionValue == currentSize ? 'checked' : ''}
                                       ${opt.stock == 0 ? 'disabled' : ''}>
                                <label for="popOptionSize${opt.optionValue}">${opt.optionValue}</label>
                            </li>
                        </c:forEach>
                    </ul>

                    <div class="qty-box" id="vpop99">
                        <button type="button" id="qtyMinusW" class="minus__btn">minus</button>
                        <input type="number" name="ProductQuantity" id="ProductQuantityW" value="${currentQty}" maxlength="2">
                        <button type="button" id="qtyPlusW" class="plus__btn">plus</button>
                    </div>

                    <div class="total-box">
                        <dl>
                            <dt>주문금액</dt>
                            <dd id="ctoprice">
                                <fmt:formatNumber value="${(product.price * (100 - product.discount_rate) / 100) * currentQty}" pattern="#,###"/>원
                            </dd>
                        </dl>
                    </div>
                </section>
            </div>
            <div class="foot">
                <button type="button" class="btn_txt__gr cancel__btn">취소</button>
                <button type="button" class="btn_txt__wt" onclick="cart_action3();">변경하기</button>
            </div>
        </form>
    </div>
</div>