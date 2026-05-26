package com.ebs.model;

public class Payment {
    private int paymentId;
    private int billId;
    private int consumerId;
    private double amount;
    private String paymentDate;
    private String paymentMode;
    private String transactionRef;

    public Payment() {}

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }
    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getPaymentDate() { return paymentDate; }
    public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }
    public String getPaymentMode() { return paymentMode; }
    public void setPaymentMode(String paymentMode) { this.paymentMode = paymentMode; }
    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }
}
