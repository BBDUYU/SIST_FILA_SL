package fila.login;

import fila.member.MemberDTO;

public interface ILogin {
	MemberDTO login(String id, String pw);
  
}
