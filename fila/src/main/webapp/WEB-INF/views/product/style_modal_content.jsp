<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="common__layer _setup_cart _style2"> 
    <button type="button" class="layer-button-prev" onclick="closeModal()"></button>

    <div class="inner">
        <div class="photo">
            <div class="after">
                <div class="photo__slider swiper">
                    <div class="swiper-wrapper">
                        <c:forEach var="img" items="${style.images}">
                            <div class="swiper-slide">
                                <img src="${pageContext.request.contextPath}/displayImage.do?path=${img.imageUrl}" alt="스타일 이미지">
                            </div>
                        </c:forEach>
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-pagination"></div>
                </div>
            </div>
        </div>

        <div class="con">
            <div class="cart-list-box">
                <div class="hd">
                    <div class="chk">
                        <input type="checkbox" id="allCheck" class="cb__style1" onclick="cAll();">
                        <label for="allCheck">전체선택<span></span></label>
                    </div>
                    <button type="button" class="close__btn" onclick="closeModal()">close</button>
                </div>
                
                <div class="cn">
                    <form name="styleForm">
                        <ul class="order__list">
                            <c:forEach var="item" items="${style.products}">
    <li>
        <div class="chk">
            <input type="checkbox" id="styleGoodsChk${item.productId}" 
                   class="cb__style1 checkchoice" 
                   data-no="${item.productId}" 
                   data-price="${item.price}" 
                   name="setCheck" 
                   onclick="totalPrc();">
            <label for="styleGoodsChk${item.productId}"></label>
        </div>

        <div class="mid">
            <div class="photo">
                <a href="${pageContext.request.contextPath}/product/detail.htm?productId=${item.productId}">
                    <img src="${pageContext.request.contextPath}/displayImage.do?path=${item.productImage}" alt="${item.productName}">
                </a>
            </div>

            <div class="info">
                <div class="info-inner">
                    <p class="category"></p>
                    <div class="name-tag">
                        <p class="name">${item.productName}</p>
                    </div>								

                    <div class="price">
                        <div>
                            <p class="sale"><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</p>
                        </div>
                    </div>
                </div>

                <div class="option-select-box">
				    <select id="sizeSelect${item.productId}" onchange="optionChg(this, '${item.productId}');">
				        <option value="">사이즈</option>
				        <c:choose>
				            <c:when test="${empty item.sizeOptions}">
				                <option value="">품절/없음</option>
				            </c:when>
				            <c:otherwise>
				                <c:forEach var="size" items="${item.sizeOptions}">
				                    <option value="${size}">${size}</option>
				                </c:forEach>
				            </c:otherwise>
				        </c:choose>
				    </select>
				</div>
            </div>

            <div class="btn-box">
                <button type="button" class="wish__btn wish" data-wish="${item.productId}">wish</button>
            </div>
        </div>
    </li>
</c:forEach>
                        </ul>
                    </form>
                </div>

                <div class="foot">
                    <div class="total-box">
                        <dl>
                            <dt>주문금액</dt>
                            <dd><span id="buytotalSet">0</span>원</dd>
                        </dl>
                    </div>
                    <div class="lyr-btn-box">
                        <button type="button" class="on" onclick="setupCart();">장바구니 담기</button>
                        <button type="button" class="on" onclick="setupBuy();">구매하기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>