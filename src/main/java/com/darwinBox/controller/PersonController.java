package com.darwinBox.controller;

import com.darwinBox.model.Person;
import org.springframework.beans.factory.annotation.Autowired;
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
    	userIds.add("e07ac117-fe36-4392-b92e-5270844faf65");
    	userIds.add("e07ac117-fe36-4392-b92e-5270844faf66");
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

		Person person = new Person();
		person.setFname(firstName);
		person.setLname(lastName);
		person.setEmailId(email);
		person.setApplicationDate(System.currentTimeMillis());
		person.setPhone(Long.parseLong(phone));
		person.setStatus("SCREENING");
		String id  = personService.addPerson(person);

		String relativeWebPath = "/webapp/resources/uploadedFiles";
		String absoluteFilePath = context.getRealPath(relativeWebPath);
		File uploadedFile = new File(absoluteFilePath, id);
		return "Successfully Saved";
	}

}
