<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 공지사항 상세</title>
<style>
:root { --fila-navy: #001E62; --fila-red: #E2001A; --fila-gray: #F4F4F4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--fila-gray); margin: 0; display: flex; }

.main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); }
.card { background: white; border: 1px solid #ddd; padding: 30px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }

/* 상세 테이블 스타일 */
.detail-table { width: 100%; border-top: 2px solid var(--fila-navy); border-collapse: collapse; margin-top: 20px; }
.detail-table th { background-color: #f9f9f9; border-bottom: 1px solid #ddd; padding: 15px; text-align: left; width: 150px; font-size: 14px; color: #333; }
.detail-table td { border-bottom: 1px solid #eee; padding: 15px; font-size: 14px; color: #666; }

/* 이미지 영역 */
.notice-img-box { margin-top: 20px; padding: 20px; background: #fafafa; border: 1px dashed #ddd; text-align: center; }
.notice-img-box img { max-width: 100%; height: auto; border: 1px solid #eee; }

/* 버튼 영역 */
.btn-area { margin-top: 30px; text-align: center; }
.btn { padding: 10px 25px; font-size: 14px; font-weight: bold; border-radius: 4px; cursor: pointer; border: none; margin: 0 5px; text-decoration: none; display: inline-block; }
.btn-list { background-color: #666; color: white; }
.btn-edit { background-color: var(--fila-navy); color: white; }
.btn-delete { background-color: var(--fila-red); color: white; }
</style>
</head>
<body>

    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="notice" />
    </jsp:include>

    <div class="main-content">
        <div class="card">
            <h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">
                공지사항 상세 정보
            </h2>
            <hr>

            <table class="detail-table">
                <tr>
                    <th>카테고리</th>
                    <td>${dto.category_name}</td>
                    <th>작성일</th>
                    <td><fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="3" style="font-weight: bold; color: #333; font-size: 16px;">${dto.title}</td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td colspan="3">${dto.created_id}</td>
                </tr>
                <tr>
                    <th>이미지 경로</th>
                    <td colspan="3"><code>${dto.image_url}</code></td>
                </tr>
            </table>

            <div class="notice-img-box">
                <p style="text-align: left; color: #888; font-size: 12px; margin-bottom: 10px;">[ 미리보기 ]</p>
                <c:choose>
                    <c:when test="${not empty dto.image_url}">
                        <img src="${dto.image_url}" alt="공지 이미지">
                    </c:when>
                    <c:otherwise>
                        <p style="padding: 50px 0; color: #ccc;">등록된 이미지가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="btn-area">
                <a href="noticeManage.htm" class="btn btn-list">목록으로</a>
                <a href="noticeEdit.htm?id=${dto.notice_id}" class="btn btn-edit">수정하기</a>
                <button type="button" class="btn btn-delete" onclick="deleteConfirm()">삭제하기</button>
            </div>
        </div>
    </div>

<script>
function deleteNotice() {
    if(confirm("이 공지사항을 정말로 삭제하시겠습니까?")) {
        // 경로에 공지사항 ID(id)가 포함되어야 핸들러가 인식합니다.
        location.href = "${pageContext.request.contextPath}/admin/noticeDelete.htm?id=${dto.notice_id}";
    }
}
</script>

</body>
</html>