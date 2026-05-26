package com.ebs.model;

public class Bill {
    private int billId;
    private int consumerId;
    private String month;
    private double units;
    private double amount;
    private String dueDate;
    private String status;
    // Extra fields for admin display (not stored in Bill table)
    private String customerName;
    private String customerEmail;

    public Bill() {}

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }
    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }
    public String getMonth() { return month; }
    public void setMonth(String month) { this.month = month; }
    public double getUnits() { return units; }
    public void setUnits(double units) { this.units = units; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getDueDate() { return dueDate; }
    public void setDueDate(String dueDate) { this.dueDate = dueDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
}
