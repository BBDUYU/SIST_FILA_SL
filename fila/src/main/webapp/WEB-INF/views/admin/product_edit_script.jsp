<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
    let selectedCategories = new Map(); 
    let currentPath = { d1: "", d2: "" };

    window.onload = function() {
        // 1. 기존 선택된 카테고리 태그들 복원
        <c:forEach items="${productCategories}" var="pc">
            <c:if test="${pc.categoryId < 4000}">
                selectedCategories.set("${pc.categoryId}", "${not empty pc.fullPath ? pc.fullPath : pc.name}");
            </c:if>
        </c:forEach>
        renderCategoryUI();
        
        // 2. 사이즈 영역 복원
        const gName = "${product.genderName}"; 
        const cType = "${product.categoryType}"; 
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