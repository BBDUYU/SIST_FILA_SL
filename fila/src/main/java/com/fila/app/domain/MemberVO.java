package com.fila.app.domain;

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

    // ===== getter / setter =====

    public int getUserNumber() {
        return userNumber;
    }
    public void setUserNumber(int userNumber) {
        this.userNumber = userNumber;
    }

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getBirthday() {
        return birthday;
    }
    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getMarketingAgree() {
        return marketingAgree;
    }
    public void setMarketingAgree(int marketingAgree) {
        this.marketingAgree = marketingAgree;
    }

    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getGrade() {
        return grade;
    }
    public void setGrade(String grade) {
        this.grade = grade;
    }
}
