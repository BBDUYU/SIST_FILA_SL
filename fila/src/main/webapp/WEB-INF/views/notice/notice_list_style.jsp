<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
.not_info-box {
    background-color: transparent !important; /* 배경색 완전 제거 */
    border: none !important;                /* 테두리 제거 (필요시) */
    min-height: 0 !important;               /* 최소 높이 해제 */
}

#noticeImgView {
    display: block;
    width: 100%;       /* 가로 너비는 영역에 맞춤 */
    height: auto;      /* 세로는 원본 비율 유지 */
}

/* 클릭된 항목(active)의 제목 아래에 검은색 밑줄 추가 */
.notice-item.active {
    border-bottom: 2px solid #000 !important; /* 검은색 두꺼운 밑줄 */
}

.notice-item {
    cursor: pointer;
    padding: 15px 10px;
    border-bottom: 1px solid #eee; /* 기본 밑줄 */
    transition: all 0.3s ease;
}
</style>