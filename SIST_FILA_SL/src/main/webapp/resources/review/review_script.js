/* ============================================================= */
/* [Part 1] 리뷰 작성 모달 관련 기능 (글쓰기, 별점, 사진) */
/* ============================================================= */

// 1. 모달 열기
function openReviewModal() {
    const modal = document.getElementById('reviewWriteModal');
    if(modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden'; // 배경 스크롤 막기
    }
}

// 2. 모달 닫기
function closeReviewModal() {
    const modal = document.getElementById('reviewWriteModal');
    if(modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto'; // 스크롤 풀기
    }
}

// 3. 별점 클릭 (점수 매기기)
function setRating(score) {
    const scoreInput = document.getElementById('reviewScore');
    if(scoreInput) scoreInput.value = score; // hidden input 값 변경
    
    const stars = document.querySelectorAll('.review-star-rating .star-icon');
    const texts = ['아주 별로예요', '별로예요', '보통이에요', '좋아요', '아주 좋아요'];
    
    stars.forEach((star, index) => {
        if (index < score) {
            star.classList.add('on');
            star.innerText = '★';
        } else {
            star.classList.remove('on');
            star.innerText = '☆';
        }
    });

    const textEl = document.getElementById('scoreText');
    if(textEl) textEl.innerText = texts[score-1];
}

// 4. 이미지 미리보기
function previewImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            const imgEl = document.getElementById('imgPreview');
            const boxEl = document.getElementById('imgPreviewBox');
            if(imgEl) imgEl.src = e.target.result;
            if(boxEl) boxEl.style.display = 'flex';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// 5. 이미지 삭제
function deleteImage() {
    const fileInput = document.getElementById('reviewFile');
    if(fileInput) fileInput.value = "";
    
    const imgEl = document.getElementById('imgPreview');
    const boxEl = document.getElementById('imgPreviewBox');
    
    if(imgEl) imgEl.src = "";
    if(boxEl) boxEl.style.display = 'none';
}


/* ============================================================= */
/* [Part 2] 필터 관련 기능 (별점, 사이즈, 키, 몸무게 통합) */
/* ============================================================= */

// 1. 통합 토글 함수 (모든 필터 열고 닫기)
function toggleFilter(id, btn) {
    var el = document.getElementById(id);
    if(!el) return;

    // 현재 열려있는지 확인 (display:block 이거나 active 클래스가 있거나)
    var isOpen = (el.style.display === 'block') || el.classList.contains('active');
    
    // 일단 다른 열린 필터들 싹 닫기
    closeAllFilters();

    // 닫혀있던 거라면 열기
    if (!isOpen) {
        // (A) 별점 필터 같은 경우 (display 제어)
        if (el.classList.contains('filter-dropdown')) {
            el.style.display = 'block';
        } 
        // (B) 사이즈/통합 필터 같은 경우 (active 클래스 제어)
        else {
            el.classList.add('active');
        }

        // 버튼 화살표 돌리기 효과
        if(btn) btn.classList.add('active');
    }
}

// 2. 통합 닫기 함수
function closeFilter(id) {
    var el = document.getElementById(id);
    if(el) {
        el.style.display = 'none'; // 별점용
        el.classList.remove('active'); // 사이즈용
    }
    // 버튼 활성화 끄기
    var triggers = document.querySelectorAll('.filter-trigger, .uni-trigger');
    triggers.forEach(function(t){ t.classList.remove('active'); });
}

// 3. 전체 닫기 (바탕화면 클릭 시 등 사용)
function closeAllFilters() {
    // 별점 박스 닫기
    document.querySelectorAll('.filter-dropdown').forEach(function(box){ 
        box.style.display = 'none'; 
    });
    // 사이즈/통합 박스 닫기
    document.querySelectorAll('.uni-dropdown, .size-dropdown').forEach(function(box){ 
        box.classList.remove('active'); 
    });
    // 모든 버튼 화살표 원복
    document.querySelectorAll('.filter-trigger, .uni-trigger').forEach(function(t){ 
        t.classList.remove('active'); 
    });
}

// 4. 옵션 칩 선택 (사이즈, 키 등)
function selectChip(btn) {
    var parent = btn.parentElement; // 부모 컨테이너 (.uni-body)
    var siblings = parent.querySelectorAll('.uni-chip'); // 형제들 찾기

    siblings.forEach(function(sib) {
        sib.classList.remove('selected');
    });
    btn.classList.add('selected');
}

// 5. 초기화 (사이즈, 키 등)
function resetFilter(boxId) {
    var box = document.getElementById(boxId);
    var chips = box.querySelectorAll('.uni-chip');
    chips.forEach(function(chip){ chip.classList.remove('selected'); });
}

// 6. 적용 (사이즈, 키 등) - 닫기만 함 (나중에 DB검색 추가)
function applyFilterCommon(boxId) {
    closeAllFilters();
}

// 7. 별점 필터 적용 (체크박스 확인 및 텍스트 변경)
function applyStarFilter(boxId, title) {
    var box = document.getElementById(boxId);
    var checkboxes = box.querySelectorAll('input[type="checkbox"]');
    var checkedList = [];
    
    checkboxes.forEach(function(chk){
        if(chk.checked) {
            var label = chk.closest('label');
            var textSpan = label.querySelector('.txt');
            if(textSpan) checkedList.push(textSpan.innerText);
        }
    });

    // 버튼 텍스트 변경 로직
    var wrapper = box.closest('.filter-wrapper');
    if(wrapper) {
        var btnTextSpan = wrapper.querySelector('.filter-trigger .btn-txt');
        if(btnTextSpan) {
            if (checkedList.length === 0) {
                btnTextSpan.innerText = title;
                btnTextSpan.style.fontWeight = 'normal';
                btnTextSpan.style.color = '#333';
            } else if (checkedList.length === checkboxes.length) {
                btnTextSpan.innerText = title + ": 전체";
                btnTextSpan.style.fontWeight = 'bold';
                btnTextSpan.style.color = '#000';
            } else {
                btnTextSpan.innerText = title + ": " + checkedList.join(", ");
                btnTextSpan.style.fontWeight = 'bold';
                btnTextSpan.style.color = '#000';
            }
        }
    }
    closeFilter(boxId);
    searchReviews(); // DB 검색 호출
}

// 8. 별점 초기화
function resetStarFilter(boxId, title) {
    var box = document.getElementById(boxId);
    var checkboxes = box.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(function(chk){ chk.checked = false; });
    applyStarFilter(boxId, title); 
}

// [공통] 화면 빈 곳 클릭 시 닫기
window.addEventListener('click', function(e){
    // 필터 영역 내부가 아니면 모두 닫기
    if(!e.target.closest('.filter-wrapper') && !e.target.closest('.uni-filter-box')) {
        closeAllFilters();
    }
});

// [공통] DB 검색 (Ajax 껍데기)
function searchReviews() {
    console.log("DB 데이터 요청...");
}
