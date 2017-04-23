package com.darwinBox.service;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import com.darwinBox.model.Person;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class PersonService {
	
	@Autowired
	private MongoTemplate mongoTemplate;
	
	public static final String COLLECTION_NAME = "person";
	
	public void addPerson(Person person) {
		if (!mongoTemplate.collectionExists(Person.class)) {
			mongoTemplate.createCollection(Person.class);
		}		
		person.setId(UUID.randomUUID().toString());
		mongoTemplate.insert(person, COLLECTION_NAME);
	}
	
	public List<Person> listPerson() {
		return mongoTemplate.findAll(Person.class, COLLECTION_NAME);
	}
	
	public void deletePerson(Person person) {
		mongoTemplate.remove(person, COLLECTION_NAME);
	}
	
	public void updatePerson(Person person) {
		mongoTemplate.insert(person, COLLECTION_NAME);		
	}

	public Person findPersonWithId(String currentUserId) {
		return mongoTemplate.findById(currentUserId, Person.class);
	}

	public String convertObjectToJSONString(Object object){
		if(object == null){
			return null;
		}
		ObjectMapper mapper = new ObjectMapper();
		try {
			return mapper.writeValueAsString(object);
		} catch (JsonGenerationException jgexp) {
		} catch (JsonMappingException jmexp) {
		} catch (IOException ioexp) {
		}
		return null;
	}

}

