<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

	<div class="admin-section">
		<div class="section-header"
			style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
			<h3 class="section-title">인기 태그 관리</h3>
			<button onclick="openModal()" class="submit-btn"
				style="width: 150px;">+ 신규 태그 등록</button>
		</div>

		<table class="info-table">
			<thead>
				<tr>
					<th style="width: 10%;">ID</th>
					<th style="width: 30%;">태그명</th>
					<th style="width: 15%;">상태</th>
					<th style="width: 20%;">최종 수정일</th>
					<th style="width: 25%;">관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="tag" items="${tagList}">
					<tr>
						<td>${tag.category_id}</td>
						<td style="text-align: left; padding-left: 30px;"><span
							class="tag-badge"># ${tag.name}</span></td>
						<td><c:choose>
								<c:when test="${tag.use_yn eq 1}">
									<span style="color: #2ecc71; font-weight: bold;">● 사용중</span>
								</c:when>
								<c:otherwise>
									<span style="color: #999; font-weight: bold;">● 중지</span>
								</c:otherwise>
							</c:choose></td>
						<td><fmt:formatDate value="${tag.updated_at}"
								pattern="yyyy-MM-dd HH:mm" /></td>
						<td>
						    <button class="small-btn" onclick="openEditModal('${tag.category_id}', '${tag.name}')">수정</button>
						    
						    <c:choose>
						        <c:when test="${tag.use_yn eq 1}">
						            <%-- 현재 사용 중이면 '중지' 버튼 노출 --%>
						            <button class="small-btn btn-delete" 
						                onclick="if(confirm('#${tag.name} 태그를 비활성화하시겠습니까?')) { location.href='toggleTag.htm?id=${tag.category_id}&status=0'; }">
						                중지
						            </button>
						        </c:when>
						        <c:otherwise>
						            <%-- 현재 중지 상태면 '사용' 버튼 노출 (파란색 계열 스타일 권장) --%>
						            <button class="small-btn" style="background-color: #2ecc71 !important; border-color: #2ecc71 !important;"
						                onclick="if(confirm('#${tag.name} 태그를 활성화하시겠습니까?')) { location.href='toggleTag.htm?id=${tag.category_id}&status=1'; }">
						                사용
						            </button>
						        </c:otherwise>
						    </c:choose>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty tagList}">
					<tr>
						<td colspan="5" style="padding: 50px 0; color: #999;">등록된 태그가
							없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
		<div id="tagModal" class="modal">
	    <div class="modal-content">
	        <div class="modal-header">
	            <h4 class="section-title" id="modalTitle">신규 태그 등록</h4>
	            <span class="close" onclick="closeModal()">&times;</span>
	        </div>
	        <form id="tagForm" action="${pageContext.request.contextPath}/admin/createTag.htm" method="post">
	            <input type="hidden" name="categoryId" id="modalCategoryId">
	            
	            <div style="padding: 20px 0;">
	                <label style="display: block; margin-bottom: 10px; font-weight: bold;">태그 이름</label> 
	                <input type="text" name="tagName" id="modalTagName"
	                    placeholder="# 제외하고 입력 (예: 플로우다운)" required
	                    style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 2px;">
	            </div>
	            
	            <div style="text-align: right; margin-top: 20px;">
	                <button type="button" class="small-btn" onclick="closeModal()"
	                    style="background: #ccc !important; border-color: #ccc !important;">취소</button>
	                <button type="submit" class="submit-btn" id="modalSubmitBtn">등록하기</button>
	            </div>
	        </form>
	    </div>
</div>




	</div>
