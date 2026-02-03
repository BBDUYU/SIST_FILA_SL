<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

	<div class="admin-section">
		<h3 class="section-title">스타일 정보 수정</h3>

		<form id="editForm">
			<%-- 스타일 ID --%>
			<input type="hidden" name="style_id" value="${style.styleId}">

			<table class="write-table">
				<tr>
					<th>스타일 명칭 *</th>
					<td><input type="text" name="style_name" value="${style.styleName}" style="width:100%; padding:10px; border:1px solid #ddd;" required></td>
				</tr>
				<tr>
					<th>스타일 설명</th>
					<td><textarea name="description" style="width:100%; padding:10px; border:1px solid #ddd;" rows="3">${style.description}</textarea></td>
				</tr>
				<tr>
					<th>화보 이미지 수정 *</th>
					<td>
						<p style="color:var(--fila-red); font-size:12px; margin-bottom:10px;">* 새로운 이미지를 업로드하면 기존 이미지는 모두 삭제됩니다.</p>
						<div class="photo-upload-zone" onclick="document.getElementById('styleImgs').click()">
							<span style="font-size:24px;">+</span><br>
							<span class="desc">클릭하여 화보 이미지 교체 (첫 번째 이미지가 메인)</span>
							<input type="file" id="styleImgs" name="style_images" multiple style="display: none" onchange="previewImages(this)">
						</div>
						<%-- 기존 이미지를 먼저 보여주고, 새 파일 선택 시 previewImages()가 덮어씌움 --%>
						<div id="main-preview" class="preview-container">
							<c:forEach var="img" items="${imageList}">
								<div class="preview-box">
									<c:if test="${img.isMain == 1}"><span class="main-badge">MAIN</span></c:if>
									<c:set var="safePath" value="${fn:replace(img.imageUrl, '\\\\', '/')}" />
									<img src="${pageContext.request.contextPath}/displayImage.do?path=${safePath}">
								</div>
							</c:forEach>
						</div>
					</td>
				</tr>
				<tr>
					<th>노출 여부</th>
					<td>
						<select name="use_yn" style="padding:10px; border:1px solid #ddd;">
							<option value="1" ${style.useYn == 1 ? 'selected' : ''}>활성화</option>
							<option value="0" ${style.useYn == 0 ? 'selected' : ''}>비활성화</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>선택된 연관 상품</th>
					<td>
						<div class="product-tag-container" id="productTagContainer">
							<span style="color:#999; font-size:13px;" id="no-product-msg">아래 리스트에서 상품을 추가해주세요.</span>
						</div>
					</td>
				</tr>
			</table>

			<h4 style="font-size:16px; color:var(--fila-navy); margin: 30px 0 10px 0;">매칭할 상품 선택</h4>
			<div style="max-height: 400px; overflow-y: auto; border: 1px solid #eee;">
				<table class="product-select-table">
					<thead style="position: sticky; top: 0; z-index: 10;">
						<tr>
							<th>이미지</th>
							<th>상품코드</th>
							<th>상품명</th>
							<th>판매가</th>
							<th>상태</th>
							<th>선택</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="p" items="${productList}">
							<tr>
								<td><img src="${pageContext.request.contextPath}/displayImage.do?path=${p.mainImageUrl}" width="40" height="40"></td>
								<td>${p.productId}</td>
								<td style="text-align: left;"><strong>${p.name}</strong></td>
								<td><fmt:formatNumber value="${p.price}" pattern="#,###" />원</td>
								<td>${p.status}</td>
								<td>
									<button type="button" class="small-add-btn" 
										onclick="addProductTag('${p.productId}', '${p.name}')" id="btn-${p.productId}">추가</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<div style="margin-top: 40px; text-align: center;">
				<a href="${pageContext.request.contextPath}/admin/styleList.htm" class="cancel-btn">취소</a>
				<button type="submit" class="submit-btn">수정 완료</button>
			</div>
		</form>
	</div>
