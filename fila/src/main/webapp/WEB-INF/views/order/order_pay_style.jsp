<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/* 1. 흰색 모달 박스 설정 */
/* 1. 모달 전체 박스 크기 조절 */
#AddaddModalContent {
    width: 480px !important;       /* 가로 폭을 적절하게 줄임 */
    height: 600px !important;      /* 세로 높이를 적당하게 고정 */
    background: #fff;
    position: relative;
    border-radius: 12px;           /* 모서리를 조금 더 부드럽게 */
    overflow: hidden;
    display: flex !important;
    flex-direction: column !important;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2); /* 그림자로 입체감 부여 */
}

/* 2. FILA 기본 레이어의 위치 및 변형 초기화 (잘림 방지 핵심) */
#AddaddModalContent .common__layer {
    position: relative !important;
    top: 0 !important;
    left: 0 !important;
    transform: none !important;    /* 위로 50% 올라가는 속성 제거 */
    width: 100% !important;
    height: 100% !important;
    margin: 0 !important;
    padding: 0 !important;
    display: flex !important;
    flex-direction: column !important;
}

/* 3. 내부 inner 영역 최적화 */
#AddaddModalContent .inner {
    height: 100% !important;
    max-width: none !important;
    display: flex !important;
    flex-direction: column !important;
}

/* 4. 헤더/푸터는 고정, 주소 목록만 스크롤 */
#AddaddModalContent .head { 
    flex: 0 0 auto !important; 
    padding: 20px !important;
    border-bottom: 1px solid #f4f4f4;
}

#AddaddModalContent .foot { 
    flex: 0 0 auto !important; 
}

#AddaddModalContent .con {
    flex: 1 1 auto !important;     /* 남는 중간 공간을 모두 차지 */
    overflow-y: auto !important;   /* 주소가 많아지면 여기서만 스크롤 */
    padding: 15px 20px !important;
}

/* 5. 중복 배경 가림막 제거 */
#AddaddModalContent .layer-bg__wrap {
    display: none !important;
}
.addr__list li:has(input[name="addr_select"]:checked) {
    background-color: #f8f9fa !important;
    border: 1px solid #000 !important;
}

/* 마우스 올리면 손가락 모양으로 변경 */
.addr__list li {
    cursor: pointer;
}
</style>