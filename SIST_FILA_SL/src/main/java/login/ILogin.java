package login;

import member.domain.MemberDTO;

public interface ILogin {
	MemberDTO login(String id, String pw);
  
}
