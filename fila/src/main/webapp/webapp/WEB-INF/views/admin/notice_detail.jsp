<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

