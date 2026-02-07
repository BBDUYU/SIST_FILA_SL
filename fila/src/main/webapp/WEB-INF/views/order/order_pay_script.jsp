<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function pay_checkout() {
    const addrId = $("#address_id").val();
    if (addrId == "0" || addrId == "") {
        alert("배송지 정보를 등록하거나 선택해 주세요.");
        return;
    }

    const paymentMethod = $("input[name='gopaymethod']:checked").val();
    if (!paymentMethod) {
        alert("결제 수단을 선택해 주세요.");
        return;
    }

    if (!confirm("정말로 결제하시겠습니까?")) return;

    // 🚩 AJAX 대신 일반 폼 전송 사용
    const form = document.forms['user'];
    form.action = "${pageContext.request.contextPath}/order/processOrder.htm";
    form.method = "POST";
    form.submit();
}

var contextPath = '${pageContext.request.contextPath}';

//1. 배송지 목록 모달 열기
function openAddressPopup() {
    $("#AddaddModalContent").load(contextPath + "/order/address_list.htm", function(response, status, xhr) {
        if (status == "error") {
            alert("배송지 목록을 불러오는데 실패했습니다: " + xhr.status);
        } else {
            $("#AddaddressModalOverlay").css('display', 'flex').show();
        }
    });
}

$(document).on('click', '.addr-add__btn', function() {
    console.log("신규 추가 버튼 클릭됨");
    
    // .jsp 직접 호출이 아니라 컨트롤러 매핑 주소 사용
    var targetUrl = contextPath + "/order/addAddressForm.htm"; 
    
    $("#AddaddModalContent").load(targetUrl, function(response, status, xhr) {
        if (status == "error") {
            console.log("에러 발생: " + xhr.status + " " + xhr.statusText);
            alert("신규 배송지 페이지를 불러올 수 없습니다. (에러코드: " + xhr.status + ")");
        } else {
            // 성공 시 혹시 모달이 안 보인다면 명시적으로 show
            $("#AddaddressModalOverlay").css('display', 'flex').show();
        }
    });
});

//3. 모달 닫기 공통
$(document).on('click', '.close__btn, .cbt', function() {
 $("#AddaddressModalOverlay").hide();
 $("#AddaddModalContent").empty();
});
$(document).on('click', '.addr__list li', function() {
    $(this).find('input[name="addr_select"]').prop('checked', true);
});
//4. 배송지 선택하기 (목록에서 라디오 버튼 등으로 선택했을 때)
function addr_choice() {
    var $selected = $("input[name='addr_select']:checked");
    if($selected.length == 0) {
        alert("배송지를 선택해주세요.");
        return;
    }
    
    // 데이터 추출
    var id = $selected.val();
    var name = $selected.data('name');
    var tel = $selected.data('tel');
    var zip = $selected.data('zip');
    var addr1 = $selected.data('addr1');
    var addr2 = $selected.data('addr2');

    // [수정 포인트] 모든 관련 hidden 필드를 한 번에 업데이트
    $("#address_id").val(id);           // 상단 영역 id
    $("#final_address_id").val(id);     // 하단 결제 버튼 영역 id
    
    // 배송지 정보 텍스트 업데이트
    $("#dName").text(name);
    $("#dTel").text(tel);
    $("#dAddr").text("(" + zip + ") " + addr1 + " " + addr2);

    // 상세 정보 hidden 필드들 업데이트 (DB 전송용)
    $("#orderName").val(name);
    $("input[name='OrderDTel21']").val(tel);
    $("input[name='OrderDZip']").val(zip);
    $("input[name='OrderDAddress1']").val(addr1);
    $("input[name='OrderDAddress2']").val(addr2);

    $("#AddaddressModalOverlay").hide();
}
</script>
<script>
//order_pay.jsp 하단 스크립트에 추가
$(document).on('click', '.coupon__btn', function() {
    $("#AddaddModalContent").load(contextPath + "/order/order_coupon.htm", function() {
        $.ajax({
            url: contextPath + "/order/api/mycoupon_ajax.htm", 
            type: "GET",
            dataType: "html", // 🚩 dataType을 html로 변경!
            success: function(resHtml) {
                // 서버에서 만든 <li> 태그들을 그대로 덮어씌움
                $(".coupon-select-box .cn ul").html(resHtml);
                
                $("#AddaddressModalOverlay").css('display', 'flex').show();
            },
            error: function() {
                alert("쿠폰 목록을 불러오는 중 오류가 발생했습니다.");
            }
        });
    });
});
//order_pay.jsp 하단 스크립트에 추가
function useCouponLayer() {
    const $selected = $("input[name='popupCoupon3']:checked");
    if ($selected.length === 0 || $selected.val() === "") {
        alert("적용할 쿠폰을 선택해주세요.");
        return;
    }

    const cpnName = $selected.data('name');
    const cpnType = $selected.data('type'); 
    const cpnVal = parseInt($selected.data('val'));
    const goodsPrice = parseInt("${totalSalePrice}"); 

    let discountPrice = 0;
    if (cpnType === 'PERCENT') {
        discountPrice = Math.floor(goodsPrice * (cpnVal / 100));
    } else if (cpnType === 'AMOUNT') {
        discountPrice = cpnVal;
    }

    // 1. 화면 업데이트
    $("#sale_total2").text(discountPrice.toLocaleString());
    $("#cpnName").text("[" + cpnName + "] 적용됨").show();
    
    // 🚩 2. 데이터 전송용 hidden 필드 처리 (수정됨)
    // input의 name을 OrderHandler가 받는 "userCouponId"와 완벽히 일치시킵니다.
    if ($("#userCouponId").length === 0) {
        // name="userCouponId"가 OrderHandler에서 받는 파라미터명입니다.
        $("form[name='user']").append('<input type="hidden" name="userCouponId" id="userCouponId" value="' + $selected.val() + '">');
    } else {
        $("#userCouponId").val($selected.val());
    }

    // 데이터가 잘 들어갔는지 콘솔에서 확인용
    console.log("선택된 쿠폰 ID:", $("#userCouponId").val());

    pay_change0();
    $("#AddaddressModalOverlay").hide();
}

