<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
  $('#btnCert').on('click', function () {
    $('.after-cert').slideDown();
    $('html, body').animate({
      scrollTop: $('.after-cert').offset().top - 80
    }, 400);
  });
</script>
