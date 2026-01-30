<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
    :root {
        --fila-navy: #001E62;
        --fila-red: #E2001A; 
        --fila-gray: #f8f9fa;
        --border-color: #dee2e6;
    }

    body { font-family: 'Noto Sans KR', sans-serif; background-color: #f4f6f9; margin: 0; display: flex; }

    /* 메인 레이아웃 */
    .main-content { margin-left: 240px; padding: 40px; width: calc(100% - 240px); box-sizing: border-box; }
    .card { background: #fff; padding: 30px; border-radius: 4px; border: 1px solid var(--border-color); box-shadow: 0 2px 4px rgba(0,0,0,0.05); }

    /* 리스트 테이블 */
    .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .table th { background-color: var(--fila-navy); color: white; padding: 14px; }
    .table td { padding: 14px; border-bottom: 1px solid var(--border-color); text-align: center; }

    /* 상태 배지 */
    .status-badge { padding: 4px 10px; font-size: 11px; font-weight: bold; border-radius: 2px; }
    .status-wait { background: #fff1f0; color: var(--fila-red); border: 1px solid #ffa39e; }
    .status-done { background: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; }

    .btn-toggle { background: white; border: 1px solid #ccc; padding: 6px 12px; cursor: pointer; }

    /* --- [핵심] 2단 분할 답변 영역 --- */
    .reply-row { display: none; }
    
    .reply-box { 
        background-color: #fcfcfc !important; 
        padding: 30px !important; 
    }

    /* 좌우 배치를 위한 컨테이너 */
    .qa-split-container {
        display: flex;
        width: 100%;
        max-width: 1300px;
        margin: 0 auto;
        gap: 20px; /* 좌우 박스 간격 */
    }

    /* 좌측 문의 / 우측 답변 공통 섹션 */
    .qa-part {
        flex: 1; /* 반반씩 나눠 가짐 */
        background: white;
        border: 1px solid var(--border-color);
        display: flex;
        flex-direction: column;
    }

    .qa-header {
        padding: 12px 15px;
        font-size: 13px;
        font-weight: bold;
        background-color: #f8f9fa;
        border-bottom: 1px solid var(--border-color);
    }
    .header-q { color: var(--fila-red); border-top: 3px solid var(--fila-red); }
    .header-a { color: var(--fila-navy); border-top: 3px solid var(--fila-navy); }

    .qa-body {
        padding: 20px;
        min-height: 200px;
        font-size: 14px;
        line-height: 1.6;
        text-align: left; /* 내용 정렬 */
    }

    /* 입력창 및 버튼 */
    .reply-textarea {
        width: 100%;
        height: 150px;
        padding: 12px;
        border: 1px solid #ddd;
        box-sizing: border-box;
        font-family: inherit;
        resize: none;
    }

    .btn-submit {
        background: var(--fila-navy);
        color: white;
        border: none;
        padding: 10px 25px;
        font-weight: bold;
        cursor: pointer;
        margin-top: 10px;
        float: right;
    }
    /* 5. 답변 펼치기 행 */
.reply-row { display: none; } /* 초기값 */

.reply-box { 
    background-color: #fcfcfc !important; 
    padding: 30px !important; 
    /* width: 100%를 주지 마세요. td는 colspan이 해결합니다. */
}

.qa-split-container {
    display: flex;
    width: 100%;       /* 전체 너비 사용 */
    max-width: 100%;    /* 테이블 칸을 꽉 채우도록 */
    margin: 0; 
    gap: 20px;
}
</style>