// 쿠폰 등록 버튼 클릭 이벤트 (이벤트 위임 방식)
// 쿠폰 등록 버튼 클릭 이벤트
$(document).on('click', '#offlineBtn', function(e) {
    e.preventDefault();
    
    const serial = $("#coupon_serial_input").val();
    
    if(!serial || serial.trim() === "") { 
        alert("쿠폰 번호를 입력하세요."); 
        $("#coupon_serial_input").focus();
        return; 
    }

    $.ajax({
        url: contextPath + "/order/coupon_process.htm",
        type: "POST",
        data: { "randomNo": serial.trim() },
        /* dataType: "json" 은 절대 쓰지 마세요 */
        success: function(res) {
            // 서버에서 "success"라는 생 문자열이 오는지 확인
            // 앞뒤 공백 제거를 위해 trim()을 붙여주는 것이 안전합니다.
            const result = res.trim(); 
            
            if (result === "success") {
                alert("쿠폰이 등록되었습니다.");
                // 팝업 내의 쿠폰 리스트 새로고침 (아까 만든 HTML 조각 불러오기 함수 실행)
                loadCouponList(); 
            } else if (result === "login_required") {
                alert("로그인이 필요합니다.");
            } else {
                alert(result); // "이미 등록된 쿠폰입니다" 등의 메시지 출력
            }
        },
        error: function(xhr, status, error) { 
            console.error("Status:", status);
            console.error("Error:", error);
            console.error("Response:", xhr.responseText);
            alert("서버 통신 오류가 발생했습니다. (상태코드: " + xhr.status + ")"); 
        }
    });
});

// 쿠폰 리스트만 다시 그려주는 함수 (중복 코드 방지)
function loadCouponList() {
    $.ajax({
        url: contextPath + "/order/api/mycoupon_ajax.htm", 
        type: "GET",
        success: function(resHtml) {
            $(".coupon-select-box .cn ul").html(resHtml);
        }
    });
}
// 1. 초기 설정 변수 (서버 데이터 매핑)
const GOODS_TOTAL_PRICE = parseInt("${totalSalePrice}") || 0; // 할인 적용된 상품 총합
const MY_MAX_POINT = parseInt("${user.balance}") || 0;
// 2. 포인트 모두사용 버튼
function is_check0_ALL() {
    const $input = $("input[name='usemile']");
    const $btn = $(".point__btn");
    
    if ($btn.text() === "모두사용") {
        $input.val(MY_MAX_POINT);
        $btn.text("사용 취소");
    } else {
        $input.val(0);
        $btn.text("모두사용");
    }
    pay_change0(); // 금액 재계산
}

