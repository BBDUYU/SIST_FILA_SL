package com.fila.app.controller.admin;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class DisplayImageController {

	@GetMapping("/displayImage.do")
	public void displayImage(@RequestParam("path") String path, HttpServletResponse response) {
	    if (path == null || path.trim().isEmpty()) return;

	    // 1. 경로 보정 및 정규화
	    String cleanPath = path.replace("\\", "/"); // 슬래시 방향 통일
	    String localPath = "";

	    // Case A: DB에 "C:/fila_upload/product/..."로 저장된 경우 (현재 대부분의 데이터)
	    if (cleanPath.toUpperCase().contains("C:/FILA_UPLOAD")) {
	        // 이미 절대 경로이므로 슬래시 방향만 윈도우에 맞게 보정
	        localPath = cleanPath;
	    }
	    // Case B: DB에 "/upload/product/..." 처럼 가상 경로로 저장된 경우
	    else if (cleanPath.contains("/upload/")) {
	    	String subPath = cleanPath.substring(cleanPath.indexOf("/upload") + 7); 
	        localPath = "C:/fila_upload" + subPath;
	    }
	    // Case C: 그 외 (파일명만 있거나 상대경로인 경우)
	    else {
	        // 1. 이미 경로에 특정 폴더(notice, style, product 등)가 포함되어 있는지 확인
	        // 슬래시(/)가 포함되어 있다면 이미 하위 폴더 경로가 들어온 것으로 판단합니다.
	        if (cleanPath.contains("/")) {
	            localPath = "C:/fila_upload/" + (cleanPath.startsWith("/") ? cleanPath.substring(1) : cleanPath);
	        } else {
	            // 2. 폴더명 없이 "파일명.jpg"만 들어왔을 때의 기본 처리 (공지사항 등)
	            localPath = "C:/fila_upload/notice/" + cleanPath;
	        }
	    }

	    // 최종적으로 윈도우 파일 시스템 형식으로 변환 (중복 슬래시 제거 및 구분자 보정)
	    localPath = localPath.replace("//", "/").replace("/", File.separator);
	    
	    File file = new File(localPath);

	    // 로그로 최종 경로 확인 (안 나올 경우 이 경로를 복사해서 탐색기에 넣어보세요)
	    System.out.println("[Display] 요청 원본: " + path);
	    System.out.println("[Display] 최종 물리 경로: " + localPath);

	    if (!file.exists() || !file.isFile()) {
	        System.out.println("❌ [파일 없음] " + localPath);
	        try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (IOException e) {}
	        return;
	    }

	    // 2. 이미지 전송
	    try {
	        String mimeType = Files.probeContentType(file.toPath());
	        if (mimeType == null) mimeType = "image/jpeg";
	        
	        response.setContentType(mimeType);
	        response.setContentLength((int) file.length());

	        try (FileInputStream fis = new FileInputStream(file);
	             OutputStream os = response.getOutputStream()) {
	            StreamUtils.copy(fis, os);
	            os.flush();
	        }
	    } catch (IOException e) {
	        System.err.println("❌ 전송 에러: " + e.getMessage());
	    }
	}
}