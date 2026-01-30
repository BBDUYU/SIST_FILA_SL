<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 폰트 및 공통 설정 */
    .common__layer { font-family: 'Noto Sans KR', sans-serif; }
    
    /* 배경 (어둡게) */
    .common__layer .layer-bg__wrap {
        position: absolute; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5);
    }

    /* 공통 Inner (박스) */
    .common__layer .inner {
        position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
        background: #fff; display: flex; flex-direction: column;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }

    /* ============================================================ */
    /* [1] 리스트 모달 (건들지 않음!) - _review 클래스 스타일 따름 */
    /* ============================================================ */
    #qnaListModal { z-index: 9990; }
    /* 너비/높이 설정 제거함 -> _review 클래스 본연의 크기(더 큰 크기)로 나옴 */


    /* ============================================================ */
    /* [2] 작성 모달 (두 번째 창) - 900px 고정 + 사진 속 디자인 구현 */
    /* ============================================================ */
    #qnaWriteModal { z-index: 9999; }
    #qnaWriteModal .inner {
        width: 900px !important; /* 님이 원하시는 그 900 크기 */
        height: auto;
        max-height: 95vh;
    }

    /* 헤더 (상품문의하기 + X버튼) */
    .write-head {
        display: flex; justify-content: space-between; align-items: center;
        padding: 25px 40px; border-bottom: none; /* 헤더 밑줄 없음 */
    }
    .write-head h3 { font-size: 20px; font-weight: 700; color: #000; margin: 0; }
    
    /* 닫기 버튼 */
    .btn-close-x {
        width: 24px; height: 24px; background: none; border: 0; cursor: pointer; position: relative;
    }
    .btn-close-x::before, .btn-close-x::after {
        content:''; position: absolute; top: 50%; left: 50%; width: 2px; height: 24px; background: #000;
    }
    .btn-close-x::before { transform: translate(-50%, -50%) rotate(45deg); }
    .btn-close-x::after { transform: translate(-50%, -50%) rotate(-45deg); }

    /* 상품 정보 영역 */
    .write-goods-info {
        display: flex; align-items: flex-start; gap: 15px; 
        margin: 0 40px 20px; padding-bottom: 20px; 
        border-bottom: 1px solid #000; /* 진한 밑줄 */
    }
    .write-goods-info img { width: 50px; height: 50px; object-fit: cover; border-radius: 2px; }
    .write-goods-info .g-txt1 { font-size: 14px; font-weight: 700; color: #000; margin-bottom: 4px; }
    .write-goods-info .g-txt2 { font-size: 12px; color: #999; }

    /* 폼 공통 */
    #qnaForm select, #qnaForm input[type="text"], #qnaForm textarea {
        width: 100%; box-sizing: border-box; 
        border: 1px solid #ddd; border-radius: 4px; 
        padding: 12px 15px; font-size: 14px; outline: none;
    }
    #qnaForm select { height: 50px; margin-bottom: 15px; color: #333; }
    #qnaForm textarea { height: 180px; resize: none; margin-bottom: 15px; border-color:#ddd; }
    
    /* 안내 링크 등 */
    .guide-txt { font-size: 12px; color: #000; margin-bottom: 5px; }
    .guide-link { font-size: 12px; color: #666; text-decoration: underline; cursor: pointer; display: inline-block; margin-bottom: 25px; }
    
    /* 개인정보 동의 섹션 (사진이랑 똑같이) */
    .privacy-tit { font-size: 14px; font-weight: 700; color: #000; margin: 30px 0 15px; }
    .privacy-list { font-size: 12px; color: #000; line-height: 1.6; margin-bottom: 20px; }
    .privacy-desc { font-size: 12px; color: #999; margin-bottom: 20px; }

    /* ★ 동의 버튼 그룹 (사진 속 둥근 버튼 2개) ★ */
    .agree-btn-group { display: flex; gap: 10px; width: 100%; }
    .agree-radio-item { flex: 1; position: relative; }
    .agree-radio-item input[type="radio"] { position: absolute; opacity: 0; width: 100%; height: 100%; cursor: pointer; z-index: 2; }
    
    /* 버튼 모양 라벨 */
    .agree-label {
        display: block; width: 100%; padding: 18px 0; text-align: center;
        border: 1px solid #ddd; border-radius: 50px; /* 둥근 알약 모양 */
        background: #fff; color: #999; font-size: 14px; transition: all 0.2s;
    }
    
    /* 체크되었을 때 스타일 (검은 테두리 + 검은 글씨) */
    .agree-radio-item input[type="radio"]:checked + .agree-label {
        border-color: #000; color: #000; font-weight: 700;
    }

    /* 하단 푸터 (남색 바) */
    .write-foot {
        background: #002053; height: 80px; width: 100%;
        display: flex; justify-content: space-between; align-items: center;
        padding: 0 40px; box-sizing: border-box; margin-top: auto;
    }
    .write-foot button { background: none; border: none; color: #fff; cursor: pointer; opacity: 0.9; }
    .write-foot {
    background: #002053; 
    width: 100%;
    display: flex; justify-content: space-between; align-items: center;
    padding: 25px 30px; 
    
    box-sizing: border-box; 
    margin-top: auto; 
    flex-shrink: 0;
    border-bottom-left-radius: inherit; 
    border-bottom-right-radius: inherit;
}
    .btn-cancel { font-size: 15px; font-weight: 400; }
    .btn-submit { font-size: 16px; font-weight: 700; }

    /* 스크롤바 숨김 */
    .con::-webkit-scrollbar { display: none; }
    
    /* [이메일 수신 동의] 커스텀 체크박스 스타일 */
.custom-check-wrap { margin-bottom: 30px; display: flex; align-items: center; }

/* 1. 원래 못생긴 체크박스는 숨김 */
.custom-check-wrap input[type="checkbox"] { display: none; }

/* 2. 라벨 디자인 */
.custom-check-label {
    position: relative; cursor: pointer;
    display: flex; align-items: center;
    font-size: 13px; font-weight: 700; color: #000;
}

/* 3. [체크 안 했을 때] 박스 만들기 */
.custom-check-label::before {
    content: '';
    width: 18px; height: 18px;
    border: 1px solid #ddd;
    background: #fff;
    margin-right: 8px;
    box-sizing: border-box;
    transition: all 0.2s;
    border-radius: 3px;
}

/* 4. [체크 했을 때] 검은 배경 + 흰색 체크 아이콘 */
.custom-check-wrap input[type="checkbox"]:checked + .custom-check-label::before {
    border-color: #000;
    background-color: #000;
    /* 흰색 체크 모양 아이콘 (SVG) */
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='M6 10l3 3l6-6'/%3e%3c/svg%3e");
    background-position: center;
    background-repeat: no-repeat;
    background-size: 12px;
}
</style>


<div class="common__layer _review" id="qnaListModal" style="display:none; z-index:9990;">
    <div class="layer-bg__wrap" onclick="closeQnaListModal()"></div>
    <div class="inner"> 
        <div class="head">
            <div class="goods-info">
                <div class="photo">
                    <img src="${not empty product.image_url ? product.image_url : '//filacdn.styleship.com/filaproduct2/data/productimages/a/1/FS253IP02F003_734.jpg'}" alt="상품이미지">
                </div>
                <div class="info">
                    <div><p class="txt1">${product.name != null ? product.name : '상품명'}</p></div>
                    <button type="button" class="qna-write__btn2" onclick="openQnaWriteModal()">문의하기</button>
                </div>
            </div>
            <button type="button" class="close__btn" onclick="closeQnaListModal()">close</button>
        </div>
        
        <div class="con" style="padding: 30px; flex:1; overflow-y:auto; -ms-overflow-style:none; scrollbar-width:none;">
            <div id="qnaListArea"></div>
        </div>
    </div>
</div>


<div class="common__layer _qna" id="qnaWriteModal" style="display:none;">
    <div class="layer-bg__wrap" onclick="closeQnaWriteModal()" style="background: rgba(0,0,0,0.6);"></div>
    
    <div class="inner"> 
        <div class="write-head">
            <h3>상품 문의하기</h3>
            <button type="button" class="btn-close-x" onclick="closeQnaWriteModal()"></button>
        </div>

        <div class="con" style="padding:10px 40px 30px; flex:1; overflow-y:auto; -ms-overflow-style:none; scrollbar-width:none;">
            <div style="display:flex; align-items:flex-start; gap:15px; padding-bottom:25px; border-bottom:1px solid #000; margin-bottom:25px;">
                <img src="${product.image_url}" style="width:50px; height:50px; object-fit:cover;">
                <div>
                    <p style="font-weight:bold; font-size:14px; margin-bottom:5px; margin-top:0;">${product.name}</p>
                    <p style="font-size:12px; color:#888; margin:0;">${product.product_id}</p>
                </div>
            </div>

            <form id="qnaForm">
                <input type="hidden" name="productId" value="${product.product_id}">
                
                <select name="qnaType">
                    <option value="">문의유형 선택</option>
                    <option value="재고/재입고">재고/재입고</option>
                    <option value="사이즈/상품규격">사이즈/상품규격</option>
                    <option value="소재/디자인/구성품">소재/디자인/구성품</option>
                    <option value="기타">기타</option>
                </select>

                <textarea name="qnaContent" placeholder="문의 내용을 입력해주세요...
휴대폰 번호, 주민등록번호와 같은 개인정보의
입력은 삼가해 주시기 바랍니다."></textarea>
                
                <p class="guide-txt">배송, 결제, 교환 / 반품에 관한 문의는 고객센터 1:1문의를 이용해 주세요.</p>
                <a class="guide-link">1:1 문의 바로가기</a>
                
                <p class="guide-txt">문의하신 내용에 대한 답변은 해당 상품의 상세페이지에서 확인하실 수 있습니다.</p>
                
                <input type="text" name="memberEmail" placeholder="이메일주소" value="${sessionScope.auth.email}" style="margin-bottom:10px;">
                
                <div class="custom-check-wrap">
				    <input type="checkbox" id="emailChk">
				    <label for="emailChk" class="custom-check-label">이메일로 답변받기 (선택)</label>
				</div>

                <p class="privacy-tit">개인정보 수집 동의</p>
                <div class="privacy-list">
                    1. 개인정보 수집 및 이용목적 : 이용자의 민원처리 답변사항 전달<br>
                    2. 개인정보 수집 항목 : 이메일<br>
                    <b>3. 개인정보 보유 이용 기간 : 전자상거래 등에서의 소비자 보호에 관한 법률 등에서 정한 보존기간 동안 고객님의 개인 정보를 보유합니다.<br>
                    소비자의 불만 또는 분쟁처리에 관한 기록:3년</b>
                </div>
                <p class="privacy-desc">개인정보 수집 및 이용에 대한 동의를 거부할 수 있으나, 동의를 거부하실 경우 1:1 문의에 대한 이메일 답변이 불가할 수 있습니다.</p>
                
                <div class="agree-btn-group">
                    <div class="agree-radio-item">
                        <input type="radio" name="privacy1" value="1" checked id="r_yes">
                        <label for="r_yes" class="agree-label">동의합니다</label>
                    </div>
                    <div class="agree-radio-item">
                        <input type="radio" name="privacy1" value="0" id="r_no">
                        <label for="r_no" class="agree-label">동의하지 않습니다</label>
                    </div>
                </div>
            </form>
        </div>

        <div class="write-foot">
            <button type="button" class="btn-cancel" onclick="closeQnaWriteModal()">취소</button>
            <button type="button" class="btn-submit" onclick="submitQnaAjax()">문의하기</button>
        </div>
    </div>
</div>

<script>
// [1] 리스트 모달 (첫번째 창)
function openQnaModal() {
    $('#qnaListModal').fadeIn(200);
    $('body').addClass('no-scroll');
    loadQnaList();
}
function closeQnaListModal() {
    $('#qnaListModal').fadeOut(200);
    $('body').removeClass('no-scroll');
}

// [2] 글쓰기 모달 (두번째 창 - 900px)
function openQnaWriteModal() {
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/login.htm";
        }
        return;
    }
    // 리스트는 그대로 두고 위에 띄움
    $('#qnaWriteModal').fadeIn(200);
}
function closeQnaWriteModal() {
    $('#qnaWriteModal').fadeOut(200);
}

// [3] 리스트 로드
function loadQnaList() {
    var pid = "${product.product_id}";
    $.ajax({
        url: "${pageContext.request.contextPath}/qna/list.htm",
        type: "GET",
        data: { product_id: pid },
        success: function(html) { $("#qnaListArea").html(html); }
    });
}

// [4] 등록 AJAX
// [4] 문의 등록 (AJAX)
function submitQnaAjax() {
    // 1. 문의 유형 확인
    var type = $("select[name='qnaType']").val();
    if (!type) { alert("문의 유형을 선택해주세요."); return; }
    
    // 2. 내용 입력 확인
    var content = $("textarea[name='qnaContent']").val();
    if (!content.trim()) { alert("문의 내용을 입력해주세요."); return; }
    
    // 3. [수정됨] 개인정보 동의 확인 (동의하지 않음 '0'일 때 멘트 변경)
    var privacy = $("input[name='privacy1']:checked").val();
    if (privacy === "0") { 
        alert("개인정보 수집에 동의해 주셔야 이메일로 답변받기가 가능합니다"); 
        return; 
    }

    // 4. 전송
    var formData = $("#qnaForm").serialize();
    $.ajax({
        url: "${pageContext.request.contextPath}/qna/insert.htm",
        type: "POST", data: formData,
        success: function() {
            alert("등록되었습니다.");
            closeQnaWriteModal(); 
            loadQnaList(); 
        },
        error: function(xhr, status, error) {
            // ★★★ 여기가 콘솔에 에러 찍는 부분입니다 ★★★
            console.error("==========================================");
            console.error("[QnA 등록 실패] 에러가 발생했습니다.");
            console.error("1. 상태 코드(status): " + xhr.status);
            console.error("2. 에러 메시지: " + error);
            console.error("3. 서버 응답 내용(responseText): " + xhr.responseText);
            console.error("==========================================");
            
            alert("등록 실패! F12(개발자도구) -> Console 탭에서 에러 내용을 확인해주세요.");
        }
    });
}
</script>