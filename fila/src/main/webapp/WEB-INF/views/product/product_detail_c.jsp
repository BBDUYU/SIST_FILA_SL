<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${not empty errorMsg}">
    <script>
        alert("${errorMsg}");
        history.back();
    </script>
</c:if>

<c:if test="${empty errorMsg and not empty product}">

<%-- [cart 관련 추가 1] 로그인 후 돌아올 returnUrl 만들기 (쿼리스트링 포함) --%>
<c:set var="pid" value="${param.productId}" />
<c:if test="${empty pid}">
  <c:set var="pid" value="${product.productId}" />
</c:if>

<c:set var="returnUrl" value="/product/detail.htm?productId=${pid}" />

<%-- [cart 관련 추가 2] loginUrl (returnUrl 파라미터 포함, 자동 URL 인코딩) --%>
<c:url var="loginUrl" value="/login.htm">
    <c:param name="returnUrl" value="${returnUrl}" />
</c:url>

<%-- [cart 관련 추가 3] 장바구니 담기 기본 URL (action/add 포함) quantity는 JS에서 현재 수량 읽어서 붙일 거라 여기선 빼둠 --%>
<c:url var="addCartBaseUrl" value="/pay/cart.htm">
    <c:param name="action" value="add" />
    <c:param name="productId" value="${product.productId}" />
</c:url>