// 3. 포인트 입력 시 실시간 검증
function pointNumberVal(obj) {
    let inputVal = parseInt(obj.value.replace(/[^0-9]/g, '')) || 0;
    
    if (inputVal > MY_MAX_POINT) {
        alert("보유하신 포인트(" + MY_MAX_POINT.toLocaleString() + "P)까지만 사용 가능합니다.");
        obj.value = 0;
    } else if (inputVal > GOODS_TOTAL_PRICE) {
        alert("결제 금액을 초과하여 포인트를 사용할 수 없습니다.");
        obj.value = 0;
    }
    pay_change0();
}

// 4. 핵심: 결제 금액 및 배송비 재계산
// order_pay.jsp의 기존 pay_change0 함수들을 모두 지우고 이 하나로 통합하세요.
function pay_change0() {
    // 1. 상품 총액 (서버에서 가져온 값)
    let goodsPrice = parseInt("${totalSalePrice}") || 0;
    
    // 2. 포인트 사용액 (입력창 값)
    let usePoint = parseInt($("input[name='usemile']").val()) || 0;
    
    // 3. 쿠폰 할인액 (화면에 찍힌 텍스트에서 숫자만 추출)
    // replace(/[^0-9]/g, "")는 숫자 이외의 모든 문자(콤마 등)를 제거합니다.
    let couponDiscount = parseInt($("#sale_total2").text().replace(/[^0-9]/g, "")) || 0;
    
    // 4. 배송비 계산 (3만원 기준)
    let deliveryFee = (goodsPrice > 0 && goodsPrice < 30000) ? 3000 : 0;
    $("#transprice2").text(deliveryFee.toLocaleString());

    // 5. 최종 결제 금액 계산
    let finalPayPrice = goodsPrice - couponDiscount - usePoint + deliveryFee;
    
    // 마이너스 금액 방지
    if(finalPayPrice < 0) finalPayPrice = 0;

    // 6. 화면 업데이트
    $("#display_total_price").text(finalPayPrice.toLocaleString());
    
    // 7. 폼 전송용 히든 필드 업데이트
    $("#OrderTotalPrice").val(finalPayPrice); 
    
    // 디버깅용 로그 (개발자 도구 F12에서 확인 가능)
    console.log("계산로그 -> 상품가:", goodsPrice, "쿠폰:", couponDiscount, "포인트:", usePoint, "배송비:", deliveryFee, "최종:", finalPayPrice);
}
// 기존에 섞여있던 todayDeliveryCheck 함수가 배송비를 0으로 만들지 않게 주의해야 합니다.
function todayDeliveryCheck() {
    // 배송 방법 라디오 버튼 클릭 시에도 금액 재계산 호출
    pay_change0();
}

// 페이지 로드 시 초기 계산 실행
$(document).ready(function() {
    // 1. 서버에서 내려준 보유 포인트를 안전하게 가져오기
    var rawBalance = "${user.balance}";
    var balance = parseInt(rawBalance.replace(/[^0-9]/g, "")) || 0;
    
    // 2. 화면에 표시 (P 단위 포함)
    $("#usePoint").text(balance.toLocaleString());
    
    // 3. 내부 변수 업데이트 (포인트 모두사용 버튼 등에서 사용)
    window.MY_MAX_POINT = balance; 

    pay_change0(); // 초기 금액 계산 실행
});

//배송지 팝업에서 호출할 함수 (팝업 창에서 window.opener.setAddress(...) 로 호출하게 됨)
function setAddress(addrId, name, tel, zipcode, mainAddr, detailAddr) {
    // 1. 화면에 보이는 텍스트 변경
    $("#dName").text(name);
    $("#dTel").text(tel);
    $("#dAddr").text("(" + zipcode + ") " + mainAddr + " " + detailAddr);
    
    // 2. 서버로 전송할 hidden 값 변경
    $("#address_id").val(addrId); // 상단 배송지 정보 박스의 ID
    $("input[name='addressId']").val(addrId); 
    
    // 3. (필요 시) 하드코딩된 다른 필드들도 동기화
    $("#orderName").val(name);
    
    // 팝업 닫기 (오버레이 방식일 경우)
    $("#AddaddressModalOverlay").hide();
}

// 배송지 팝업 열기 함수
function openAddressPopup() {
    // Ajax로 address_list.htm 내용을 가져와서 모달에 넣거나, window.open 사용
    $.ajax({
        url: "${pageContext.request.contextPath}/order/address_list.htm",
        type: "GET",
        success: function(html) {
            $("#AddaddModalContent").html(html);
            $("#AddaddressModalOverlay").css("display", "flex");
        }
    });
}
</script>