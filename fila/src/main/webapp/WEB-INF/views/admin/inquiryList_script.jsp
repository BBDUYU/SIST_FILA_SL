<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // 답변 영역 토글
		function toggleReply(id) {
		    const row = document.getElementById("replyRow_" + id);
		    if (row.style.display === "table-row") {
		        row.style.display = "none";
		    } else {
		        row.style.display = "table-row"; // block이 아니라 table-row여야 합니다!
		    }
		}

        // 답변 전송
        function submitReply(id) {
            const replyContent = $("#text_" + id).val();
            
            if(!replyContent.trim()) {
                alert("답변 내용을 입력해주세요.");
                return;
            }

            if(confirm("이 내용으로 답변을 등록하시겠습니까?")) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/answerAction.htm',
                    type: 'POST',
                    data: {
                        inquiryId: id,
                        content: replyContent
                    },
                    success: function(res) {
                        alert("답변이 정상적으로 등록되었습니다.");
                        location.reload();
                    },
                    error: function() {
                        alert("오류가 발생했습니다.");
                    }
                });
            }
        }
    </script>