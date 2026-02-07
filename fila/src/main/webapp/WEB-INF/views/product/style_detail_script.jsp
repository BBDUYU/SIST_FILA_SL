<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
    $(document).ready(function() {
        // [추가] URL에서 id 파라미터가 있는지 확인
        const urlParams = new URLSearchParams(window.location.search);
        const styleId = urlParams.get('id');

        // [추가] id가 있다면 즉시 codiCart 함수를 실행하여 모달을 띄움
        if (styleId) {
            console.log("URL에서 Style ID 확인됨: " + styleId);
            codiCart(styleId);
        }
    });

    // 기존 codiCart 함수 (그대로 유지하되 ajax 파라미터만 살짝 보강)
    function codiCart(styleId) {
        $.ajax({
            url : "${pageContext.request.contextPath}/main/styleDetail.htm",
            type : "GET",
            data : { 
                "id" : styleId,
                "isAjax" : "true" // 핸들러가 확실히 Ajax임을 인지하게 함
            },
            dataType : "html",
            // 요청 헤더에 XMLHttpRequest를 명시적으로 추가 (isAjax 판단용)
            beforeSend: function(xhr) {
                xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
            },
            success : function(res) {
                $("#styleModalContent").html(res);
                $("#styleModalOverlay").css("display", "flex").show();
                $("body").css("overflow", "hidden");

                if (typeof Swiper !== 'undefined') {
                    // 모달 내 슬라이더 클래스명이 mc__slider인지 photo__slider인지 확인 후 적용
                    new Swiper(".mc__slider, .photo__slider", { 
                        observer: true,
                        observeParents: true,
                        pagination: { el: ".mc-swiper-pagination", clickable: true }
                    });
                }
            },
            error : function() { alert("정보를 불러오지 못했습니다."); }
        });
    }

    function closeModal() {
        $("#styleModalOverlay").hide();
        $("body").css("overflow", "auto");
        // [선택 사항] 모달 닫을 때 URL에서 id 파라미터 제거 (새로고침 시 모달 안뜨게)
        history.replaceState({}, null, location.pathname);
    }
    
    $(document).on("click", ".close__btn", function() {
        closeModal();
    });
</script>