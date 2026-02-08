<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 공지사항 상세</title>
<style>
/* 디자인 스타일 */
:root { --fila-navy: #001E62; --fila-red: #E2001A; --fila-gray: #F4F4F4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--fila-gray); margin: 0; display: flex; }
.main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); box-sizing: border-box; }
.card { background: white; border: 1px solid #ddd; padding: 30px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); border-radius: 8px; }

/* 테이블 스타일 */
.detail-table { width: 100%; border-top: 2px solid var(--fila-navy); border-collapse: collapse; margin-bottom: 20px; }
.detail-table th { background-color: #f9f9f9; border-bottom: 1px solid #eee; padding: 15px; text-align: left; width: 15%; font-weight: 600; color: #333; }
.detail-table td { border-bottom: 1px solid #eee; padding: 15px; color: #333; font-size: 14px; }

/* 이미지 박스 */
.notice-img-box { margin-top: 20px; padding: 20px; border: 1px solid #eee; background: #fff; text-align: center; }
.notice-img-box img { max-width: 80%; border: 1px solid #ddd; }

/* 버튼 영역 */
.btn-area { text-align: center; margin-top: 40px; border-top: 1px solid #eee; padding-top: 30px; }
.btn { border: none; padding: 10px 30px; cursor: pointer; font-size: 14px; font-weight: 500; border-radius: 4px; text-decoration: none; display: inline-block; }
.btn-list { background: #666; color: white; }
.btn-delete { background: var(--fila-red); color: white; margin-left: 10px; }
</style>

<script>
    // 삭제 확인 스크립트
    function deleteConfirm() {
        if(confirm('정말 삭제하시겠습니까?\n복구할 수 없습니다.')) {
            location.href = '${pageContext.request.contextPath}/admin/notice_delete.htm?id=${dto.noticeId}';
        }
    }
</script>
</head>
<body>

    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="pageName" value="notice" />
    </jsp:include>

    <div class="main-content"> 
        <div class="card">
            <h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">
                공지사항 상세 정보
            </h2>
            <hr style="border:0; border-top:1px solid #eee; margin-bottom: 20px;">

            <table class="detail-table">
                <tr>
                    <th>카테고리</th>
                    <td><span style="font-weight:bold; color:var(--fila-navy);">[${dto.categoryName}]</span></td>
                    <th>작성일</th>
                    <td><fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="3" style="font-weight: bold; font-size: 16px;">${dto.title}</td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td colspan="3">${dto.createdId}</td>
                </tr>
            </table>

            <div class="notice-img-box">
                <p style="text-align: left; color: #888; font-size: 12px; margin-bottom: 10px; font-weight:bold;">[ 본문 미리보기 ]</p>
                
                <c:choose>
                    <c:when test="${not empty dto.imageUrl}">
                        <c:choose>
                            <%-- 1. DB에 이미 '/displayImage.do' 주소가 포함되어 있다면? 그대로 출력 --%>
                            <c:when test="${fn:contains(dto.imageUrl, 'displayImage.do')}">
                                <img src="${dto.imageUrl}" alt="공지 이미지">
                            </c:when>
                            
                            <%-- 2. 파일명만 있다면? 주소를 만들어서 출력 --%>
                            <c:otherwise>
                                <c:url value="/displayImage.do" var="imgSrc">
                                    <c:param name="path" value="${dto.imageUrl}" />
                                </c:url>
                                <img src="${imgSrc}" alt="공지 이미지">
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <p style="padding: 50px 0; color: #ccc;">등록된 이미지가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="btn-area">
                <a href="${pageContext.request.contextPath}/admin/noticeManage.htm" class="btn btn-list">목록으로</a>
                <button type="button" class="btn btn-delete" onclick="deleteConfirm()">삭제하기</button>
            </div>
        </div>
    </div>

</body>
</html>