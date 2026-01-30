<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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