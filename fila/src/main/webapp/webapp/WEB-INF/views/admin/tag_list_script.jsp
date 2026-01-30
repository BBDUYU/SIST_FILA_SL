<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
// 등록 모달 열기
function openModal() {
    document.getElementById('tagForm').action = "${pageContext.request.contextPath}/admin/createTag.htm";
    document.getElementById('modalTitle').innerText = "신규 태그 등록";
    document.getElementById('modalSubmitBtn').innerText = "등록하기";
    document.getElementById('modalCategoryId').value = "";
    document.getElementById('modalTagName').value = "";
    document.getElementById('tagModal').style.display = 'block';
}

// 수정 모달 열기
function openEditModal(id, name) {
    document.getElementById('tagForm').action = "${pageContext.request.contextPath}/admin/editTag.htm";
    document.getElementById('modalTitle').innerText = "태그 정보 수정";
    document.getElementById('modalSubmitBtn').innerText = "수정하기";
    document.getElementById('modalCategoryId').value = id;
    document.getElementById('modalTagName').value = name;
    document.getElementById('tagModal').style.display = 'block';
}

function closeModal() { document.getElementById('tagModal').style.display = 'none'; }

</script>