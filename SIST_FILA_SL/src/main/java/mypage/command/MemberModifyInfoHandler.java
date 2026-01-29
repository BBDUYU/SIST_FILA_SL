package mypage.command;

import java.sql.Connection;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import command.CommandHandler;
import member.MemberDAO;
import member.MemberDTO;
import member.ChildDTO; // ChildDTO 임포트 확인

public class MemberModifyInfoHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        MemberDTO auth = (MemberDTO) session.getAttribute("auth");
        if (auth == null) return "redirect:/login.htm";

        // ---------------------------------------------------------
        // 1. [GET] 수정 페이지 진입 (기존 데이터 조회)
        // ---------------------------------------------------------
        if (request.getMethod().equalsIgnoreCase("GET")) {
            Connection conn = null;
            try {
                conn = ConnectionProvider.getConnection();
                MemberDAO dao = MemberDAO.getInstance();
                int userNum = auth.getUserNumber();

                // (1) 자녀 정보 조회 -> JSP에서 ${childList}로 사용
                List<ChildDTO> childList = dao.selectChildren(conn, userNum);
                request.setAttribute("childList", childList);

                // (2) 마케팅 동의 상태 조회 (6: SMS, 7: Email) -> JSP에서 ${mktMap}으로 사용
                Map<String, Integer> mktMap = dao.getMarketingStatus(conn, userNum);
                request.setAttribute("mktMap", mktMap);

                return "/view/mypage/modifyInfo.jsp";
            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/mypage/mypage.jsp"; // 실패 시 마이페이지 메인으로
            } finally {
                JdbcUtil.close(conn);
            }
        }

        // ---------------------------------------------------------
        // 2. [POST] 수정 처리 (실제 DB 업데이트)
        // ---------------------------------------------------------
        // 기본 정보
        String email = request.getParameter("userEmail");
        // 마케팅 (Y 또는 null)
        String smsAgree = request.getParameter("MemberIsSMS"); 
        String emailAgree = request.getParameter("MemberIsMaillinglist"); 

        // 자녀 정보 (배열)
        String[] childNames = request.getParameterValues("ChildName");
        String[] childBirths = request.getParameterValues("birthch");
        String[] childGenders = request.getParameterValues("MemberGender1");

        Connection conn = null;
        boolean success = false;
        
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 🔥 트랜잭션 시작

            MemberDAO dao = MemberDAO.getInstance();
            int userNum = auth.getUserNumber();

            // (1) 이메일 수정
            dao.updateEmail(conn, userNum, email);

            // (2) 마케팅 정보 수정 (내부에서 6, 7번 ID로 MERGE 처리)
            dao.updateMarketing(conn, userNum, "Y".equals(smsAgree), "Y".equals(emailAgree));

            // (3) 자녀 정보 수정 (기존 삭제 후 재삽입)
            dao.deleteChildren(conn, userNum);
            if (childNames != null) {
                for (int i = 0; i < childNames.length; i++) {
                    // 이름이 비어있지 않은 경우만 저장
                    if (childNames[i] != null && !childNames[i].trim().isEmpty()) {
                        // 날짜에서 하이픈(-) 제거 (DB TO_DATE 포맷 유지용)
                        String birth = childBirths[i].replaceAll("-", "");
                        dao.insertChild(conn, userNum, childNames[i], birth, childGenders[i]);
                    }
                }
            }

            conn.commit(); // ✅ 성공 확정
            success = true;
        } catch (Exception e) {
            JdbcUtil.rollback(conn); // ❌ 실패 시 롤백
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }

        if (success) {
            // 세션 정보 갱신
            auth.setEmail(email); 
            session.setAttribute("auth", auth);
            // 사용자님의 핸들러 주소 .htm에 맞춰서 리다이렉트
            return "/view/mypage/modify_success.jsp";
        } else {
            return "redirect:/mypage/modifyInfo.htm?error=1";
        }
    }
}