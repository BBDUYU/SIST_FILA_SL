<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="complete-container">
    <div class="success-icon">✓</div>
    <h2 class="complete-title">주문이 완료되었습니다.</h2>
    <p class="order-num">주문번호 : <strong>${order.orderId}</strong></p>

    <div class="info-section">
        <h3 class="section-title">주문 상품 정보</h3>
        <ul class="product-list">
            <c:forEach var="item" items="${order.orderItems}">
                <li class="product-item">
                    <div class="product-img">
                        <img src="${pageContext.request.contextPath}/displayImage.do?path=C:/fila_upload/product/${item.productId}/${item.productId}_main_1.jpg" 
                             alt="${item.productName}" 
                             onerror="this.src='${pageContext.request.contextPath}/images/no_image.jpg';">
                    </div>
                    <div class="product-info">
                        <p class="name">${item.productName}</p>
                        <p class="option">옵션 : ${item.size} / 수량 : ${item.quantity}개</p>
                        <p class="price"><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</p>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>

    <div class="info-section">
        <h3 class="section-title">배송지 정보</h3>
        <table class="info-table">
            <tr>
                <th>받는분</th>
                <td>${order.recipientName}</td>
            </tr>
            <tr>
                <th>연락처</th>
                <td>${order.recipientPhone}</td>
            </tr>
            <tr>
                <th>배송지</th>
                <td>${order.address}</td>
            </tr>
            <tr>
                <th>배송요청사항</th>
                <td>${not empty order.deliveryRequest ? order.deliveryRequest : '없음'}</td>
            </tr>
        </table>
    </div>

    <div class="info-section">
        <h3 class="section-title">결제 정보</h3>
        <table class="info-table">
            <tr>
                <th>결제금액</th>
                <td style="color: #d10024; font-size: 20px;">
                    <strong><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>원</strong>
                </td>
            </tr>
            <tr>
                <th>결제수단</th>
                <td>${order.paymentMethod == 'card' ? '신용카드' : '카카오페이'}</td>
            </tr>
        </table>
    </div>

    <div class="btn-wrap">
        <button type="button" class="btn-main btn-white" onclick="location.href='${pageContext.request.contextPath}/index.htm'">쇼핑 계속하기</button>
        <button type="button" class="btn-main btn-black" onclick="location.href='${pageContext.request.contextPath}/mypage/orders.htm'">주문내역 확인</button>
    </div>
</div>
