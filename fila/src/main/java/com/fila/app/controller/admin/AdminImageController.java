package com.fila.app.controller.admin;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/admin")
public class AdminImageController {

    // 기본 업로드 루트 경로
    private final String UPLOAD_ROOT = "C:\\fila_upload";

    /**
     * 1. 이미지 출력 (ImageDisplayHandler)
     * URL 예시: /admin/display.htm?fileName=/upload/notice/abc.jpg
     */
    @RequestMapping(value = "/display.htm", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<Resource> displayImage(@RequestParam("fileName") String fileName) {
        
        // 1. 경로 변환 (/upload -> C:\fila_upload)
        String realPath = fileName.replace("/upload", UPLOAD_ROOT);
        Resource resource = new FileSystemResource(realPath);

        if (!resource.exists()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        // 2. 헤더 설정 (MIME 타입 자동 감지)
        HttpHeaders headers = new HttpHeaders();
        try {
            headers.add("Content-Type", Files.probeContentType(new File(realPath).toPath()));
        } catch (IOException e) {
            headers.setContentType(MediaType.IMAGE_JPEG); // 실패 시 기본값
        }

        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }

    /**
     * 2. 이미지 업로드 (ImageUploadHandler - AJAX)
     * 공지사항 에디터 등에서 이미지 업로드 시 사용
     */
    @RequestMapping(value = "/uploadImage.htm", method = RequestMethod.POST, produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String uploadImage(@RequestParam("uploadFile") MultipartFile uploadFile, HttpServletRequest request) {
        
        if (uploadFile.isEmpty()) {
            return "{\"error\": \"파일이 없습니다.\"}";
        }

        // 1. 저장 폴더 준비 (notice 폴더)
        String saveSubPath = "\\notice";
        File uploadDir = new File(UPLOAD_ROOT + saveSubPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // 2. 파일명 중복 방지 (UUID)
        String originalName = uploadFile.getOriginalFilename();
        String uuid = UUID.randomUUID().toString();
        String saveFileName = uuid + "_" + originalName;

        try {
            // 3. 물리적 저장
            File saveFile = new File(uploadDir, saveFileName);
            uploadFile.transferTo(saveFile);

            // 4. 클라이언트에 응답할 URL 생성
            String imageUrl = request.getContextPath() + "/displayImage.do?path=/upload/notice/" + saveFileName;
           
            return "{\"url\": \"" + imageUrl + "\"}";

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"업로드 실패\"}";
        }
    }
}