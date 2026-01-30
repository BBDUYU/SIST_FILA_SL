<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA Admin - 스타일 수정</title>
<style>
/* FILA 브랜드 컬러 및 레이아웃 유지 */
:root { --fila-navy: #00205b; --fila-red: #e31837; --bg-gray: #f4f4f4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--bg-gray); margin: 0; }
.admin-section { margin-left: 240px; padding: 50px 40px; min-height: 100vh; }
.section-title { font-size: 22px; font-weight: 800; color: var(--fila-navy); position: relative; padding-left: 15px; margin-bottom: 30px; }
.section-title::before { content: ''; position: absolute; left: 0; top: 50%; transform: translateY(-50%); width: 4px; height: 20px; background-color: var(--fila-red); }

/* 폼 및 테이블 공통 */
.write-table, .product-select-table { width: 100%; border-collapse: collapse; background: #fff; border-top: 2px solid var(--fila-navy); margin-bottom: 30px; }
.write-table th, .product-select-table th { background: #f9f9f9; padding: 15px; border-bottom: 1px solid #eee; text-align: left; font-size: 13px; }
.write-table td, .product-select-table td { padding: 12px 15px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 14px; }

/* 이미지 업로드 존 및 미리보기 */
.photo-upload-zone { border: 2px dashed #ccc; padding: 30px; text-align: center; cursor: pointer; transition: 0.3s; background: #fff; margin-bottom: 10px; }
.photo-upload-zone:hover { border-color: var(--fila-navy); background: #f0f4f9; }
.preview-container { display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap; }
.preview-box { width: 80px; height: 100px; border: 1px solid #eee; position: relative; }
.preview-box img { width: 100%; height: 100%; object-fit: cover; }
.main-badge { position: absolute; top: 3px; left: 3px; background: var(--fila-red); color: white; font-size: 9px; padding: 2px 4px; font-weight: bold; z-index: 10; }

/* 선택된 상품 태그 */
.product-tag-container { display: flex; flex-wrap: wrap; gap: 10px; padding: 10px; background: #fdfdfd; border: 1px solid #eee; min-height: 50px; }
.product-tag { background: var(--fila-navy); color: #fff; padding: 5px 12px; border-radius: 2px; font-size: 12px; display: flex; align-items: center; }
.btn-tag-del { margin-left: 8px; cursor: pointer; font-weight: bold; }

/* 버튼 스타일 */
.submit-btn { background: var(--fila-navy); color: #fff; padding: 15px 50px; border: none; font-weight: 700; cursor: pointer; font-size: 16px; border-radius: 2px; }
.cancel-btn { background: #888; color: #fff; padding: 15px 30px; border: none; font-weight: 700; cursor: pointer; font-size: 16px; text-decoration: none; border-radius: 2px; margin-right: 10px; }
.small-add-btn { background: var(--fila-navy); color: #fff; border: none; padding: 5px 10px; cursor: pointer; font-size: 12px; }
.small-add-btn.added { background: #ccc; cursor: default; }
</style>
</head>
<body>
	<jsp:include page="../common/sidebar.jsp">
		<jsp:param name="currentPage" value="style" />
	</jsp:include>

	<div class="admin-section">
		<h3 class="section-title">스타일 정보 수정</h3>

		<form id="editForm">
			<%-- 스타일 ID --%>
			<input type="hidden" name="style_id" value="${style.style_id}">

			<table class="write-table">
				<tr>
					<th>스타일 명칭 *</th>
					<td><input type="text" name="style_name" value="${style.style_name}" style="width:100%; padding:10px; border:1px solid #ddd;" required></td>
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
									<c:if test="${img.is_main == 1}"><span class="main-badge">MAIN</span></c:if>
									<c:set var="safePath" value="${fn:replace(img.image_url, '\\\\', '/')}" />
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
							<option value="1" ${style.use_yn == 1 ? 'selected' : ''}>활성화</option>
							<option value="0" ${style.use_yn == 0 ? 'selected' : ''}>비활성화</option>
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
								<td>${p.productid}</td>
								<td style="text-align: left;"><strong>${p.name}</strong></td>
								<td><fmt:formatNumber value="${p.price}" pattern="#,###" />원</td>
								<td>${p.status}</td>
								<td>
									<button type="button" class="small-add-btn" 
										onclick="addProductTag('${p.productid}', '${p.name}')" id="btn-${p.productid}">추가</button>
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

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	$(document).ready(function() {
		// [수정 핵심] 페이지 로드 시 기존 매칭된 상품들을 태그로 자동 추가
		<c:forEach var="p" items="${productList}">
			<c:forEach var="mid" items="${matchedProductIds}">
				<c:if test="${mid eq p.productid}">
					addProductTag('${p.productid}', '${p.name}');
				</c:if>
			</c:forEach>
		</c:forEach>
	});

	// 1. 이미지 미리보기 로직
	function previewImages(input) {
		const container = $('#main-preview');
		container.empty();
		if (input.files && input.files.length > 0) {
			Array.from(input.files).forEach((file, index) => {
				const reader = new FileReader();
				reader.onload = function(e) {
					let badge = index === 0 ? '<span class="main-badge">MAIN</span>' : '';
					container.append(`<div class="preview-box">\${badge}<img src="\${e.target.result}"></div>`);
				}
				reader.readAsDataURL(file);
			});
		}
	}

	// 2. 상품 태그 추가 로직
	function addProductTag(id, name) {
		if ($(`#tag-\${id}`).length > 0) return; 

		$('#no-product-msg').hide();
		const tagHtml = `
			<div class="product-tag" id="tag-\${id}" data-id="\${id}">
				<span>\${name} (\${id})</span>
				<span class="btn-tag-del" onclick="removeProductTag('\${id}')">×</span>
			</div>
		`;
		$('#productTagContainer').append(tagHtml);
		$(`#btn-\${id}`).addClass('added').text('추가됨').prop('disabled', true);
	}

	function removeProductTag(id) {
		$(`#tag-\${id}`).remove();
		$(`#btn-\${id}`).removeClass('added').text('추가').prop('disabled', false);
		if ($('#productTagContainer .product-tag').length === 0) {
			$('#no-product-msg').show();
		}
	}

	// 3. Ajax 수정 제출
	$('#editForm').on('submit', function(e) {
		e.preventDefault();
		if(!confirm('수정된 내용을 저장하시겠습니까?')) return;

		let formData = new FormData(this);

		// 선택된 상품 태그들 수집
		$('#productTagContainer .product-tag').each(function() {
			formData.append("match_products", $(this).data('id'));
		});

		$.ajax({
			url: '${pageContext.request.contextPath}/admin/editStyle.htm',
			type: 'POST',
			data: formData,
			processData: false,
			contentType: false,
			success: function(res) {
				if(res.trim() === 'success') {
					alert('스타일 수정이 완료되었습니다.');
					location.href = '${pageContext.request.contextPath}/admin/styleList.htm';
				} else {
					alert('수정 실패');
				}
			},
			error: function() {
				alert('통신 오류');
			}
		});
	});
	</script>
</body>
</html>