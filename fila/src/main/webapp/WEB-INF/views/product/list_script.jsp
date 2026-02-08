<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
    $(document).ready(function(){
        if(typeof Swiper !== 'undefined') {
            new Swiper('.goods__slider', {
                slidesPerView: 4,
                spaceBetween: 10,
                freeMode: true,
                scrollbar: {
                    el: '.goods-slider-scrollbar',
                    draggable: true,
                },
            });
        }
    });
</script>

<script>
async function wishToggleFromList(e, btn) {
    // 1. 기본 동작(링크 이동 등) 막기
    e.preventDefault();
    e.stopPropagation();

    const CTX = "${pageContext.request.contextPath}";
    // 로그인 여부 확인 (JSP EL 사용)
    const IS_LOGIN = ${empty sessionScope.auth ? "false" : "true"};

    // 2. 비로그인 시 로그인 페이지로 이동
    if (!IS_LOGIN) {
        if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
            location.href = CTX + "/login.htm?returnUrl=" + encodeURIComponent(location.pathname + location.search);
        }
        return false;
    }

    // 3. 상품 ID 가져오기
    const productId = btn.getAttribute("data-wish");
    if (!productId) return false;

    try {
        // 중복 클릭 방지
        btn.disabled = true;

        // 4. 서버로 보낼 데이터 준비 (카멜케이스 적용: productId)
        const body = new URLSearchParams();
        body.append("productId", productId); // [수정] product_id -> productId
        body.append("from", "list");         // 리스트에서 요청함 표시

        // 5. 비동기 요청 (AJAX)
        // [수정] web.xml 설정에 맞춰 .htm 유지
        const res = await fetch(CTX + "/mypage/wish/toggle.htm", {
		  method: "POST",
		  headers: {
		    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
		  },
		  body: body.toString()
		});


        // 6. 응답 처리
        if (res.status === 401) { // 세션 만료 등
            location.href = CTX + "/login.htm?returnUrl=" + encodeURIComponent(location.pathname + location.search);
            return false;
        }

        const text = await res.text();
        let data;
        try {
            data = JSON.parse(text);
        } catch (err) {
            throw new Error("서버 응답 오류: " + text);
        }

        if (!res.ok) {
            alert("찜 처리 실패: " + (data.error || "알 수 없는 오류"));
            return false;
        }

        // 7. UI 변경 (하트 색칠하기/빼기)
        if (data.wished === true) {
            btn.classList.add("on");
        } else {
            btn.classList.remove("on");
        }

    } catch (err) {
        console.error(err);
        alert("에러가 발생했습니다.\n" + err.message);
    } finally {
        // 버튼 다시 활성화
        btn.disabled = false;
    }

    return false; // 중요: onclick="return ..." 에서 false를 반환해야 a태그 이동 등을 막음
}
</script>