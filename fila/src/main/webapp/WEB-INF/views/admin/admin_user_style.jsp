<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
    :root {
        --fila-navy: #001E62;
        --fila-red: #E2001A;
        --fila-gray: #F4F4F4;
    }

    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: var(--fila-gray);
        margin: 0;
        display: flex;
    }

    /* 사이드바 */
    .sidebar {
        width: 240px;
        height: 100vh;
        background: var(--fila-navy);
        color: white;
        position: fixed;
    }

    .sidebar .logo {
        padding: 30px;
        text-align: center;
        border-bottom: 1px solid #1a3578;
        font-weight: bold;
        font-size: 24px;
        letter-spacing: 2px;
    }

    .nav-item {
        padding: 15px 25px;
        cursor: pointer;
        border-bottom: 1px solid #1a3578;
        transition: 0.3s;
    }

    .nav-item:hover, .nav-item.active {
        background: var(--fila-red);
    }

    /* 메인 컨텐츠 */
    .main-content {
        margin-left: 240px;
        padding: 40px;
        width: calc(100% - 240px);
    }

    .card {
        background: white;
        border: 1px solid #ddd;
        border-radius: 0;
        padding: 25px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    /* 테이블 스타일 */
    .table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    .table th {
        background-color: var(--fila-navy);
        color: white;
        padding: 12px;
        font-weight: 500;
    }

    .table td {
        padding: 12px;
        border-bottom: 1px solid #eee;
        text-align: center;
    }

    .badge {
        padding: 4px 8px;
        font-size: 12px;
        color: white;
        font-weight: bold;
    }

    .btn-detail {
        background: white;
        border: 1px solid var(--fila-navy);
        color: var(--fila-navy);
        padding: 5px 10px;
        cursor: pointer;
        transition: 0.3s;
    }

    .btn-detail:hover {
        background: var(--fila-navy);
        color: white;
    }
</style>