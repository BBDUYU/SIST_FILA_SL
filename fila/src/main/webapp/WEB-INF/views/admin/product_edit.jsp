<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>FILA Admin - 상품 수정</title>
<style>
:root {
	--fila-navy: #00205b;
	--fila-red: #e21836;
	--fila-white: #ffffff;
	--bg-gray: #f4f4f4;
	--border-color: #ddd;
}
/* 레이아웃 */
.admin-section { margin-left: 240px; padding: 50px 0; background-color: var(--bg-gray); min-height: 100vh; width: calc(100% - 240px); }
.section-title { border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 20px; font-size: 20px; font-weight: bold; color: var(--fila-navy); text-transform: uppercase; }
.input-group { margin-bottom: 25px; }
.input-group label { display: block; font-weight: bold; margin-bottom: 10px; font-size: 14px; color: #333; }
.f-input { width: 100%; padding: 12px; border: 1px solid #333 !important; font-size: 14px; box-sizing: border-box; background: #fff; }
.f-input:focus { border: 1.5px solid var(--fila-navy) !important; outline: none; }

/* 이미지 업로드 */
.upload-wrapper { background: #fff; padding: 20px; border: 1px solid var(--border-color); }
.photo-upload-zone { border: 2px dashed var(--border-color); padding: 25px; text-align: center; background: #fafafa; cursor: pointer; }
.preview-container { display: flex; gap: 8px; margin-top: 15px; flex-wrap: wrap; }
.preview-container .img-box { position: relative; width: 80px; height: 80px; }
.preview-container img { width: 100%; height: 100%; object-fit: cover; border: 1px solid #eee; }
.del-btn { position: absolute; top: -5px; right: -5px; background: var(--fila-red); color: #fff; width: 18px; height: 18px; border-radius: 50%; font-size: 12px; text-align: center; cursor: pointer; border: none; }

/* 카테고리 선택 */
.category-container { display: flex; gap: 10px; background: white; padding: 15px; border: 1px solid var(--border-color); }
.category-select { flex: 1; height: 160px; border: 1px solid #eee; overflow-y: auto; }
.cate-item { padding: 10px; cursor: pointer; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
.cate-item:hover { background-color: #f9f9f9; }
.cate-item.active { background-color: var(--fila-navy) !important; color: white !important; font-weight: bold; }
.cate-tag { background: var(--fila-red); color: #fff; padding: 6px 14px; border-radius: 4px; font-size: 12px; display: inline-flex; align-items: center; gap: 10px; margin-bottom: 5px; }

/* 옵션(스포츠/사이즈) */
.opt-list { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px; }
.opt-item { display: inline-flex; align-items: center; padding: 8px 15px; border: 1px solid #ddd; background: #fff; cursor: pointer; font-size: 13px; }
.opt-item:has(input:checked) { border-color: var(--fila-navy); background-color: #f0f4f9; color: var(--fila-navy); font-weight: bold; }

.submit-btn { width: 100%; height: 60px; background: var(--fila-navy); color: white; border: none; font-size: 18px; font-weight: bold; cursor: pointer; margin-top: 40px; }
</style>
</head>

<body>
	<div id="wrap" class="admin-section">
		<jsp:include page="../common/sidebar.jsp">
			<jsp:param name="currentPage" value="product" />
		</jsp:include>

		<form id="productForm" action="editProduct.htm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="product_id" value="${product.product_id}">
			
			<div id="contents" style="max-width: 1300px; margin: 0 auto; display: flex; gap: 40px;">

				<div style="flex: 1.4;">
					<h3 class="section-title">상품 비주얼 수정</h3>
					
					<div class="input-group">
						<label>메인 상품 이미지 (최대 13장)</label>
						<div class="upload-wrapper">
							<div class="photo-upload-zone" onclick="document.getElementById('mainImgs').click()">
								<span style="font-size:24px;">+</span><br><span class="desc">클릭하여 이미지 추가 업로드</span>
								<input type="file" id="mainImgs" name="mainImages[]" multiple style="display: none" onchange="previewImages(this, 'main-preview')">
							</div>
							<div id="main-preview" class="preview-container">
								<c:forEach items="${imageList}" var="img">
									<c:if test="${img.image_type eq 'MAIN'}">
										<div class="img-box" id="ex-img-${img.product_image_id}">
											<img src="${pageContext.request.contextPath}${img.image_url}">
											<input type="hidden" name="existing_image_ids" value="${img.product_image_id}">
											<button type="button" class="del-btn" onclick="markImageDelete('${img.product_image_id}',this)">×</button>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</div>
					</div>

					<div class="input-group">
						<label>모델컷 이미지 등록</label>
						<div class="upload-wrapper">
							<div class="photo-upload-zone" onclick="document.getElementById('modelImgs').click()">
								<span style="font-size:24px;">+</span><br><span class="desc">클릭하여 이미지 추가 업로드</span>
								<input type="file" id="modelImgs" name="modelImages[]" multiple style="display: none" onchange="previewImages(this, 'model-preview')">
							</div>
							<div id="model-preview" class="preview-container">
								<c:forEach items="${imageList}" var="img">
									<c:if test="${img.image_type eq 'MODEL'}">
										<div class="img-box" id="ex-img-${img.product_image_id}">
											<img src="${pageContext.request.contextPath}${img.image_url}">
											<input type="hidden" name="existing_image_ids" value="${img.product_image_id}">
											<button type="button" class="del-btn" onclick="markImageDelete('${img.product_image_id}',this)">×</button>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</div>
					</div>

					<div class="input-group">
						<label>상세 설명 하단 이미지</label>
						<div class="upload-wrapper">
							<div class="photo-upload-zone" onclick="document.getElementById('detailImgs').click()">
								<span style="font-size:24px;">+</span><br><span class="desc">클릭하여 이미지 추가 업로드</span>
								<input type="file" id="detailImgs" name="detailImages[]" multiple style="display: none" onchange="previewImages(this, 'detail-preview')">
							</div>
							<div id="detail-preview" class="preview-container">
								<c:forEach items="${imageList}" var="img">
									<c:if test="${img.image_type eq 'DETAIL'}">
										<div class="img-box" id="ex-img-${img.product_image_id}">
											<img src="${pageContext.request.contextPath}${img.image_url}">
											<input type="hidden" name="existing_image_ids" value="${img.product_image_id}">
											<button type="button" class="del-btn" onclick="markImageDelete('${img.product_image_id}',this)">×</button>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>

				<div style="flex: 1; background: #fff; padding: 30px; border: 1px solid var(--border-color); height: fit-content;">
					<h3 style="color: var(--fila-navy); border-bottom: 1px solid #eee; padding-bottom: 15px; margin-top:0;">상품 정보 수정</h3>

					<div class="input-group">
						<label>노출 카테고리 지정</label>
						<div class="category-container">
							<div class="category-select" id="depth1">
								<c:forEach items="${list}" var="c"><c:if test="${c.depth eq 1}"><div class="cate-item" onclick="filterCategory(2, '${c.category_id}', this)">${c.name}</div></c:if></c:forEach>
							</div>
							<div class="category-select" id="depth2">
								<c:forEach items="${list}" var="c"><c:if test="${c.depth eq 2}"><div class="cate-item" data-parent="${c.parent_id}" onclick="filterCategory(3, '${c.category_id}', this)" style="display: none;">${c.name}</div></c:if></c:forEach>
							</div>
							<div class="category-select" id="depth3">
								<c:forEach items="${list}" var="c"><c:if test="${c.depth eq 3}"><div class="cate-item" data-parent="${c.parent_id}" onclick="toggleCategory(this, '${c.category_id}')" style="display: none;">${c.name}</div></c:if></c:forEach>
							</div>
						</div>
						<div id="selected-tags" style="margin-top: 15px; display: flex; gap: 8px; flex-wrap: wrap; min-height: 35px;"></div>
						<div id="hidden-inputs"></div>
					</div>
					<div class="input-group" style="margin-top: 30px;">
					    <label>인기 태그 지정 (중복 선택 가능)</label>
					    <div class="opt-list" style="background: #fff; border: 1px solid var(--border-color); padding: 15px;">
					        <c:forEach items="${tagList}" var="c">
					            <c:if test="${c.category_id >= 4000 && c.category_id < 5000}">
					                <label class="opt-item tag-item">
									    <input type="checkbox" name="tag_ids" value="${c.category_id}" 
									        <c:forEach items="${productCategories}" var="pc">
									           <c:if test="${pc.CATEGORY_ID == c.category_id || pc.category_id == c.category_id}">
									                checked
									            </c:if>
									        </c:forEach>
									    > 
									    <span># ${c.name}</span>
									</label>
					            </c:if>
					        </c:forEach>
					        <c:if test="${empty tagList}">
					            <div style="font-size: 12px; color: #999;">등록된 태그가 없습니다. 태그 관리에서 먼저 등록해주세요.</div>
					        </c:if>
					    </div>
					</div>
					<div class="input-group">
						<label>상품 옵션 설정</label>
						<div style="background: #fff; border: 1px solid #333; padding: 20px;">
							<p style="font-size: 13px; font-weight: bold; margin-bottom: 10px;">스포츠 분류</p>
							<div class="opt-list">
							    <c:forEach items="${options}" var="entry">
							        <c:if test="${entry.key == 2}">
							            <c:forEach items="${entry.value}" var="opt">
							                <label class="opt-item">
							                    <input type="radio" name="sport_option" value="${opt.v_master_id}" ${product.sport_option_id == opt.v_master_id ? 'checked' : ''} required> 
							                    <span>${opt.value_name}</span>
							                </label>
							            </c:forEach>
							        </c:if>
							    </c:forEach>
							</div>
							<p style="font-size: 13px; font-weight: bold; margin-top: 20px; margin-bottom: 10px;">사이즈 <span id="size-target-name" style="color: var(--fila-red);"></span></p>
							<div id="size-area" class="opt-list">
							    <c:forEach items="${options}" var="entry">
							        <c:if test="${entry.key >= 4 && entry.key <= 8}">
							            <c:forEach items="${entry.value}" var="opt">
							                <label class="opt-item size-item m-${entry.key}" style="display: none;">
							                    <input type="checkbox" name="size_options" value="${opt.v_master_id}" 
							                    	<c:forEach items="${productSizes}" var="sId"><c:if test="${sId == opt.v_master_id}">checked</c:if></c:forEach>> 
							                    <span>${opt.value_name}</span>
							                </label>
							            </c:forEach>
							        </c:if>
							    </c:forEach>
							    <div id="size-placeholder" style="color: #999; font-size: 12px;">카테고리를 선택하면 사이즈 목록이 나타납니다.</div>
							</div>
						</div>
					</div>

					<div style="display: flex; gap: 15px;">
						<div class="input-group" style="flex: 1;">
							<label>스타일(룩북) 연결</label>
							<select name="styleId" class="f-input">
								<option value="0">-- 선택 안함 --</option>
								<c:forEach items="${styleList}" var="s"><option value="${s.styleId}" ${product.style_id == s.styleId ? 'selected' : ''}>${s.styleName}</option></c:forEach>
							</select>
						</div>
						<div class="input-group" style="flex: 1;">
							<label>이벤트 섹션 연결</label>
							<select name="sectionId" class="f-input">
								<option value="0">-- 선택 안함 --</option>
								<c:forEach items="${eventSectionList}" var="es"><option value="${es.sectionId}" ${product.section_id == es.sectionId ? 'selected' : ''}>${es.name}</option></c:forEach>
							</select>
						</div>
					</div>

					<div class="input-group"><label>제품명</label><input type="text" name="name" class="f-input" value="${product.name}" required></div>

					<div style="display: flex; gap: 10px;">
						<div class="input-group" style="flex: 1;"><label>판매가(원)</label><input type="number" name="price" class="f-input" value="${product.price}" required></div>
						<div class="input-group" style="flex: 0.7;"><label>할인율(%)</label><input type="number" name="discount_rate" class="f-input" value="${product.discount_rate}"></div>
						<div class="input-group" style="flex: 1;"><label>재고수량</label><input type="number" name="stock" class="f-input" value="${product.stock}" required></div>
					</div>

					<div class="input-group">
						<label>상품 상세 설명</label>
						<textarea name="description" class="f-input" style="height: 100px; resize: none;">${product.description}</textarea>
					</div>

					<button type="button" class="submit-btn" onclick="registProduct()">상품 수정 완료</button>
				</div>
			</div>
			<input type="hidden" id="gender_option_input" name="gender_option" value="${product.gender_option_id}">
		</form>
	</div>

<script>
    let selectedCategories = new Map(); 
    let currentPath = { d1: "", d2: "" };

    window.onload = function() {
        // 1. 기존 선택된 카테고리 태그들 복원
        <c:forEach items="${productCategories}" var="pc">
            <c:if test="${pc.category_id < 4000}">
                selectedCategories.set("${pc.category_id}", "${not empty pc.full_path ? pc.full_path : pc.name}");
            </c:if>
        </c:forEach>
        renderCategoryUI();
        
        // 2. 사이즈 영역 복원
        const gName = "${product.gender_name}"; 
        const cType = "${product.category_type}"; 
        restoreSizeDisplay(gName, cType);
    };

    function restoreSizeDisplay(gName, cType) {
        let targetId = null;
        if (cType && cType.includes("신발")) targetId = (gName === "KIDS") ? 8 : 7;
        else if (cType && cType.includes("의류")) {
            if (gName === "MALE") targetId = 4;
            else if (gName === "FEMALE") targetId = 5;
            else targetId = 6;
        }
        if (targetId) {
            document.getElementById('size-placeholder').style.display = 'none';
            document.querySelectorAll('.m-' + targetId).forEach(el => el.style.display = 'inline-flex');
        }
    }

    // 이미지 삭제 처리 (기존 이미지 박스 숨기기 및 ID 저장)
    function markImageDelete(imageId, btn) {
        if(confirm("이 이미지를 삭제하시겠습니까? (수정 완료 시 반영됩니다)")) {
            const imgBox = btn.closest('.img-box'); 
            if (imgBox) {
                // 기존 이미지 ID를 보내는 hidden input 제거 (서버에서 유지 목록에서 제외되도록)
                const existingInput = imgBox.querySelector('input[name="existing_image_ids"]');
                if(existingInput) existingInput.remove();
                
                imgBox.style.display = 'none';
            }

            // 서버로 보낼 삭제 대상 ID 리스트 추가
            const container = document.getElementById('hidden-inputs');
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "deleteImageIds"; 
            input.value = imageId;
            container.appendChild(input);
        }
    }

    function previewImages(input, previewId) {
        const preview = document.getElementById(previewId);
        const newItems = preview.querySelectorAll('.new-preview');
        newItems.forEach(item => item.remove());

        if (input.files) {
            Array.from(input.files).forEach(file => {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const div = document.createElement("div");
                    div.className = "img-box new-preview"; 
                    div.innerHTML = '<img src="' + e.target.result + '">';
                    preview.appendChild(div);
                };
                reader.readAsDataURL(file);
            });
        }
    }

    function filterCategory(nextDepth, parentId, element) {
        const name = element.innerText.trim();
        if (nextDepth === 2) {
            currentPath.d1 = name; currentPath.d2 = "";
            const gInput = document.getElementById('gender_option_input');
            if (name === "MALE") gInput.value = "20";
            else if (name === "FEMALE") gInput.value = "10";
            else if (name === "KIDS") gInput.value = "30";
            document.querySelectorAll('#depth2 .cate-item, #depth3 .cate-item').forEach(i => { i.style.display = 'none'; i.classList.remove('active'); });
        } else if (nextDepth === 3) {
            currentPath.d2 = name;
            document.querySelectorAll('#depth3 .cate-item').forEach(i => { i.style.display = 'none'; i.classList.remove('active'); });
        }
        const siblings = element.parentElement.querySelectorAll('.cate-item');
        siblings.forEach(s => s.classList.remove('active'));
        element.classList.add('active');

        const nextStepDiv = document.getElementById('depth' + nextDepth);
        if (nextStepDiv) {
            nextStepDiv.querySelectorAll('.cate-item').forEach(item => {
                if (item.getAttribute('data-parent') == parentId) item.style.display = 'block';
            });
        }
        if (nextDepth === 3) handleSizeDisplay(element);
    }

    function toggleCategory(element, id) {
        const d3Name = element.innerText.trim();
        const fullPath = currentPath.d1 + " > " + currentPath.d2 + " > " + d3Name;
        if (selectedCategories.has(id)) { alert("이미 선택된 카테고리입니다."); return; }
        selectedCategories.set(id, fullPath);
        element.classList.add('active');
        renderCategoryUI();
    }

    function renderCategoryUI() {
        const tagContainer = document.getElementById('selected-tags');
        const inputContainer = document.getElementById('hidden-inputs');
        // 기존 카테고리 input만 삭제
        inputContainer.querySelectorAll('input[name="category_ids"]').forEach(i => i.remove());
        tagContainer.innerHTML = ""; 
        selectedCategories.forEach((path, id) => {
            const tag = document.createElement('div');
            tag.className = 'cate-tag';
            tag.innerHTML = path + ' <span onclick="removeCategory(\'' + id + '\')" style="cursor:pointer; font-weight:bold; margin-left:5px;">×</span>';
            tagContainer.appendChild(tag);
            const input = document.createElement('input');
            input.type = "hidden"; input.name = "category_ids"; input.value = id;
            inputContainer.appendChild(input);
        });
    }

    function removeCategory(id) {
        selectedCategories.delete(id);
        renderCategoryUI();
    }

    function handleSizeDisplay(element) {
        const d1Active = document.querySelector('#depth1 .cate-item.active');
        if(!d1Active) return;
        const d1Text = d1Active.innerText.trim();
        const d2Text = element.innerText.trim();
        document.getElementById('size-placeholder').style.display = 'none';
        document.querySelectorAll('.size-item').forEach(el => el.style.display = 'none');
        let targetId = null;
        if (d2Text.includes("신발")) targetId = (d1Text === "KIDS") ? 8 : 7;
        else if (d2Text.includes("의류")) {
            if (d1Text === "MALE") targetId = 4;
            else if (d1Text === "FEMALE") targetId = 5;
            else targetId = 6;
        }
        if (targetId) {
            document.getElementById('size-target-name').innerText = "[" + d1Text + " " + d2Text + " 사이즈]";
            document.querySelectorAll('.m-' + targetId).forEach(el => el.style.display = 'inline-flex');
        }
    }

    function registProduct() {
        const form = document.getElementById("productForm");
        if (!form.name.value) { alert("제품명을 입력하세요."); form.name.focus(); return; }

        const formData = new FormData(form);

        $.ajax({
            url: form.action,
            type: 'POST',
            data: formData,
            processData: false, 
            contentType: false, 
            dataType: 'json',
            beforeSend: function() {
                $(".submit-btn").prop("disabled", true).text("수정 중...");
            },
            success: function(res) {
                if (res.status === "success") {
                    alert("상품 정보가 수정되었습니다.");
                    location.href = res.redirect;
                } else {
                    alert("수정 실패: " + (res.message || "알 수 없는 오류"));
                    $(".submit-btn").prop("disabled", false).text("상품 수정 완료");
                }
            },
            error: function() {
                alert("서버 통신 중 오류가 발생했습니다.");
                $(".submit-btn").prop("disabled", false).text("상품 수정 완료");
            }
        });
    }
</script>
</body>
</html>