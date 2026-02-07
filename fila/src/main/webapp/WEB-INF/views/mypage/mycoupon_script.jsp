<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
    // 마이페이지 전용 쿠폰 등록 스크립트
    jQuery(document).on("click", "#offlineBtn", function(){
        var val1 = jQuery("#offline").val();
        
        if (val1.trim() === "") {
            alert("쿠폰번호를 입력해 주세요");
            jQuery("#offline").focus();
            return;
        }

        jQuery.ajax({
            type: "POST",
            // 🚩 주소를 OrderController에 작성한 주소로 변경합니다.
            url: "${pageContext.request.contextPath}/order/coupon_process.htm",
            data: { "randomNo": val1 },
            /* 🚩 dataType: "JSON"을 제거하거나, 
               서버 응답을 res.trim()으로 체크하는 방식으로 변경 
            */
            success: function(res) {
                const result = res.trim();
                
                if(result === "success") {
                    alert("쿠폰이 정상적으로 등록되었습니다.");
                    location.reload(); // 성공 시 페이지 새로고침하여 목록 갱신
                } else if(result === "login_required") {
                    alert("로그인이 필요합니다.");
                    location.href = "${pageContext.request.contextPath}/member/login.htm";
                } else {
                    // 서버에서 보낸 에러 메시지("이미 등록된 쿠폰입니다" 등) 출력
                    alert(result);
                }
            },
            error: function(xhr) {
                alert("통신 중 오류가 발생했습니다. (상태코드: " + xhr.status + ")");
            }
        });
    });
</script>