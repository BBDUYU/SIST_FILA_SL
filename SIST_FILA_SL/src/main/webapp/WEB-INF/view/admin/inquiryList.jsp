<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 1:1 문의 관리</title>
<style>
    :root {
        --fila-navy: #001E62;
        --fila-red: #E2001A;
        --fila-gray: #f8f9fa;
        --border-color: #dee2e6;
    }

    body { font-family: 'Noto Sans KR', sans-serif; background-color: #f4f6f9; margin: 0; display: flex; }

    /* 메인 레이아웃 */
    .main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); box-sizing: border-box; }
    .card { background: #fff; padding: 30px; border-radius: 4px; border: 1px solid var(--border-color); box-shadow: 0 2px 4px rgba(0,0,0,0.05); }

    /* 리스트 테이블 */
    .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .table th { background-color: var(--fila-navy); color: white; padding: 14px; }
    .table td { padding: 14px; border-bottom: 1px solid var(--border-color); text-align: center; }

    /* 상태 배지 */
    .status-badge { padding: 4px 10px; font-size: 11px; font-weight: bold; border-radius: 2px; }
    .status-wait { background: #fff1f0; color: var(--fila-red); border: 1px solid #ffa39e; }
    .status-done { background: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; }

    .btn-toggle { background: white; border: 1px solid #ccc; padding: 6px 12px; cursor: pointer; }

    /* --- [핵심] 2단 분할 답변 영역 --- */
    .reply-row { display: none; }
    
    .reply-box { 
        background-color: #fcfcfc !important; 
        padding: 30px !important; 
    }

    /* 좌우 배치를 위한 컨테이너 */
    .qa-split-container {
        display: flex;
        width: 100%;
        max-width: 1300px;
        margin: 0 auto;
        gap: 20px; /* 좌우 박스 간격 */
    }

    /* 좌측 문의 / 우측 답변 공통 섹션 */
    .qa-part {
        flex: 1; /* 반반씩 나눠 가짐 */
        background: white;
        border: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
    }

    .qa-header {
        padding: 12px 15px;
        font-size: 13px;
        font-weight: bold;
        background-color: #f8f9fa;
        border-bottom: 1px solid var(--border-color);
    }
    .header-q { color: var(--fila-red); border-top: 3px solid var(--fila-red); }
    .header-a { color: var(--fila-navy); border-top: 3px solid var(--fila-navy); }

    .qa-body {
        padding: 20px;
        min-height: 200px;
        font-size: 14px;
        line-height: 1.6;
        text-align: left; /* 내용 정렬 */
    }

    /* 입력창 및 버튼 */
    .reply-textarea {
        width: 100%;
        height: 150px;
        padding: 12px;
        border: 1px solid #ddd;
        box-sizing: border-box;
        font-family: inherit;
        resize: none;
    }

    .btn-submit {
        background: var(--fila-navy);
        color: white;
        border: none;
        padding: 10px 25px;
        font-weight: bold;
        cursor: pointer;
        margin-top: 10px;
        float: right;
    }
    /* 5. 답변 펼치기 행 */
.reply-row { display: none; } /* 초기값 */

.reply-box { 
    background-color: #fcfcfc !important; 
    padding: 30px !important; 
    /* width: 100%를 주지 마세요. td는 colspan이 해결합니다. */
}

.qa-split-container {
    display: flex;
    width: 100%;       /* 전체 너비 사용 */
    max-width: 100%;    /* 테이블 칸을 꽉 채우도록 */
    margin: 0; 
    gap: 20px;
}
</style>
</head>
<body>

    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="inquiry" />
    </jsp:include>

    <div class="main-content">
        <div class="card">
            <h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">1:1 문의 관리</h2>
            <p style="color: #666; font-size: 14px;">고객의 문의사항을 확인하고 답변을 등록합니다.</p>
            <hr>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>카테고리</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="qna" items="${adminQnaList}">
                        <tr>
                            <td>${qna.inquiry_id}</td>
                            <td><span style="color: #888;">${qna.category_name}</span></td>
                            <td style="text-align: left;"><strong>${qna.title}</strong></td>
                            <td>${qna.user_name}</td>
                            <td><fmt:formatDate value="${qna.created_at}" pattern="yyyy-MM-dd" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${qna.status eq 'WAIT'}">
                                        <span class="status-badge status-wait">답변대기</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-done">답변완료</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button class="btn-toggle" onclick="toggleReply('${qna.inquiry_id}')">보기/답변</button>
                            </td>
                        </tr>
                       <tr id="replyRow_${qna.inquiry_id}" class="reply-row">
    <td colspan="7" class="reply-box">
        <div class="qa-split-container">
            
            <div class="qa-part">
                <div class="qa-header header-q">CUSTOMER QUESTION</div>
                <div class="qa-body">
                    ${qna.content}
                </div>
            </div>

            <div class="qa-part">
                <div class="qa-header header-a">
                    ADMIN ANSWER
                    <c:if test="${qna.status ne 'WAIT'}">
                        <span style="float:right; font-weight:normal; font-size:11px; color:#888;">
                            답변완료: <fmt:formatDate value="${qna.reply_at}" pattern="yyyy-MM-dd HH:mm" />
                        </span>
                    </c:if>
                </div>
                <div class="qa-body">
                    <c:choose>
                        <c:when test="${qna.status eq 'WAIT'}">
                            <textarea id="text_${qna.inquiry_id}" class="reply-textarea" 
                                      placeholder="고객 문의에 대한 답변을 입력하세요."></textarea>
                            <div style="overflow: hidden;">
                                <button class="btn-submit" onclick="submitReply('${qna.inquiry_id}')">답변 완료</button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            ${qna.reply_content}
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
        </div>
    </td>
</tr>
                    </c:forEach>

                    <c:if test="${empty adminQnaList}">
                        <tr>
                            <td style="padding: 100px 0; color: #999;">새로운 문의 사항이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

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
</body>
</html>