<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문완료 | FILA</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<style>
    .complete-container { max-width: 800px; margin: 60px auto; padding: 0 20px; text-align: center; font-family: 'Noto Sans KR', sans-serif; }
    .success-icon { font-size: 60px; color: #00205b; margin-bottom: 20px; }
    .complete-title { font-size: 32px; font-weight: 700; margin-bottom: 10px; color: #00205b; }
    .order-num { font-size: 18px; color: #666; margin-bottom: 40px; }
    .order-num strong { color: #000; text-decoration: underline; }
    
    /* 섹션 공통 스타일 */
    .info-section { text-align: left; margin-top: 40px; border-top: 2px solid #000; }
    .section-title { font-size: 20px; font-weight: 700; margin: 20px 0; }
    
    /* 상품 리스트 스타일 */
    .product-list { list-style: none; padding: 0; }
    .product-item { display: flex; align-items: center; padding: 15px 0; border-bottom: 1px solid #eee; }
    .product-img { width: 100px; height: 100px; background: #f4f4f4; margin-right: 20px; }
    .product-img img { width: 100%; height: 100%; object-fit: cover; }
    .product-info .name { font-weight: 700; font-size: 16px; margin-bottom: 5px; }
    .product-info .option { color: #888; font-size: 14px; }
    .product-info .price { font-weight: 700; margin-top: 5px; }

    /* 배송지/결제정보 테이블 */
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    .info-table th { width: 120px; padding: 15px 10px; background: #f9f9f9; color: #666; font-weight: 400; border-bottom: 1px solid #eee; text-align: left; }
    .info-table td { padding: 15px 10px; border-bottom: 1px solid #eee; font-weight: 500; }

    /* 버튼 영역 */
    .btn-wrap { margin-top: 50px; display: flex; justify-content: center; gap: 10px; }
    .btn-main { padding: 18px 50px; font-size: 16px; font-weight: 700; cursor: pointer; border: 1px solid #00205b; transition: 0.3s; }
    .btn-white { background: #fff; color: #00205b; }
    .btn-black { background: #00205b; color: #fff; }
    .btn-main:hover { opacity: 0.8; }
</style>
</head>
<body>

<jsp:include page="../common/header.jsp" />

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

<jsp:include page="../common/footer.jsp" />

</body>
</html>