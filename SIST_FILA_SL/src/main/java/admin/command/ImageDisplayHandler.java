package admin.command;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import command.CommandHandler;

public class ImageDisplayHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 브라우저에서 보낸 파일 경로 파라미터 받기
        String fileName = request.getParameter("fileName");

        // [Console 출력 1] 핸들러 진입 확인
        System.out.println("--------------------------------------------");
        System.out.println("[ImageHandler] 요청 받음! 파라미터: " + fileName);

        if (fileName == null || fileName.isEmpty()) {
            System.out.println("[ImageHandler] 결과: fileName이 없습니다.");
            return null;
        }

        // 한글 파일명 디코딩 (기요미.png 등 처리)
        fileName = URLDecoder.decode(fileName, "UTF-8");
        
        // [Console 출력 2] 디코딩 후 경로
        System.out.println("[ImageHandler] 디코딩 후: " + fileName);

        // 실제 물리 경로 변환 (DB의 /upload -> C:\fila_upload)
        String realPath = fileName.replace("/upload", "C:\\fila_upload");
        
        // [Console 출력 3] 최종 변환 경로
        System.out.println("[ImageHandler] 실제 경로 변환: " + realPath);

        File file = new File(realPath);

        // [Console 출력 4] 파일 존재 여부
        if (!file.exists()) {
            System.err.println("[ImageHandler] 에러: 파일을 찾을 수 없습니다! (경로 오타 확인 필요)");
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        } else {
            System.out.println("[ImageHandler] 성공: 파일을 찾았습니다. 크기: " + file.length() + " bytes");
        }

        // 이미지 파일 전송 로직
        String mimeType = request.getServletContext().getMimeType(file.getName());
        response.setContentType(mimeType != null ? mimeType : "image/jpeg");

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int read;
            while ((read = fis.read(buffer)) != -1) {
                os.write(buffer, 0, read);
            }
            os.flush();
            System.out.println("[ImageHandler] 결과: 이미지 바이트 전송 완료");
        } catch (Exception e) {
            System.err.println("[ImageHandler] 예외 발생: " + e.getMessage());
        }
        
        System.out.println("--------------------------------------------");
        return null;
    }
}