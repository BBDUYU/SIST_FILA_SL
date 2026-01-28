<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FILA ADMIN - 공지사항 작성</title>
<style>
:root { --fila-navy: #001E62; --fila-red: #E2001A; --fila-gray: #F4F4F4; }
body { font-family: 'Noto Sans KR', sans-serif; background-color: var(--fila-gray); margin: 0; display: flex; }
.main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); }
.card { background: white; border: 1px solid #ddd; padding: 25px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }

/* 입력 테이블 스타일 (준식님 상품문의 스타일 계승) */
.info-table { width: 100%; border-top: 2px solid var(--fila-navy); border-collapse: collapse; margin-bottom: 20px; }
.info-table th { background-color: #f9f9f9; border: 1px solid #eee; padding: 12px 15px; text-align: left; width: 15%; font-size: 14px; color: #333; font-weight: bold; }
.info-table td { border: 1px solid #eee; padding: 12px 15px; }

/* 입력 요소 스타일 */
.input-text { width: 95%; padding: 8px 10px; border: 1px solid #ddd; font-size: 14px; }
.input-sel { padding: 8px 10px; border: 1px solid #ddd; font-size: 14px; }

.section-title { font-size: 18px; font-weight: bold; color: var(--fila-navy); margin: 30px 0 15px 0; display: flex; align-items: center; }
.section-title::before { content: ''; display: inline-block; width: 4px; height: 18px; background-color: var(--fila-red); margin-right: 10px; }

.btn-area { text-align: center; margin-top: 40px; border-top: 1px solid #eee; padding-top: 25px; }
.btn-fila { background: var(--fila-navy); color: white; border: none; padding: 10px 30px; cursor: pointer; font-size: 14px; font-weight: bold; }
.btn-list { background: #666; color: white; text-decoration: none; padding: 10px 30px; font-size: 14px; display: inline-block; margin-right: 10px; }
</style>
</head>
<body>
    
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="currentPage" value="notice" />
    </jsp:include>

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
					        <input type="text" name="created_id" value="${sessionScope.user_number}" 
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
    
    <script>
function uploadImage() {
    const fileInput = document.getElementById('imageFile');
    const status = document.getElementById('uploadStatus');
    const preview = document.getElementById('imagePreview');
    const previewImg = document.getElementById('previewImg');
    const hiddenInput = document.getElementById('image_url');

    if (!fileInput.files || fileInput.files.length === 0) return;

    const file = fileInput.files[0];
    const formData = new FormData();
    formData.append("uploadFile", file); // 서버에서 받을 파라미터명

    status.innerText = "업로드 중...";

    // AJAX 요청 (cos.jar 안쓰고 서블릿에서 getPart() 등으로 처리하는 방식 대응)
    fetch("${pageContext.request.contextPath}/admin/imageUpload.htm", {
        method: "POST",
        body: formData
    })
    .then(response => response.json()) // 서버에서 { "url": "/images/notice/aaa.jpg" } 이런식으로 준다고 가정
    .then(data => {
        if(data.url) {
            status.innerText = "업로드 완료!";
            hiddenInput.value = data.url; // DB에 저장할 경로 세팅
            previewImg.src = data.url;    // 미리보기 이미지 교체
            preview.style.display = "block";
        } else {
            status.innerText = "업로드 실패: " + data.message;
        }
    })
    .catch(error => {
        console.error("Error:", error);
        status.innerText = "업로드 중 오류 발생";
    });
}

function validateForm() {
    const imageUrl = document.getElementById('image_url').value;
    
    // 필수라면 체크, 필수 아니면 통과
    if (!imageUrl) {
        alert("이미지를 먼저 업로드해 주세요.");
        return false; 
    }
    
    return true;
}
</script>

</body>
</html>