<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
$(document).ready(function() {
    // 모델컷 슬라이더
    if ($('.mc__slider').length > 0) {
        new Swiper('.mc__slider', {
            slidesPerView: 1,
            spaceBetween: 0,
            loop: ($('.mc__slider .swiper-slide').length > 1),
            pagination: {
                el: '.mc-swiper-pagination',
                clickable: true,
            },
            autoHeight: true,
            observer: true,
            observeParents: true
        });
    }
});

function openReviewModal() {
    var modal = document.getElementById("reviewModal");
    if(modal) {
        modal.style.display = "block";
        document.body.style.overflow = "hidden"; 
    } else {
        alert("모달창을 찾을 수 없습니다.");
    }
}

function closeReviewModal() {
    var modal = document.getElementById("reviewModal");
    if(modal) {
        modal.style.display = "none";
        document.body.style.overflow = "auto";
    }
}

$(document).ready(function() {
    // 1. 상세페이지에 있는 상품 ID 가져오기
    var productId = "${product.productId}" || new URLSearchParams(window.location.search).get('productId');
    
    if (productId) {
        console.log(">>> 상세페이지 리뷰 개수 동기화 시작: " + productId);
        
        // 2. 우리가 만든 리뷰 리스트 컨트롤러 호출 (요약 정보만 필요하니까)
        $.ajax({
            url: "${pageContext.request.contextPath}/review/list.htm",
            type: "GET",
            data: { productId: productId },
            dataType: "json",
            success: function(data) {
                if (data && data.reviewSummary) {
                    // 오라클 대문자 이슈 방어 (TOTAL_CNT vs total_cnt)
                    var count = data.reviewSummary.total_cnt || data.reviewSummary.TOTAL_CNT || 0;
                    
                    // 3. 0개라고 적힌 부분을 실제 개수로 변경
                    $(".crema-product-reviews-count").text(count);
                    console.log(">>> 리뷰 개수 업데이트 완료: " + count);
                }
            },
            error: function(xhr) {
                console.error(">>> 리뷰 개수 가져오기 실패");
            }
        });
    }
});
</script>

<script>
document.addEventListener("DOMContentLoaded", function () {
  var minusBtn = document.getElementById("qtyMinus");
  var plusBtn  = document.getElementById("qtyPlus");
  var qtyInput = document.getElementById("ProductQuantity");
  var totalEl  = document.getElementById("buytotal");

  // [확인] JSP에서 finalPrice가 넘어오는지 확인 필요
  var unitPrice = ${finalPrice}; 

  function renderTotal(qty) {
    if (!totalEl) return;
    var total = unitPrice * qty;
    totalEl.textContent = total.toLocaleString() + "원";
  }

  function getQty() {
    var v = parseInt(qtyInput.value, 10);
    return isNaN(v) || v < 1 ? 1 : v;
  }

  function setQty(v) {
    if (v < 1) v = 1;
    qtyInput.value = v;
    renderTotal(v);
  }

  if (minusBtn) {
    minusBtn.addEventListener("click", function () {
      setQty(getQty() - 1);
    });
  }

  if (plusBtn) {
    plusBtn.addEventListener("click", function () {
      setQty(getQty() + 1);
    });
  }

  setQty(getQty());
});
</script>

<script>
// 장바구니 담기
function goCartAdd() {
    // 1. 사이즈 선택 체크
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if (!sizeChecked) {
        alert("사이즈를 선택해 주세요");
        return;
    }

    // 2. 로그인 체크
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        // [수정] .htm 붙임
        location.href = "${pageContext.request.contextPath}/login.htm?returnUrl=" + encodeURIComponent(location.pathname + location.search);
        return;
    }

    // 3. 값 추출
    var qty = document.getElementById("ProductQuantity").value;
    var combiId = sizeChecked.value;

    // [수정] URL 하드코딩 권장 (변수로 받으면 꼬일 수 있음)
    // 주소 예시: /cart/add.htm
    location.href = "${pageContext.request.contextPath}/cart/add.htm"
        + "?quantity=" + encodeURIComponent(qty)
        + "&combinationId=" + encodeURIComponent(combiId);
}

