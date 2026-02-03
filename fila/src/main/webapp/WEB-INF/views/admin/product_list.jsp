<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


	<div class="admin-section">
		<div class="section-header"
			style="display: flex; justify-content: space-between; align-items: center;">
			<h3 class="section-title">상품 관리 리스트</h3>
			<button onclick="location.href='createProduct.htm'"
				class="submit-btn" style="width: 150px; margin: 0;">+ 신규 상품
				등록</button>
		</div>

		<table class="info-table" style="margin-top: 20px; background: white;">
			<thead>
				<tr style="background: #f9f9f9;">
					<th>이미지</th>
					<th>상품코드</th>
					<th>카테고리</th>
					<th>상품명</th>
					<th>판매가</th>
					<th>재고</th>
					<th>상태</th>
					<th>관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="p" items="${productList}">
					<tr>
						<td><img
							src="${pageContext.request.contextPath}/displayImage.do?path=${p.mainImageUrl}"
							width="50" height="50" style="object-fit: cover;"></td>
						<td>${p.productid}</td>
						<td>${p.categoryName}</td>
						<td style="text-align: left; font-weight: bold;">${p.name}</td>
						<td><fmt:formatNumber value="${p.price}" pattern="#,###" />원</td>
						<td><span class="${p.totalStock < 10 ? 'stock-low' : ''}">${p.totalStock}</span>
						</td>
						<td><c:choose>
								<c:when test="${p.status eq '판매중'}">
									<span style="color: #2ecc71; font-weight: bold;">●
										${p.status}</span>
								</c:when>
								<c:when test="${p.status eq '품절'}">
									<span style="color: var(--fila-red); font-weight: bold;">●
										${p.status}</span>
								</c:when>
								<c:otherwise>
									<span>${p.status}</span>
								</c:otherwise>
							</c:choose></td>
						<td>
							<button class="small-btn"
								onclick="location.href='${pageContext.request.contextPath}/admin/editProduct.htm?id=${p.productId}'">수정</button>
							<button class="small-btn"
							    style="background-color: #e31837; color: white; border: none;"
							    onclick="if(confirm('정말 삭제하시겠습니까?')) { location.href='${pageContext.request.contextPath}/admin/deleteProduct.htm?id=${p.productId}'; }">
							    삭제
							</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
