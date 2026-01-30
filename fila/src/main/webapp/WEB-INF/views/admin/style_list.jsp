<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<meta charset="UTF-8">
<title>FILA Admin - 스타일 관리</title>
<style>
/* 기존 상품 관리 스타일 변수 및 기본 레이아웃 유지 */
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

/* 테이블 디자인 */
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
	vertical-align: middle;
}

/* 버튼 디자인 */
.submit-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: none;
	padding: 10px 20px;
	font-weight: 700;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 13px;
	border-radius: 2px;
	text-decoration: none;
	display: inline-block;
}

.submit-btn:hover {
	background-color: #001640 !important;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.small-btn {
	background-color: var(--fila-navy) !important;
	color: #ffffff !important;
	border: 1px solid var(--fila-navy) !important;
	padding: 6px 15px;
	font-size: 12px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
	border-radius: 2px;
	text-decoration: none;
}

.small-btn:hover {
	background-color: #ffffff !important;
	color: var(--fila-navy) !important;
}

/* 스타일 화보 전용 썸네일 (세로형) */
.style-thumb {
	width: 70px;
	height: 90px;
	object-fit: cover;
	border: 1px solid #eee;
	border-radius: 2px;
}

/* 노출 여부 뱃지 */
.badge-use {
	padding: 4px 8px;
	border-radius: 20px;
	font-size: 11px;
	font-weight: bold;
}
.bg-live { background-color: #e8f8f0; color: #2ecc71; }
.bg-stop { background-color: #fff0f0; color: var(--fila-red); }
</style>
</head>
<body>
	<jsp:include page="../common/sidebar.jsp">
		<jsp:param name="currentPage" value="style" />
	</jsp:include>

	<div class="admin-section">
		<div class="section-header"
			style="display: flex; justify-content: space-between; align-items: center;">
			<h3 class="section-title">스타일 관리 리스트</h3>
			<button onclick="location.href='${pageContext.request.contextPath}/admin/createStyle.htm'"
				class="submit-btn" style="width: 150px; margin: 0;">+ 신규 스타일 등록</button>
		</div>

		<table class="info-table" style="margin-top: 20px; background: white;">
			<thead>
				<tr style="background: #f9f9f9;">
					<th style="width: 100px;">대표이미지</th>
					<th style="width: 80px;">ID</th>
					<th>스타일 명칭</th>
					<th>설명</th>
					<th style="width: 100px;">활성상태</th>
					<th style="width: 180px;">관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="s" items="${styleList}">
					<tr>
						<td>
							<c:choose>
								<c:when test="${not empty s.main_image_url}">
									<img src="${pageContext.request.contextPath}/displayImage.do?path=${s.main_image_url}" class="style-thumb">
								</c:when>
								<c:otherwise>
									<div style="width:70px; height:90px; background:#eee; line-height:90px; font-size:11px; color:#999;">No Image</div>
								</c:otherwise>
							</c:choose>
						</td>
						<td>${s.style_id}</td>
						<td style="text-align: left; font-weight: bold;">${s.style_name}</td>
						<td style="text-align: left; color: #888; font-size: 13px;">${s.description}</td>
						<td>
							<c:choose>
								<c:when test="${s.use_yn == 1}">
									<span class="badge-use bg-live">활성화</span>
								</c:when>
								<c:otherwise>
									<span class="badge-use bg-stop">비활성화</span>
								</c:otherwise>
							</c:choose>
						</td>
						<td>
						    <button class="small-btn"
						        onclick="location.href='${pageContext.request.contextPath}/admin/editStyle.htm?id=${s.style_id}'">수정</button>
						    
						    <%-- 삭제 대신 상태 변경 토글 버튼 --%>
						    <button type="button" 
						            class="small-btn ${s.use_yn == 1 ? 'btn-stop' : 'btn-live'}" 
						            style="background-color: ${s.use_yn == 1 ? '#e31837' : '#2ecc71'}; color: white; border: none; margin-left:5px; width: 100px;"
						            onclick="toggleStatus('${s.style_id}', ${s.use_yn})">
						        ${s.use_yn == 1 ? '비활성화' : '활성화'}
						    </button>
						</td>
					</tr>
				</c:forEach>
				<c:if test="${empty styleList}">
					<tr>
						<td colspan="6" style="padding: 100px 0; color: #999;">등록된 스타일이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>
<script>
function toggleStatus(id, currentStatus) {
    const nextStatus = (currentStatus === 1) ? 0 : 1;
    const msg = nextStatus === 1 ? "해당 스타일을 활성화하시겠습니까?" : "해당 스타일을 비활성화하시겠습니까?";

    if (confirm(msg)) {
        $.ajax({
            // 매핑한 .htm 주소와 일치해야 합니다.
            url: "${pageContext.request.contextPath}/admin/toggleStyle.htm",
            type: "GET",
            data: { 
                id: id, 
                status: nextStatus 
            },
            success: function(res) {
                if (res.trim() === "success") {
                    location.reload(); // 상태 반영을 위해 페이지 새로고침
                } else {
                    alert("상태 변경 처리에 실패했습니다.");
                }
            },
            error: function() {
                alert("서버 통신 오류가 발생했습니다.");
            }
        });
    }
}
</script>
</body>
</html>