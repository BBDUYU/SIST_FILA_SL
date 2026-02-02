<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
    .complete-container { max-width: 800px; margin: 60px auto; padding: 0 20px; text-align: center; font-family: 'Noto Sans KR', sans-serif; }
    .success-icon { font-size: 60px; color: #00205b; margin-bottom: 20px; }
    .complete-title { font-size: 32px; font-weight: 700; margin-bottom: 10px; color: #00205b; }
    .order-num { font-size: 18px; color: #666; margin-bottom: 40px; }
    .order-num strong { color: #000; text-decoration: underline; }
    
    /* 섹션 공통 스타일 */
    .info-section { text-align: left; margin-top: 40px; border-top: 2px solid #000; }
    .section-title { font-size: 20px; font-weight: 700; margin: 20px 0; }
    
    /* 상품 리스트 스타일 */
    .product-list { list-style: none; padding: 0; }
    .product-item { display: flex; align-items: center; padding: 15px 0; border-bottom: 1px solid #eee; }
    .product-img { width: 100px; height: 100px; background: #f4f4f4; margin-right: 20px; }
    .product-img img { width: 100%; height: 100%; object-fit: cover; }
    .product-info .name { font-weight: 700; font-size: 16px; margin-bottom: 5px; }
    .product-info .option { color: #888; font-size: 14px; }
    .product-info .price { font-weight: 700; margin-top: 5px; }

    /* 배송지/결제정보 테이블 */
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    .info-table th { width: 120px; padding: 15px 10px; background: #f9f9f9; color: #666; font-weight: 400; border-bottom: 1px solid #eee; text-align: left; }
    .info-table td { padding: 15px 10px; border-bottom: 1px solid #eee; font-weight: 500; }

    /* 버튼 영역 */
    .btn-wrap { margin-top: 50px; display: flex; justify-content: center; gap: 10px; }
    .btn-main { padding: 18px 50px; font-size: 16px; font-weight: 700; cursor: pointer; border: 1px solid #00205b; transition: 0.3s; }
    .btn-white { background: #fff; color: #00205b; }
    .btn-black { background: #00205b; color: #fff; }
    .btn-main:hover { opacity: 0.8; }
</style>