package com.darwinBox.controller;

import com.darwinBox.model.Person;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.RedirectView;

import com.darwinBox.service.PersonService;

import java.util.ArrayList;
import java.util.List;

@Controller    
public class PersonController {

	@Autowired
	private PersonService personService;

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



}
