<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	function CheckedBuy() {
	    let selectedItems = $(".item-chk:checked");
	    if (selectedItems.length === 0) {
	        alert("주문하실 상품을 선택해주세요.");
	        return;
	    }


	    let itemIds = [];
	    selectedItems.each(function() {

	        let id = $(this).closest('li').find('button.del').attr('onclick').replace(/[^0-9]/g, '');
	        itemIds.push(id);
	    });

	    location.href = contextPath + "/order/orderForm.htm?cartItemIds=" + itemIds.join(",");
	}
	
	
var contextPath = '${pageContext.request.contextPath}';

$(document).ready(function() {
    updateTotal();

    // 탭 전환 이벤트
    $(".odr-tab li a").click(function() {
        $(".odr-tab li a").removeClass("on");
        $(this).addClass("on");
        if($(this).attr("id") == "todayli") $(".todayinfo").show();
        else $(".todayinfo").hide();
    });

    // 전체 선택
    $("#checkAll").click(function() {
        $(".item-chk").prop("checked", this.checked);
        updateTotal();
    });

    // 개별 체크박스 클릭 시 전체선택 상태 및 금액 업데이트
    $(document).on("click", ".item-chk", function() {
        $("#checkAll").prop("checked", $(".item-chk:checked").length == $(".item-chk").length);
        updateTotal();
    });

    /* =========================
       옵션 변경 모달 관련 (AJAX)
       ========================= */
    // 옵션 변경 버튼 클릭 시
    $(document).on('click', '.option-change__btn', function (e) {
        e.preventDefault();
        // 버튼의 onclick 속성에서 ID를 가져오거나, $(this)를 이용할 수 있습니다.
        // 현재 HTML 구조상 onclick="changeOption(${item.cartItemId})" 이므로 해당 함수를 호출합니다.
    });
});

// 금액 업데이트 로직
function updateTotal() {
    let totalOrigin = 0;   // 총 상품금액 (할인 전)
    let totalSalePrice = 0; // 실제 판매가 합계
    let totalDiscount = 0;  // 총 할인금액
    let deliPrice = 0;     // 배송비

    $(".item-chk:checked").each(function() {
        let priceOri = parseInt($(this).data("priceori")) || 0;  
        let priceSale = parseInt($(this).data("pricesale")) || 0; 
        let qty = parseInt($(this).data("pq")) || 0;             

        totalOrigin += (priceOri * qty);
        totalSalePrice += (priceSale * qty);
    });

    totalDiscount = totalOrigin - totalSalePrice;
    deliPrice = (totalSalePrice > 0 && totalSalePrice < 30000) ? 3000 : 0;

    $("#ctPice").text(totalOrigin.toLocaleString());   
    $("#miPrice").text(totalDiscount.toLocaleString()); 
    $("#dvPrice").text(deliPrice.toLocaleString());    
    $("#pPrice").text((totalSalePrice + deliPrice).toLocaleString()); 
}

// 상품 단일 삭제
function deleteItem(id) {
    if(confirm("해당 상품을 삭제하시겠습니까?")) {
        location.href = contextPath + "/pay/cart.htm?ids=" + id;
    }
}

// AJAX 옵션 변경 모달 열기
function changeOption(cartItemId) {
    const $row = $('button[onclick*="changeOption(' + cartItemId + ')"]').closest('li');
    const detailHref = $row.find('.goods-thumb a').attr('href');
    const productId = detailHref.split('product_id=')[1]; 

    let currentSize = $row.find('.info p').eq(0).text().replace('사이즈', '').replace(':', '').trim();
    
    let currentQty = $row.find('.info p').eq(1).text().replace(/[^0-9]/g, '');

    console.log("전송 데이터:", { cartItemId, productId, currentSize, currentQty });

    $.ajax({
        // url을 .jsp에서 .htm으로 변경!
        url: contextPath + '/pay/cartOption.htm', 
        type: 'GET',
        data: { 
            cartItemId: cartItemId,
            productId: productId,
            size: currentSize,
            qty: currentQty
        },
        success: function (res) {
            $('#cartModalContent').html(res);
            $('#cartModalOverlay').css('display', 'flex').show();
            initQtyButtons(); 
        }
    });
}

// 모달 닫기
window.closeCartModal = function () {
    $('#cartModalOverlay').hide();
    $('#cartModalContent').empty();
    $('body').css('overflow', 'auto');
};

// 모달 내 닫기/취소 버튼 이벤트
$(document).on('click', '#cartModalOverlay .close__btn, #cartModalOverlay .cancel__btn', function () {
    closeCartModal();
});

// 배경 클릭 시 닫기
$(document).on('click', '#cartModalOverlay', function (e) {
    if (e.target === this) closeCartModal();
});

function initQtyButtons() {
    const $qtyInput = $('#ProductQuantityW');
    const priceVal = $('input[name="cartPrice"]').val();
    const unitPrice = parseInt(priceVal) || 0;

    // 플러스 버튼
    $('#qtyPlusW').off('click').on('click', function(e) {
        e.stopImmediatePropagation(); // order.js의 이벤트를 여기서 컷!
        let val = parseInt($qtyInput.val()) + 1;
        if (val > 99) val = 99; 
        $qtyInput.val(val);
        updateModalPrice(val, unitPrice);
    });

    // 마이너스 버튼
    $('#qtyMinusW').off('click').on('click', function(e) {
        e.stopImmediatePropagation(); // 중복 실행 방지
        let val = parseInt($qtyInput.val()) - 1;
        if (val < 1) val = 1; 
        $qtyInput.val(val);
        updateModalPrice(val, unitPrice);
    });
}

// 모달 내 합계 금액 업데이트
function updateModalPrice(qty, price) {
    const total = qty * price;
    // 천단위 콤마 포맷팅 후 반영
    $('#ctoprice').text(total.toLocaleString() + '원');
}
function cart_action3() {
    // 1. 모달 폼 데이터 가져오기
    const cartItemId = $('#form99 input[name="cartItemId"]').val();
    const productId = $('#form99 input[name="productId"]').val();
    const newSize = $('input[name="ProductSize_Cart"]:checked').val();
    const newQty = $('#ProductQuantityW').val();

    if (!newSize) {
        alert("변경하실 사이즈를 선택해주세요.");
        return;
    }

    if (confirm("선택하신 옵션으로 변경하시겠습니까?")) {
        // 핸들러 주소(/pay/cart.htm)와 액션 파라미터를 사용해 업데이트 요청
        // 프로젝트 구조에 따라 .htm 주소는 조정하세요.
        location.href = contextPath + "/pay/cart.htm?action=update" + 
                        "&cartItemId=" + cartItemId + 
                        "&size=" + encodeURIComponent(newSize) + 
                        "&qty=" + newQty;
    }
}
</script>