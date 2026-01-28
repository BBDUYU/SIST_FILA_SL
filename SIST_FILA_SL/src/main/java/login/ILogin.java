package login;

import member.MemberDTO;

public interface ILogin {
	MemberDTO login(String id, String pw);
  
}
