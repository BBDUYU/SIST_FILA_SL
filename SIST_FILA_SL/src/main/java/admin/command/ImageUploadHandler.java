package admin.command;

import java.io.File;
import java.util.UUID;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import command.CommandHandler;

public class ImageUploadHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // AJAX 요청인지 확인 (POST)
        if (!request.getMethod().equalsIgnoreCase("POST")) {
            return null;
        }

        // 1. 저장 경로 설정
        String savePath = "C:\\fila_upload\\notice";
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs(); // 폴더 없으면 생성

        // 2. 파일 데이터 가져오기 (input type="file"의 id/name이 uploadFile인 경우)
        Part part = request.getPart("uploadFile");
        String fileName = getFileName(part);
        
        // 파일 중복 방지를 위한 랜덤 이름 생성
        String realFileName = UUID.randomUUID().toString() + "_" + fileName;
        String fullPath = savePath + File.separator + realFileName;

        // 3. 물리적 폴더에 저장
        part.write(fullPath);

        // 4. 클라이언트에 응답할 이미지 URL 주소 생성
        // (보통 서버 설정에서 /upload/가 C:/fila_upload를 바라보게 설정함)
        String imageUrl = "/upload/notice/" + realFileName;

        // 5. JSON 응답 전송
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"url\": \"" + imageUrl + "\"}");

        return null; // AJAX 응답이므로 JSP로 포워딩하지 않음
    }

    // 파일명 추출 유틸
    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "unknown";
    }
}