<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
        .common__layer {
            position: fixed !important;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 9999 !important;
            display: none;
        }
        .common__layer .layer_dim {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,.6);
        }
        .common__layer .inner {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: #fff;
            width: 90%;
            max-width: 420px;
            border-radius: 8px;
            padding: 20px;
        }
        .common__layer .head {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>