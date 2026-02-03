<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	$(document).ready(function() {
		// [수정 핵심] 페이지 로드 시 기존 매칭된 상품들을 태그로 자동 추가
		<c:forEach var="p" items="${productList}">
			<c:forEach var="mid" items="${matchedProductIds}">
				<c:if test="${mid eq p.productId}">
					addProductTag('${p.productId}', '${p.name}');
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