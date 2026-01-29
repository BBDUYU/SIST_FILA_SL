package review;

import java.io.File;
import java.sql.Connection;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.util.DBConn;

import command.CommandHandler;
import member.MemberDTO;

public class ReviewWrite implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1. 파일 업로드 설정
        // 실제 서버 경로 찾기 (images/review 폴더에 저장한다고 가정)
        String saveDirectory = request.getServletContext().getRealPath("/images/review");
        
        // 폴더 없으면 생성
        File dir = new File(saveDirectory);
        if (!dir.exists()) dir.mkdirs();

        int maxPostSize = 10 * 1024 * 1024; // 10MB 제한
        String encoding = "UTF-8";

        MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, new DefaultFileRenamePolicy());

        // 2. 파라미터 받기 (request 대신 multi 사용)
        String productId = multi.getParameter("productNo"); // JSP input name="productNo" 확인
        String content = multi.getParameter("reviewContent"); // JSP textarea name="reviewContent"
        
        int rating = 5;
        try {
            rating = Integer.parseInt(multi.getParameter("reviewScore")); // JSP hidden name="reviewScore"
        } catch (NumberFormatException e) {
            rating = 5;
        }

        // 업로드된 파일명 가져오기
        String filesystemName = multi.getFilesystemName("reviewFile"); // JSP input type="file" name="reviewFile"
        String reviewImgPath = null;
        if (filesystemName != null) {
            reviewImgPath = "/images/review/" + filesystemName; // DB에 저장할 경로
        }


        // 3. 세션에서 로그인 정보 확인
        HttpSession session = request.getSession();
        Object authObj = session.getAttribute("auth");

        if (authObj == null) {
            // 로그인 안 됨 -> 에러 페이지 또는 로그인 페이지로
            request.setAttribute("message", "로그인이 필요한 서비스입니다.");
            return "redirect:/login.htm";
        }

        MemberDTO member = (MemberDTO) authObj;
        int userNumber = member.getUserNumber(); 


        // 4. DTO 생성
        ReviewDTO dto = new ReviewDTO();
        dto.setProduct_id(productId);
        dto.setUser_number(userNumber);
        dto.setContent(content);
        dto.setRating(rating);
        dto.setReview_img(reviewImgPath);


        // 5. DB 저장
        Connection conn = null;
        int rowCount = 0;

        try {
            conn = DBConn.getConnection();
            ReviewDAO dao = new ReviewDAOImpl(conn);
            rowCount = dao.insert(dto);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {

        }

        // 6. 결과 페이지 이동 (수정본)
        response.setContentType("text/html; charset=UTF-8");
        java.io.PrintWriter out = response.getWriter();
        
        if (rowCount == 1) {
            // 성공 시: 브라우저에게 이 주소로 다시 접속하라고 직접 명령
        	String location = request.getContextPath() + "/product/product_detail.htm?product_id=" + productId;
            out.println("<script>");
            out.println("alert('리뷰가 정상적으로 등록되었습니다.');");
            out.println("location.href='" + location + "';");
            out.println("</script>");
            out.close();
            return null;
        } else {
            out.println("<script>");
            out.println("alert('리뷰 등록에 실패했습니다. 다시 시도해주세요.');");
            out.println("history.back();"); // 이전 작성 페이지로 돌려보냄
            out.println("</script>");
            out.close();
            return null;
        }
    }
}