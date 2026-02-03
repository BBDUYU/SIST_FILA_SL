package com.fila.app.domain;

import lombok.Data;

@Data
public class MemberVO {

    private int userNumber;
    private String id;
    private String password;
    private String name;
    private String email;
    private String phone;

    // DATE 컬럼은 문자열로 받았다가 DAO에서 Date 변환
    private String birthday;      // yyyy-MM-dd
    private String gender;        // M / F
    private int marketingAgree;   // 0 / 1

    private String role;          // USER
    private String status;        // ACTIVE
    private String grade;         // BASIC

   
}
