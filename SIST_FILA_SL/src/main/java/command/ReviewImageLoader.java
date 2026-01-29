package command;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ReviewImageLoader implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 요청한 파일 이름 받기 (예: neko1.jpg)
        String fileName = request.getParameter("file");
        
        // 파일명이 없으면 종료
        if (fileName == null || fileName.trim().equals("")) {
            return null;
        }

        // 2. 실제 파일이 있는 경로 (아까 만든 C드라이브 폴더)
        String savePath = "C:\\fila_upload\\review";
        
        // 전체 경로 완성 (C:\fila_upload\review\neko1.jpg)
        File file = new File(savePath, fileName);

        // 3. 파일이 있으면 읽어서 브라우저에 쏴주기
        if (file.exists()) {
            
            // 한글 파일명 깨짐 방지
            String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            
            // 응답 헤더 설정 (이게 이미지다! 라고 알려줌)
            response.setContentType("image/jpeg"); // jpg, png 등 자동 인식은 복잡하니 일단 jpeg로
            response.setHeader("Content-Disposition", "inline; filename=" + encodedFileName);
            
            // 스트림 열어서 전송 (복사 붙여넣기 로직)
            BufferedInputStream in = null;
            BufferedOutputStream out = null;
            
            try {
                in = new BufferedInputStream(new FileInputStream(file));
                out = new BufferedOutputStream(response.getOutputStream());
                
                byte[] buffer = new byte[1024];
                int count = 0;
                while ((count = in.read(buffer)) != -1) {
                    out.write(buffer, 0, count);
                }
                out.flush();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (in != null) try { in.close(); } catch (Exception e) {}
                if (out != null) try { out.close(); } catch (Exception e) {}
            }
        }
        
        return null; // 페이지 이동 없음 (이미지 데이터만 쏘고 끝)
    }
}