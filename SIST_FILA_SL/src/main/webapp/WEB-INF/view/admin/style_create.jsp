<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA Admin - 스타일 등록</title>
<style>
/* 기존 FILA 브랜드 컬러 변수 및 레이아웃 유지 */
:root { --fila-navy: #00205b; --fila-red: #e31837; --bg-gray: #f4f4f4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--bg-gray); margin: 0; }
.admin-section { margin-left: 240px; padding: 50px 40px; min-height: 100vh; }
.section-title { font-size: 22px; font-weight: 800; color: var(--fila-navy); position: relative; padding-left: 15px; margin-bottom: 30px; }
.section-title::before { content: ''; position: absolute; left: 0; top: 50%; transform: translateY(-50%); width: 4px; height: 20px; background-color: var(--fila-red); }

/* 폼 및 테이블 공통 */
.write-table, .product-select-table { width: 100%; border-collapse: collapse; background: #fff; border-top: 2px solid var(--fila-navy); margin-bottom: 30px; }
.write-table th, .product-select-table th { background: #f9f9f9; padding: 15px; border-bottom: 1px solid #eee; text-align: left; font-size: 13px; }
.write-table td, .product-select-table td { padding: 12px 15px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 14px; }

/* 이미지 업로드 존 (Product Create 스타일) */
.photo-upload-zone { border: 2px dashed #ccc; padding: 30px; text-align: center; cursor: pointer; transition: 0.3s; background: #fff; }
.photo-upload-zone:hover { border-color: var(--fila-navy); background: #f0f4f9; }
.preview-container { display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap; }
.preview-box { width: 80px; height: 100px; border: 1px solid #eee; position: relative; }
.preview-box img { width: 100%; height: 100%; object-fit: cover; }

/* 선택된 상품 태그 */
.product-tag-container { display: flex; flex-wrap: wrap; gap: 10px; padding: 10px; background: #fdfdfd; border: 1px solid #eee; min-height: 50px; }
.product-tag { background: var(--fila-navy); color: #fff; padding: 5px 12px; border-radius: 2px; font-size: 12px; display: flex; align-items: center; }
.btn-tag-del { margin-left: 8px; cursor: pointer; font-weight: bold; }

/* 버튼 스타일 */
.submit-btn { background: var(--fila-navy); color: #fff; padding: 15px 50px; border: none; font-weight: 700; cursor: pointer; font-size: 16px; }
.small-add-btn { background: var(--fila-navy); color: #fff; border: none; padding: 5px 10px; cursor: pointer; font-size: 12px; }
.small-add-btn.added { background: #ccc; cursor: default; }
</style>
</head>
<body>
	<jsp:include page="../common/sidebar.jsp">
		<jsp:param name="currentPage" value="style" />
	</jsp:include>

	<div class="admin-section">
		<h3 class="section-title">신규 스타일 등록</h3>

		<form id="styleForm">
			<table class="write-table">
				<tr>
					<th>스타일 명칭 *</th>
					<td><input type="text" name="style_name" style="width:100%; padding:10px; border:1px solid #ddd;" required></td>
				</tr>
				<tr>
					<th>스타일 설명</th>
					<td><textarea name="description" style="width:100%; padding:10px; border:1px solid #ddd;" rows="3"></textarea></td>
				</tr>
				<tr>
					<th>화보 이미지 업로드 *</th>
					<td>
						<div class="photo-upload-zone" onclick="document.getElementById('styleImgs').click()">
							<span style="font-size:24px;">+</span><br>
							<span class="desc">클릭하여 화보 이미지 업로드 (첫 번째 이미지가 메인)</span>
							<input type="file" id="styleImgs" name="style_images" multiple style="display: none" onchange="previewImages(this)">
						</div>
						<div id="main-preview" class="preview-container"></div>
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
				<button type="submit" class="submit-btn">최종 스타일 등록</button>
			</div>
		</form>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	// 1. 이미지 미리보기 로직
	function previewImages(input) {
		const container = $('#main-preview');
		container.empty();
		if (input.files) {
			Array.from(input.files).forEach(file => {
				const reader = new FileReader();
				reader.onload = function(e) {
					container.append(`<div class="preview-box"><img src="\${e.target.result}"></div>`);
				}
				reader.readAsDataURL(file);
			});
		}
	}

	// 2. 상품 태그 추가 로직
	function addProductTag(id, name) {
		if ($(`#tag-\${id}`).length > 0) return; // 중복 방지

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

	// 3. Ajax 등록 (MultipartRequest)
	$('#styleForm').on('submit', function(e) {
		e.preventDefault();
		let formData = new FormData(this);

		// 선택된 상품 코드들 수집하여 FormData에 추가
		$('#productTagContainer .product-tag').each(function() {
			formData.append("match_products", $(this).data('id'));
		});

		$.ajax({
			url: '${pageContext.request.contextPath}/admin/createStyle.htm',
			type: 'POST',
			data: formData,
			processData: false,
			contentType: false,
			success: function(res) {
				alert('스타일 등록이 완료되었습니다.');
				location.href = '${pageContext.request.contextPath}/admin/styleList.htm';
			},
			error: function() {
				alert('등록 실패');
			}
		});
	});
	</script>
</body>
</html>