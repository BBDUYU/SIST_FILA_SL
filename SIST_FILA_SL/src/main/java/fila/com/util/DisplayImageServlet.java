package fila.com.util;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/displayImage.do")
public class DisplayImageServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String path = request.getParameter("path");
	    if (path == null || path.trim().isEmpty()) return;

	    // 1. 경로 보정
	    String cleanPath = path.replace("C:", "").trim();
	    if(!cleanPath.startsWith("/")) cleanPath = "/" + cleanPath;
	    String localPath = "C:" + cleanPath.replace("/", File.separator).replace("\\", File.separator);
	    
	    File file = new File(localPath);
	    
	    // 파일이 없으면 즉시 종료 (무한 대기 방지)
	    if (!file.exists() || !file.isFile()) {
	        System.out.println("❌ 파일 없음: " + localPath);
	        response.sendError(HttpServletResponse.SC_NOT_FOUND);
	        return;
	    }

	    // 2. 응답 헤더 설정
	    String mimeType = getServletContext().getMimeType(file.getName());
	    if (mimeType == null) mimeType = "image/jpeg";
	    response.setContentType(mimeType);
	    response.setContentLength((int) file.length()); // 브라우저에게 파일 크기를 알려주어 끝을 알게 함

	    // 3. 파일 전송 (Try-with-resources로 스트림 자동 종료)
	    try (FileInputStream fis = new FileInputStream(file);
	         BufferedInputStream bis = new BufferedInputStream(fis);
	         OutputStream os = response.getOutputStream()) {
	        
	        byte[] buffer = new byte[8192];
	        int bytesRead;
	        while ((bytesRead = bis.read(buffer)) != -1) {
	            os.write(buffer, 0, bytesRead);
	        }
	        os.flush(); // 마지막 데이터를 강제로 밀어냄
	    } catch (IOException e) {
	        System.err.println("❌ 이미지 전송 중 오류: " + e.getMessage());
	    }
	}
}