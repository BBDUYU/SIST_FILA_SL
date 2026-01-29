package login;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import command.CommandHandler;
import member.domain.MemberDTO;
import member.persistence.MemberDAO;

public class JoinSubmitHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {

        try {
            // 1️⃣ 파라미터 수집
            String id = request.getParameter("memberId");
            String password = request.getParameter("memberPassword");
            String name = request.getParameter("memberName");
            String email = request.getParameter("email");

            String phone1 = request.getParameter("phone1");
            String phone2 = request.getParameter("phone2");

            if (phone1 == null) phone1 = "";
            if (phone2 == null) phone2 = "";
            String phone = phone1 + phone2;

            String birthday = request.getParameter("birthDay");
            String gender = request.getParameter("MemberGender");

            // 2️⃣ 필수값 검증 (🔥 이거 없으면 무조건 터짐)
            if (id == null || password == null || name == null ||
                birthday == null || birthday.length() != 8) {

                System.out.println("❌ JOIN PARAM INVALID");
                return "redirect:/member/join.htm";
            }

            // yyyyMMdd → yyyy-MM-dd
            birthday =
                birthday.substring(0, 4) + "-" +
                birthday.substring(4, 6) + "-" +
                birthday.substring(6, 8);

            // 3️⃣ DTO 매핑
            MemberDTO dto = new MemberDTO();
            dto.setId(id);
            dto.setPassword(password);
            dto.setName(name);
            dto.setEmail(email);
            dto.setPhone(phone);
            dto.setBirthday(birthday);
            dto.setGender(gender);

            dto.setRole("CUSTOMER");
            dto.setStatus("ACTIVE");
            dto.setGrade("BRONZE");

            // 4️⃣ DB 저장
            MemberDAO dao = MemberDAO.getInstance();
            int result = dao.insert(dto);

            System.out.println("✅ JOIN INSERT RESULT = " + result);

            // 5️⃣ 결과 처리
            if (result == 1) {
                return "redirect:/member/joinend.htm";
            } else {
                return "redirect:/member/join.htm";
            }

        } catch (Exception e) {
            // 🔥 이게 없어서 지금까지 흰 화면 나온 거다
            e.printStackTrace();
            return "redirect:/member/join.htm";
        }
    }
}
