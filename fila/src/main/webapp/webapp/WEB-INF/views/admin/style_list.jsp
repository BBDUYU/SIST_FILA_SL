<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
