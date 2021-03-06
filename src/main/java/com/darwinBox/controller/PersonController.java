package com.darwinBox.controller;

import com.darwinBox.model.Person;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.darwinBox.service.PersonService;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Controller    
public class PersonController {

	@Autowired
	private PersonService personService;

	@Autowired
	ServletContext context;

	@RequestMapping("/recruiterView")
	public ModelAndView recruiterView() {
		return new ModelAndView("recruiterView");
	}

	@RequestMapping("/profileView")
	public ModelAndView profileView() {
    	List<String> userIds = new ArrayList<>();
    	userIds = personService.getAllIdsOfPersons();
    	String userIdString = StringUtils.collectionToCommaDelimitedString(userIds);

		return new ModelAndView("profileView", "personList" , userIdString);
	}

	@RequestMapping(value = "/getDataById",  method = RequestMethod.POST)
	@ResponseBody
	public String getDataById(@RequestParam("userId") String currentUserId) {
		Person person = personService.findPersonWithId(currentUserId);
		return personService.convertObjectToJSONString(person);
	}

	@RequestMapping("/registrationView")
	public ModelAndView registrationView() {
		return new ModelAndView("registrationView", "model" , null);
	}

	@RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
	@ResponseBody
	public String uploadFile(@RequestParam("first_name") String firstName,
							 @RequestParam("last_name") String lastName,
							 @RequestParam("email") String email,
							 @RequestParam("phone") String phone,
							 @RequestParam("file") MultipartFile file) {

		Integer i  = file.getOriginalFilename().lastIndexOf(".");
		String extension = file.getOriginalFilename().substring(i+1,file.getOriginalFilename().toCharArray().length);
		try {
		Person person = new Person();
		person.setFname(firstName);
		person.setLname(lastName);
		person.setEmailId(email);
		person.setApplicationDate(System.currentTimeMillis());
		person.setPhone(Long.parseLong(phone));
		person.setStatus("SCREENING");
		person.setCvType(extension.toLowerCase());
		String id  = personService.addPerson(person);
		String finalName = id + "." + extension;

		personService.uploadFileToAWS(personService.getFileFromMultipart(file), finalName);
		} catch (Exception e) {
			e.printStackTrace();
			return "Registration Unsuccessful, please try again";
		}

		return "Successfully Saved";
	}



	@RequestMapping(value="/getCV", method=RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<byte[]> getCV(@RequestParam("fileName") String fileName) {
		HttpHeaders headers = new HttpHeaders();
		InputStream in = context.getResourceAsStream("/resources/uploadedFiles/"+fileName);
		headers.setContentType(MediaType.parseMediaType("application/pdf"));
		headers.add("content-disposition", "inline;filename=" + fileName);
		headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");
		ResponseEntity<byte[]> response = null;
		try {
			response = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
		} catch (IOException e) {
			System.out.println(e);
		}
		return response;
	}


	@RequestMapping(value = "/changeUserStatus", method = RequestMethod.POST)
	@ResponseBody
	public String uploadFile(@RequestParam("userId") String userId,
							 @RequestParam("status") String status){
    	String message = personService.changeUserStatus(userId, status);
		return message;
	}

	@RequestMapping(value = "/getAllUsersList", method = RequestMethod.POST)
	@ResponseBody
	public String getAllUsersList(){
		return personService.convertObjectToJSONString(personService.listPerson());
	}



}
