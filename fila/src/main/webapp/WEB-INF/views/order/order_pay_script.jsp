<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function pay_checkout() {
    // 배송지 체크
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

    const formData = $("form[name='user']").serialize();

    $.ajax({
        url: "${pageContext.request.contextPath}/order/processOrder.htm",
        type: "POST",
        data: formData,
        dataType: "json",
        success: function(res) {
            if (res.status === "success") {
                alert("주문이 완료되었습니다!");
                location.href = res.redirect;
            } else {
                alert("오류 발생: " + res.message);
            }
        },
        error: function() {
            alert("결제 처리 중 통신 오류가 발생했습니다.");
        }
    });
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

// 2. 신규 배송지 추가 모달 열기 (기존 코드 수정)
$(document).on('click', '.addr-add__btn', function() {
    console.log("신규 추가 버튼 클릭됨"); // 작동 여부 확인용
    var targetUrl = contextPath + "/view/mypage/add_address.jsp"; 
    
    $("#AddaddModalContent").load(targetUrl, function(response, status, xhr) {
        if (status == "error") {
            console.log("에러 발생: " + xhr.status + " " + xhr.statusText);
            alert("신규 배송지 페이지를 불러올 수 없습니다.");
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

 // 부모창(order_pay.jsp) 화면 업데이트
 $("#address_id").val(id);
 $("#dName").text(name);
 $("#dTel").text(tel);
 $("#dAddr").text("(" + zip + ") " + addr1 + " " + addr2);

 $("#AddaddressModalOverlay").hide();
}
</script>
<script>
//order_pay.jsp 하단 스크립트에 추가
$(document).on('click', '.coupon__btn', function() {
    // 1. 쿠폰 모달 레이아웃 로드
    $("#AddaddModalContent").load(contextPath + "/view/order/order_coupon.jsp", function() {
        
        // 2. 모달이 로드된 후 유저의 쿠폰 목록 AJAX 호출
        $.ajax({
            url: contextPath + "/api/mypage/mycoupon_ajax.htm", // 유저 쿠폰 목록을 JSON으로 주는 URL
            type: "GET",
            dataType: "json",
            success: function(data) {
                let html = "";
                if (data && data.length > 0) {
                    data.forEach(function(cpn) {
                        // 미사용(isused='0')인 쿠폰만 표시
                        if (cpn.isused === '0') {
                            // 금액 포맷팅 (JS 방식)
                            let priceText = (cpn.discount_type === 'PERCENT') 
                                            ? cpn.price + '%' 
                                            : cpn.price.toLocaleString() + '원';

                            html += '<li>';
                            html += '    <input type="radio" id="cpRd_' + cpn.usercouponid + '" name="popupCoupon3" ';
                            html += '           class="rd__style1" value="' + cpn.usercouponid + '" ';
                            html += '           data-name="' + cpn.coupon_name + '" ';
                            html += '           data-type="' + cpn.discount_type + '" ';
                            html += '           data-val="' + cpn.price + '">';
                            html += '    <label for="cpRd_' + cpn.usercouponid + '"></label>';
                            html += '    <div style="margin-left:40px;">';
                            html += '        <p class="txt1" style="font-weight:bold; color:#333;">' + cpn.coupon_name + '</p>';
                            html += '        <p class="txt2" style="color:#ff0000; font-size:13px;">' + priceText + ' 할인 쿠폰</p>';
                            html += '    </div>';
                            html += '</li>';
                        }
                    });
                }
                
                // 만약 사용 가능한 쿠폰이 하나도 없다면 기본 메시지 유지
                if(html !== "") {
                    $(".coupon-select-box .cn ul").html(html);
                }
            },
            error: function() {
                console.log("쿠폰 목록을 불러오는 중 오류가 발생했습니다.");
            }
        });
        
        $("#AddaddressModalOverlay").css('display', 'flex').show();
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
$(document).on('click', '#offlineBtn', function(e) {
    e.preventDefault();
    
    // 변경된 ID인 #coupon_serial_input으로 값을 가져옵니다.
    const serial = $("#coupon_serial_input").val();
    
    if(!serial || serial.trim() === "") { 
        alert("쿠폰 번호를 입력하세요."); 
        $("#coupon_serial_input").focus();
        return; 
    }

    $.ajax({
        url: contextPath + "/mypage/coupon_process.htm",
        type: "POST",
        data: { "randomNo": serial.trim() },
        dataType: "json",
        success: function(res) {
        	alert(res.message);
        	if (res.status === "success") {
                $(".coupon__btn").trigger('click'); 
            }
        },
        error: function() { 
            alert("유효하지 않은 쿠폰 번호입니다."); 
        }
    });
});
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
    pay_change0();
    $("#usePoint").text(MY_MAX_POINT.toLocaleString()); // 보유 포인트 표시 업데이트
});
</script>