<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 공지사항 관리</title>
<style>
:root { --fila-navy: #001E62; --fila-red: #E2001A; --fila-gray: #F4F4F4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--fila-gray); margin: 0; display: flex; }
.main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); }
.card { background: white; border: 1px solid #ddd; padding: 25px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); min-height: 600px; }
.list-table { width: 100%; border-top: 2px solid var(--fila-navy); border-collapse: collapse; margin-top: 20px; text-align: center; }
.list-table th { background-color: #f9f9f9; border-bottom: 1px solid #ddd; padding: 15px 10px; font-size: 14px; color: #333; font-weight: bold; }
.list-table td { border-bottom: 1px solid #eee; padding: 15px 10px; font-size: 14px; color: #666; }
.list-table tbody tr:hover { background-color: #f0f4ff; }
.link-title { color: #333; text-decoration: none; font-weight: 500; cursor: pointer; }
.td-subject { max-width: 400px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-align: left; padding-left: 20px; }

/* 추가: 작성하기 버튼 스타일 */
.btn-write {
    float: right;
    background-color: var(--fila-navy);
    color: white;
    padding: 10px 20px;
    text-decoration: none;
    font-size: 14px;
    border-radius: 4px;
    font-weight: bold;
}
.btn-write:hover { background-color: #001440; }
</style>
</head>
<body>
    
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="notice" />
    </jsp:include>

    <div class="main-content">
        <div class="card">
            <h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0; display: inline-block;">
                공지사항 관리
            </h2>
            
            <a href="${pageContext.request.contextPath}/admin/noticeWrite.htm" class="btn-write">공지사항 작성</a>
            
            <p style="color: #666; font-size: 14px;">브랜드 및 E-SHOP 공지사항을 관리하는 페이지입니다.</p>
            <hr>

            <table class="list-table">
                <thead>
                    <tr>
                        <th style="width: 8%;">번호</th>
                        <th style="width: 12%;">카테고리</th>
                        <th style="width: auto;">제목</th>
                        <th style="width: 10%;">작성자</th>
                        <th style="width: 15%;">작성일</th>
                        <th style="width: 10%;">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty noticeList}">
                            <c:forEach var="dto" items="${noticeList}">
                                <tr>
                                    <td>${dto.notice_id}</td>
                                    <td>
                                        <span style="color: #888;">[${dto.category_name}]</span>
                                    </td>
                                    <td class="td-subject">
                                        <a href="${pageContext.request.contextPath}/admin/noticeDetail.htm?id=${dto.notice_id}" class="link-title">
                                            ${dto.title}
                                        </a>
                                    </td>
                                    <td>${dto.created_id}</td>
                                    <td>
                                        <fmt:formatDate value="${dto.created_at}" pattern="yyyy-MM-dd"/>
                                    </td>
                                    <td>
                                        <button type="button" style="color:red; border:none; background:none; cursor:pointer;" 
                                                onclick="location.href='notice_delete.htm?id=${dto.notice_id}'">삭제</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" style="padding: 100px 0; color: #999;">
                                    등록된 공지사항이 없습니다.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>