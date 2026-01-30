<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA 관리자 - 인기 태그 관리</title>
<style>
/* 기존 스타일 변수 및 레이아웃 유지 */
:root {
	--fila-navy: #00205b;
	--fila-red: #e31837;
	--bg-gray: #f4f4f4;
}

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: var(--bg-gray);
	margin: 0;
}

.admin-section {
	margin-left: 240px;
	padding: 50px 40px;
	min-height: 100vh;
}

.section-title {
	font-size: 22px;
	font-weight: 800;
	color: var(--fila-navy);
	letter-spacing: -0.5px;
	position: relative;
	padding-left: 15px;
	margin: 0;
}

.section-title::before {
	content: '';
	position: absolute;
	left: 0;
	top: 50%;
	transform: translateY(-50%);
	width: 4px;
	height: 20px;
	background-color: var(--fila-red);
}

/* 테이블 공통 디자인 */
.info-table {
	width: 100%;
	border-collapse: collapse;
	border-top: 2px solid var(--fila-navy);
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	background-color: #fff;
}

.info-table th {
	background-color: #f9f9f9;
	color: #333;
	font-weight: 700;
	font-size: 13px;
	padding: 15px 10px;
	border-bottom: 1px solid #eee;
}

.info-table td {
	padding: 15px 10px;
	border-bottom: 1px solid #f1f1f1;
	text-align: center;
	font-size: 14px;
	color: #555;
}

/* 해시태그 강조 스타일 */
.tag-badge {
	color: var(--fila-navy);
	font-weight: 700;
	background-color: #eef2f9;
	padding: 4px 10px;
	border-radius: 20px;
}

/* 버튼 스타일 */
.submit-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: none;
	padding: 10px 20px;
	font-weight: 700;
	cursor: pointer;
	border-radius: 2px;
	text-decoration: none;
}

.small-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: 1px solid var(--fila-navy) !important;
	padding: 6px 15px;
	font-size: 12px;
	font-weight: 600;
	cursor: pointer;
	border-radius: 2px;
	transition: all 0.2s ease;
}

.small-btn:hover {
	background-color: #ffffff !important;
	color: var(--fila-navy) !important;
}

.btn-delete {
	background-color: var(--fila-red) !important;
	border: 1px solid var(--fila-red) !important;
}

.btn-delete:hover {
	background-color: #ffffff !important;
	color: var(--fila-red) !important;
}
</style>
</head>
<body>
	<jsp:include page="../common/sidebar.jsp">
		<jsp:param name="currentPage" value="tag" />
	</jsp:include>

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

		<style>
/* 모달 스타일 */
.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background-color: #fff;
	margin: 10% auto;
	padding: 30px;
	border-radius: 4px;
	width: 400px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1px solid #eee;
	padding-bottom: 15px;
}

.close {
	font-size: 28px;
	font-weight: bold;
	cursor: pointer;
	color: #aaa;
}

.close:hover {
	color: #000;
}
</style>

<script>
// 등록 모달 열기
function openModal() {
    document.getElementById('tagForm').action = "${pageContext.request.contextPath}/admin/createTag.htm";
    document.getElementById('modalTitle').innerText = "신규 태그 등록";
    document.getElementById('modalSubmitBtn').innerText = "등록하기";
    document.getElementById('modalCategoryId').value = "";
    document.getElementById('modalTagName').value = "";
    document.getElementById('tagModal').style.display = 'block';
}

// 수정 모달 열기
function openEditModal(id, name) {
    document.getElementById('tagForm').action = "${pageContext.request.contextPath}/admin/editTag.htm";
    document.getElementById('modalTitle').innerText = "태그 정보 수정";
    document.getElementById('modalSubmitBtn').innerText = "수정하기";
    document.getElementById('modalCategoryId').value = id;
    document.getElementById('modalTagName').value = name;
    document.getElementById('tagModal').style.display = 'block';
}

function closeModal() { document.getElementById('tagModal').style.display = 'none'; }

</script>
	</div>
</body>
</html>