package com.darwinBox.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.darwinBox.model.Person;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Repository;

@Repository
public class PersonService {
	
	@Autowired
	private MongoTemplate mongoTemplate;
	
	public static final String COLLECTION_NAME = "person";
	
	public String addPerson(Person person) {
		if (!mongoTemplate.collectionExists(Person.class)) {
			mongoTemplate.createCollection(Person.class);
		}		
		mongoTemplate.insert(person, COLLECTION_NAME);

		return person.getId();
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

	public String changeUserStatus(String userId, String status) {
		Query query = new Query();
		query.addCriteria(Criteria.where("id").is(userId));

		Update update = new Update();
		update.set("status", status);

		mongoTemplate.updateFirst(query, update, Person.class);
		return "Successfully Saved";
	}

	public List<String> getAllIdsOfPersons() {
		List<String> allIds = new ArrayList<>();
		Query q = new Query();
		q.fields().include("id");
		List<Person> listOfObjects = mongoTemplate.find(q, Person.class);

		for(Person person : listOfObjects){
			allIds.add(person.getId());
		}
		return allIds;
	}
}

