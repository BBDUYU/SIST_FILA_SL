package fila.command;

import java.io.File;
import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import fila.com.util.DBConn;
import fila.member.MemberDTO;
import fila.review.ReviewDAO;
import fila.review.ReviewDAOImpl;
import fila.review.ReviewDTO;

public class ReviewInsertHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	// [가장 윗줄에 추가] 무조건 찍혀야 함!
        System.out.println("=========================================");
        System.out.println(">> [DEBUG] ReviewInsertHandler 진입함!!!!");
        System.out.println(">> Content-Type: " + request.getContentType());
        System.out.println("=========================================");

        response.setContentType("application/json; charset=utf-8");

        String savePath = "C:\\fila_upload\\review";
        File dir = new File(savePath);
        if (!dir.exists()) dir.mkdirs(); 

        // 2. 파일 크기 제한 (10MB)
        int maxSize = 10 * 1024 * 1024;
        String encoding = "UTF-8";

        try {
            // cos.jar 파일 업로드 처리
            MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, encoding, new DefaultFileRenamePolicy());
            System.out.println(">> [DEBUG] MultipartRequest 생성 성공!");
            // 3. 로그인 체크
            HttpSession session = request.getSession();
            MemberDTO auth = (MemberDTO) session.getAttribute("auth");
            
            // 로그인이 풀렸다면 실패 메시지 전송
            if (auth == null) {
                response.getWriter().print("{\"status\": \"fail\", \"message\": \"로그인이 필요한 기능입니다.\"}");
                return null;
            }

            // 4. 파라미터 받기 (주의: request가 아니라 multi에서 꺼내야 함)
            String productNo = multi.getParameter("productNo");
            String content = multi.getParameter("reviewContent");
            // 별점이 안 넘어오면 기본값 5점
            int rating = 5;
            try {
                rating = Integer.parseInt(multi.getParameter("reviewScore"));
            } catch (Exception e) {}
            
            int userNumber = auth.getUserNumber();

            // 5. [핵심] 파일 4개를 콤마(,)로 합치기
            StringBuilder sb = new StringBuilder();
            String webPath = "/fila_upload/review/"; // 웹에서 접근할 때 경로
            
            Enumeration files = multi.getFileNames(); // 전송된 모든 파일의 이름표(parameter name)를 가져옴

            while(files.hasMoreElements()) {
                String name = (String)files.nextElement(); // 예: file1, file2, reviewFiles 등
                String fileName = multi.getFilesystemName(name); // 실제 서버에 저장된 파일 이름 (a.jpg)
                
                // [디버깅용] 콘솔에 무조건 찍어보기
                System.out.println(">> [DEBUG] 파라미터명: " + name + " / 저장된 파일명: " + fileName);

                if(fileName != null) {
                    // 이미지가 있으면 콤마(,)를 붙여서 추가
                    if(sb.length() > 0) sb.append(","); 
                    sb.append(webPath + fileName);
                }
            }
            
            // [확인용] 최종적으로 합쳐진 문자열 확인
            System.out.println(">> 최종 DB 저장용 문자열: " + sb.toString());

            // 6. DTO 생성 및 값 세팅
            ReviewDTO dto = new ReviewDTO();
            dto.setProduct_id(productNo);
            dto.setUser_number(userNumber);
            dto.setContent(content);
            dto.setRating(rating);
            dto.setReview_img(sb.toString()); // 합친 문자열 저장

            // 7. DAO 호출 (insert)
            ReviewDAO dao = new ReviewDAOImpl(DBConn.getConnection());
            int result = dao.insert(dto); 
            DBConn.close();

            // 8. 결과 응답
            if (result == 1) {
                response.getWriter().print("{\"status\": \"success\"}");
            } else {
                response.getWriter().print("{\"status\": \"fail\", \"message\": \"DB 등록 실패\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // 에러 나면 메시지 전송
            response.getWriter().print("{\"status\": \"fail\", \"message\": \"에러 발생: " + e.getMessage() + "\"}");
        }

        return null;
    }
}