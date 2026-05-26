package com.ebs.model;

public class Complaint {
    private int complaintId;
    private int consumerId;
    private String subject;
    private String description;
    private String status;
    private String createdDate;

    public Complaint() {}

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }
    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCreatedDate() { return createdDate; }
    public void setCreatedDate(String createdDate) { this.createdDate = createdDate; }
}
