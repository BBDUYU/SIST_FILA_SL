<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
$(function () {

    $('#btnOpenQna').on('click', function () {
        alert('버튼 눌림');   // ← 이거 뜨면 100% 정상
        $('#qnaWriteLayer').show();
    });

    $('#btnCloseQna, .layer_dim').on('click', function () {
        $('#qnaWriteLayer').hide();
    });

});
</script>