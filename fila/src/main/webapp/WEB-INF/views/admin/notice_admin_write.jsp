<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
    <div class="main-content">
        <div class="card">
            <h2 style="border-left: 5px solid var(--fila-navy); padding-left: 15px; margin-top: 0;">
                공지사항 작성
            </h2>
            <hr>

            <form action="${pageContext.request.contextPath}/admin/noticeWrite.htm" 
      method="post" onsubmit="return validateForm()">
                <div class="section-title">공지 내용 입력</div>
                <table class="info-table">
                    <tr>
                        <th>카테고리</th>
                        <td>
                            <select name="category_name" class="input-sel" required>
                                <option value="브랜드">브랜드</option>
                                <option value="E-SHOP">E-SHOP</option>
                                <option value="이벤트">이벤트</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>공지 제목</th>
                        <td>
                            <input type="text" name="title" class="input-text" placeholder="공지사항 제목을 입력하세요." required>
                        </td>
                    </tr>
                    <tr>
					    <th>이미지 첨부</th>
					    <td>
					        <input type="file" id="imageFile" class="input-text" style="width: auto;" onchange="uploadImage()">
					        
					        <input type="hidden" name="image_url" id="image_url">
					        
					        <p id="uploadStatus" style="color: #001E62; font-size: 12px; margin: 5px 0 0 0; font-weight:bold;"></p>
					        
					        <div id="imagePreview" style="margin-top: 10px; display: none;">
					            <img id="previewImg" src="" alt="미리보기" style="max-width: 200px; border: 1px solid #ddd;">
					        </div>
					    </td>
					</tr>
                    <tr>
					    <th>작성자</th>
					    <td>
					        <input type="text" name="created_id" value="${sessionScope.userNumber}" 
       class="input-text" style="background:#eee;" readonly>
					        <p style="color: #888; font-size: 12px; margin: 5px 0 0 0;">* 관리자 계정 번호로 자동 기록됩니다.</p>
					    </td>
					</tr>
                </table>

                <div class="btn-area">
                    <a href="noticeManage.htm" class="btn-list">목록으로</a>
                    <button type="submit" class="btn-fila">공지사항 등록</button>
                </div>
            </form>
        </div>
    </div>
