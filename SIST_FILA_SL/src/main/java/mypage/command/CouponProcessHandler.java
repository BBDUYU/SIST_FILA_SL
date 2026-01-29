package mypage.command;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import net.sf.json.JSONObject;
import command.CommandHandler;
import member.domain.MemberDTO;

public class CouponProcessHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // AJAX 응답을 위한 설정
        response.setContentType("application/json; charset=UTF-8");
        String serialNo = request.getParameter("randomNo"); // JSP에서 'randomNo'로 보냄
        MemberDTO auth = (MemberDTO) request.getSession().getAttribute("auth");

        Map<String, Object> resultMap = new HashMap<>();
        
        if (auth == null) {
            resultMap.put("msg", "alert('로그인이 필요합니다.');");
            return JSONObject.fromObject(resultMap).toString();
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // 1. 입력받은 시리얼 번호가 존재하는 유효한 쿠폰인지 확인
            String sqlCheck = "SELECT COUPON_ID, EXPIRES_AT FROM COUPON WHERE SERIAL_NUMBER = ? AND STATUS = 'Y'";
            pstmt = conn.prepareStatement(sqlCheck);
            pstmt.setString(1, serialNo);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int couponId = rs.getInt("COUPON_ID");
                java.sql.Date expireDate = rs.getDate("EXPIRES_AT");

                // 2. 이미 등록한 쿠폰인지 확인 (중복 지급 방지)
                String sqlDup = "SELECT COUNT(*) FROM USER_COUPON WHERE USER_NUMBER = ? AND COUPON_ID = ?";
                PreparedStatement pstmt2 = conn.prepareStatement(sqlDup);
                pstmt2.setInt(1, auth.getUserNumber());
                pstmt2.setInt(2, couponId);
                ResultSet rs2 = pstmt2.executeQuery();
                
                if (rs2.next() && rs2.getInt(1) > 0) {
                	resultMap.put("status", "fail");
                    resultMap.put("message", "이미 등록된 쿠폰입니다.");
                } else {
                    // 3. USER_COUPON 테이블에 등록
                    String sqlInsert = "INSERT INTO USER_COUPON (USER_COUPON_ID, COUPON_ID, USER_NUMBER, IS_USED, EXPIRE_DATE, RECEIVED_AT) " +
                                       "VALUES (SEQ_USER_COUPON.NEXTVAL, ?, ?, 0, ?, SYSDATE)";
                    PreparedStatement pstmt3 = conn.prepareStatement(sqlInsert);
                    pstmt3.setInt(1, couponId);
                    pstmt3.setInt(2, auth.getUserNumber());
                    pstmt3.setDate(3, expireDate);
                    pstmt3.executeUpdate();
                    
                    conn.commit(); // 성공 시 확정
                    resultMap.put("status", "success");
                    resultMap.put("message", "쿠폰이 성공적으로 등록되었습니다.");
                }
            } else {
            	resultMap.put("status", "fail");
                resultMap.put("message", "유효하지 않거나 중지된 쿠폰 번호입니다.");
            }
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            resultMap.put("msg", "alert('처리 중 오류가 발생했습니다.');");
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
            JdbcUtil.close(conn);
        }

        // JSON 결과 출력 (JSP의 success: function(data)로 전달됨)
        response.getWriter().write(JSONObject.fromObject(resultMap).toString());
        return null; // AJAX이므로 페이지 이동 없음
    }
}