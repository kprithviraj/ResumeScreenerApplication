package com.darwinBox.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Document
@Data
public class Person {

	@Id
	private String id;
	private String fname;
	private String lname;
	private Long phone;
	private String status;
	private Long applicationDate;
	private String emailId;
	private String cvType;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
}
