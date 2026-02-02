<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* ===== join.js 필수 ===== */
.agree-chk-wrap,
.self-agree-wrap {
  display: none;
}
.agree-chk-wrap.open,
.self-agree-wrap.open {
  display: block;
}

/* ===== 본인인증 이후 ===== */
.after-cert {
  display: none;
}

/* ===== 자녀정보 초기 숨김 ===== */
.join-sec .children-box,
.join-sec .children-btn {
  display: none;
}

/* + / - 아이콘 */
.btn_sel .pm::after {
  content: '+';
}
.btn_sel.on .pm::after {
  content: '-';
}
</style>