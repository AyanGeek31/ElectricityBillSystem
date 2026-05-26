package com.ebs.model;

public class Customer {
    private int consumerId;
    private String name;
    private String email;
    private String mobile;
    private String address;
    private int loginId;

    public Customer() {}

    public Customer(int consumerId, String name, String email, String mobile, String address, int loginId) {
        this.consumerId = consumerId;
        this.name = name;
        this.email = email;
        this.mobile = mobile;
        this.address = address;
        this.loginId = loginId;
    }

    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public int getLoginId() { return loginId; }
    public void setLoginId(int loginId) { this.loginId = loginId; }
}
