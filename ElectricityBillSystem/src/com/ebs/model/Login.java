package com.ebs.model;

public class Login {
    private int loginId;
    private String email;
    private String password;
    private String userType;
    private String status;

    public Login() {}

    public int getLoginId() { return loginId; }
    public void setLoginId(int loginId) { this.loginId = loginId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getUserType() { return userType; }
    public void setUserType(String userType) { this.userType = userType; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
