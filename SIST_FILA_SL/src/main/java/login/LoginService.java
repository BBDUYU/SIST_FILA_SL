package login;

import member.MemberDAO;
import member.MemberDTO;

public class LoginService implements ILogin{
	private MemberDAO dao = MemberDAO.getInstance();

    @Override
    public MemberDTO login(String id, String pw) {
        // 비밀번호 암호화 로직 등이 나중에 여기에 추가될 수 있습니다.
        return dao.login(id, pw);


    
     
    }
}
