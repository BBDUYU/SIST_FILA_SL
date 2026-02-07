<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="head">
    <h3 class="tit">1:1 문의 작성</h3>
    <button type="button" class="close__btn" onclick="closeQnaModal()"></button>
</div>

<div class="con">

    <!-- 문의유형 -->
    <div class="qna-category-box">
        <p class="tit">문의유형</p>
        <div class="select-box">
            <select name="categoryId" id="categoryId" form="qnaWriteForm">
                <option value="">유형을 선택하세요</option>
                <c:forEach var="cat" items="${categoryList}">
                    <option value="${cat.categoryId}">${cat.categoryName}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <!-- 제목 -->
    <div class="qna-write-box">
        <p class="tit">제목</p>
        <div class="input-box">
            <input type="text"
                   name="title"
                   id="boardTitle"
                   form="qnaWriteForm"
                   placeholder="제목을 입력해주세요." />
        </div>
    </div>

    <!-- 내용 -->
    <div class="qna-write-box">
        <p class="tit">내용</p>
        <div class="textarea-box">
            <textarea name="content"
                      id="boardContents"
                      form="qnaWriteForm"
                      placeholder="문의 내용을 상세히 적어주세요."></textarea>
        </div>
    </div>

    <!-- 개인정보 동의 -->
    <div class="my-privacy-box">
        <p class="tit">개인정보 동의</p>
        <div class="radio-box">
            <label>
                <input type="radio" name="privacyAgree" value="1" checked form="qnaWriteForm" />
                <span>동의함</span>
            </label>
            <label>
                <input type="radio" name="privacyAgree" value="0" form="qnaWriteForm" />
                <span>거부</span>
            </label>
        </div>
    </div>

    <!-- 실제 전송용 form (버튼은 하단 고정 영역에서 동작) -->
    <form id="qnaWriteForm"></form>
</div>

<!-- 하단 고정 버튼 -->
<div class="bot-fix-box">
    <div class="inner">
        <button type="button" class="btn_w" onclick="closeQnaModal()">취소</button>
        <button type="button" class="btn_b" onclick="fn_send()">등록하기</button>
    </div>
</div>
