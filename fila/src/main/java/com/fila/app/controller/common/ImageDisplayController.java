package com.fila.app.controller.common;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ImageDisplayController {

    @GetMapping("/displayImage.htm")
    public ResponseEntity<byte[]> displayImage(@RequestParam("path") String path) {
        if (path == null || path.trim().isEmpty()) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        // 1. 경로 보정 (기존 서블릿 로직 유지)
        String cleanPath = path.replace("C:", "").trim();
        if(!cleanPath.startsWith("/")) cleanPath = "/" + cleanPath;
        String localPath = "C:" + cleanPath.replace("/", File.separator).replace("\\", File.separator);
        
        File file = new File(localPath);
        
        if (!file.exists() || !file.isFile()) {
            System.out.println("❌ 파일 없음: " + localPath);
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        // 2. 응답 데이터 생성
        ResponseEntity<byte[]> result = null;
        try {
            HttpHeaders header = new HttpHeaders();
            // MIME 타입 자동 감지
            header.add("Content-Type", Files.probeContentType(file.toPath()));
            // 파일 내용을 바이트 배열로 변환하여 전달
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
        } catch (IOException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return result;
    }
}