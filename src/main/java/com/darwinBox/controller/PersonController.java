package com.darwinBox.controller;

import com.darwinBox.model.Person;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.RedirectView;

import com.darwinBox.service.PersonService;

import javax.servlet.ServletContext;
import java.io.File;
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

    @RequestMapping(value = "/person", method = RequestMethod.GET)
	public String getPersonList(ModelMap model) {  
        model.addAttribute("personList", personService.listPerson());  
        return "output";  
    }  
    
    @RequestMapping(value = "/person/save", method = RequestMethod.POST)  
	public View createPerson(@ModelAttribute Person person, ModelMap model) {
    	if(StringUtils.hasText(person.getId())) {
    		personService.updatePerson(person);
    	} else {
    		personService.addPerson(person);
    	}
    	return new RedirectView("/person");
    }
        
    @RequestMapping(value = "/person/delete", method = RequestMethod.GET)  
	public View deletePerson(@ModelAttribute Person person, ModelMap model) {  
        personService.deletePerson(person);  
        return new RedirectView("/person");
    }

	@RequestMapping("/recruiterView")
	public ModelAndView recruiterView() {
		System.out.println(personService.listPerson());
		return new ModelAndView("recruiterView", "personList" , personService.listPerson());
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

		String relativeWebPath = "resources/uploadedFiles/";
		String absoluteFilePath = context.getRealPath(relativeWebPath);
		Integer i  = file.getOriginalFilename().lastIndexOf(".");
		String extension = file.getOriginalFilename().substring(i+1,file.getOriginalFilename().toCharArray().length);
		System.out.println(extension);
		System.out.println(file.getSize());

		Person person = new Person();
		person.setFname(firstName);
		person.setLname(lastName);
		person.setEmailId(email);
		person.setApplicationDate(System.currentTimeMillis());
		person.setPhone(Long.parseLong(phone));
		person.setStatus("SCREENING");
		person.setCvType(extension.toLowerCase());
		String id  = personService.addPerson(person);
		File uploadedFile = new File(absoluteFilePath, id + "." + extension );

		try {
			uploadedFile.createNewFile();
		} catch (IOException e) {
			System.out.println(e);
			return "Error uploading the file, Please try again";
		}
		return "Successfully Saved";
	}



	@RequestMapping(value="/getCV", method=RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<byte[]> getCV(@RequestParam("fileName") String fileName) {
		HttpHeaders headers = new HttpHeaders();
		InputStream in = context.getResourceAsStream("/resources/uploadedFiles/"+fileName);
		System.out.println(fileName);
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
}
