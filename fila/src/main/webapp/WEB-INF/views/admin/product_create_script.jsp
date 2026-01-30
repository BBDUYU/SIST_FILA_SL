<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
    let selectedCategories = new Map(); 
    let currentPath = { d1: "", d2: "" };

    // 이미지 미리보기
    function previewImages(input, previewId) {
        const preview = document.getElementById(previewId);
        const files = Array.from(input.files);
        console.log(input.id + "에 선택된 파일 개수: " + input.files.length);
        preview.innerHTML = "";
        if (input.files) {
            Array.from(input.files).forEach(file => {
                const reader = new FileReader();
                reader.onload = e => {
                    const img = document.createElement("img");
                    img.src = e.target.result;
                    preview.appendChild(img);
                };
                reader.readAsDataURL(file);
            });
        }
    }

    // 카테고리 필터링
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

    // 다중 카테고리 선택
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
        tagContainer.innerHTML = ""; inputContainer.innerHTML = "";
        
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
        if (selectedCategories.size === 0) { alert("카테고리를 최소 하나 이상 선택하세요."); return; }

        const formData = new FormData(form);

        $.ajax({
            url: form.action,
            type: 'POST',
            data: formData,
            processData: false, 
            contentType: false, 
            dataType: 'json',
            beforeSend: function() {
                $(".submit-btn").prop("disabled", true).text("등록 중...");
            },
            success: function(res) {
                if (res.status === "success") {
                    alert("상품 등록이 완료되었습니다.");
                    location.href = res.redirect; 
                } else {
                    alert("등록 실패: " + res.message);
                    $(".submit-btn").prop("disabled", false).text("상품 등록 완료");
                }
            },
            error: function(xhr, status, error) {
                console.error(error);
                alert("서버 통신 중 오류가 발생했습니다.");
                $(".submit-btn").prop("disabled", false).text("상품 등록 완료");
            }
        });
    }
	</script>