// 바로 구매
function goBuyNow() {
    // 1. 사이즈 체크
    var sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    if (!sizeChecked) {
        alert("사이즈를 선택해 주세요");
        return;
    }
    var combinationId = sizeChecked.value;

    // 2. 수량
    var qtyInput = document.getElementById("ProductQuantity");
    var quantity = qtyInput ? qtyInput.value : 1;

    // 3. 로그인 체크
    var isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        alert("로그인이 필요한 서비스입니다.");
        location.href = "${pageContext.request.contextPath}/member/login.htm?returnUrl=" + encodeURIComponent(location.href);
        return;
    }

    // [수정] product.product_id -> product.productId (카멜케이스)
    var productId = "${product.productId}"; 
    
    // 4. 이동 (.htm 추가)
    location.href = "${pageContext.request.contextPath}/order/orderForm.htm" 
                 + "?productId=" + productId 
                 + "&quantity=" + quantity 
                 + "&combinationId=" + combinationId;
}
</script>

<script>
// 페이지 로드 시 초기 하트 상태 설정 (서버 데이터 기준)
window.addEventListener("pageshow", function(){
    var btn = document.getElementById("wishBtn");
    if(!btn) return;

    var serverWished = ${wished ? "true" : "false"};
    if(serverWished) {
        btn.classList.add("on");
    } else {
        btn.classList.remove("on");
    }
});

// 찜 버튼 클릭 핸들러 (통합본)
function goWishToggle(e) {
    if (e) {
        e.preventDefault();
        e.stopPropagation();
    }

    const btn = document.getElementById("wishBtn");
    if (!btn) return;
    
    // 로그인 체크
    const isLogin = ${empty sessionScope.auth ? "false" : "true"};
    if (!isLogin) {
        if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/login.htm?returnUrl=" + encodeURIComponent(location.pathname + location.search);
        }
        return;
    }

    // 상품 ID (data-wish 속성 사용 권장, 없으면 EL 사용)
    // [수정] EL 변수명 productId로 수정
    const productId = "${product.productId}";
    
    // 사이즈 텍스트 추출
    const sizeChecked = document.querySelector('input[name="ProductSize"]:checked');
    let sizeText = "";
    if (sizeChecked) {
        const label = document.querySelector('label[for="' + sizeChecked.id + '"]');
        sizeText = label ? label.textContent.trim() : "";
    }

    // ★ 찜 추가(OFF -> ON)할 때는 사이즈 필수 체크
    const isOn = btn.classList.contains("on");
    if (!isOn && !sizeChecked) {
        alert("사이즈를 선택해 주세요");
        return;
    }

    // 서버 요청 (.htm 추가)
    const url = "${pageContext.request.contextPath}/wishlist/toggle.htm";

    // 버튼 비활성화 (중복 클릭 방지)
    btn.disabled = true;

    fetch(url, {
        method: "POST",
        headers: {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"},
        // [수정] product_id -> productId (서버 DTO 변수명과 일치시킴)
        body: "productId=" + encodeURIComponent(productId)
            + "&sizeText=" + encodeURIComponent(sizeText)
    })
    .then(async (res) => {
        // 로그인 세션 만료 시
        if (res.status === 401) {
             location.href = "${pageContext.request.contextPath}/login.htm";
             return;
        }
        
        const text = await res.text();
        if (!res.ok) throw new Error(text);
        return JSON.parse(text);
    })
    .then((data) => {
        if (data.wished === true) {
            btn.classList.add("on");
        } else {
            btn.classList.remove("on");
        }
    })
    .catch((err) => {
        console.error(err);
        alert("처리 중 오류가 발생했습니다.\n" + err.message);
    })
    .finally(() => {
        btn.disabled = false;
    });
}
</script>