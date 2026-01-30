<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
    jQuery(document).on("click", "#offlineBtn", function(){
        var val1 = jQuery("#offline").val();
        
        if (val1.trim() === "") {
            alert("쿠폰번호를 입력해 주세요");
            jQuery("#offline").focus();
            return;
        }

        jQuery.ajax({
            type: "POST",
            data: { "randomNo": val1 },
            url: "${pageContext.request.contextPath}/mypage/coupon_process.htm",
            dataType : "JSON",
            success: function(res) {
                if(res.message) {
                    alert(res.message);
                }
                
                if(res.status === "success") {
                    location.reload();
                }
            },
            error: function(e) {
                alert("통신 중 오류가 발생했습니다.");
            }
        });
    });
</script>