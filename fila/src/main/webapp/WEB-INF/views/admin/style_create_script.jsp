<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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