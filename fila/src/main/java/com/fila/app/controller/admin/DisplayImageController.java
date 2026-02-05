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

        // 1. 경로 보정 (DB 저장 방식에 따라 분기)
        String localPath = "";
        
        // 가상 경로(/upload)로 들어온 경우 -> 실제 물리 경로(C:\fila_upload)로 치환
        if (path.startsWith("/upload")) {
            localPath = path.replace("/upload", "C:\\fila_upload");
        } 
        // 이미 절대 경로(C:\)인 경우 -> 그대로 사용하되 슬래시 방향만 보정
        else if (path.toUpperCase().startsWith("C:")) {
            localPath = path;
        } 
        else {
            // 그 외의 경우 기본 경로 설정
            localPath = "C:\\fila_upload" + path;
        }

        // 윈도우/리눅스 경로 구분자 보정
        localPath = localPath.replace("/", File.separator).replace("\\", File.separator);
        
        File file = new File(localPath);

        if (!file.exists() || !file.isFile()) {
            System.out.println("❌ [이미지 에러] 파일을 찾을 수 없음: " + localPath);
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (IOException e) {}
            return;
        }

        // 2. 응답 설정 및 스트리밍
        try {
            String mimeType = Files.probeContentType(file.toPath());
            if (mimeType == null) mimeType = "image/jpeg";
            
            response.setContentType(mimeType);
            response.setContentLength((int) file.length());

            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {
                StreamUtils.copy(fis, os); // 스프링에서 제공하는 유틸리티 (편리함!)
                os.flush();
            }
        } catch (IOException e) {
            System.err.println("❌ 이미지 전송 중 오류: " + e.getMessage());
        }
    }
}