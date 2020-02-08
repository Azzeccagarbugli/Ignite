package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.azzeccagarbugli.ignite.models.User;
import com.github.azzeccagarbugli.ignite.services.UserServices;

@RestController
@RequestMapping("ignite/api/user")
public class UserController {

	@Autowired
	private UserServices userServices;

	@GetMapping("/id/{id}")
	public User getUserById(@PathVariable("id") String id) {
		return userServices.getUserById(UUID.fromString(id));
	}
	
	@GetMapping("/mail/{mail}")
	public User getUserByMail(@PathVariable("mail") String mail) {
		return userServices.getUserByMail(mail);
	}
	
	@GetMapping("/isFireman/{mail}")
	public boolean isUserFiremanByMail(@PathVariable("mail") String mail) {
		return userServices.isUserFiremanByMail(mail);
	}
	
	@GetMapping("/isFirstAccess/{mail}")
	public boolean isUserFirstAccessByMail(@PathVariable("mail") String mail) {
		return userServices.isUserFirstAccessByMail(mail);
	}
	
	@PutMapping("/setFirstAccess/{mail}")
	public void setFirstAccessToFalseByMail(@PathVariable("mail") String mail) {
		userServices.setFirstAccessToFalseByMail(mail);
	}
	
	@PostMapping("/new")
	public User addUser(@RequestBody User newUser) {
		return userServices.addUser(newUser);
	}
	
	@PostMapping("/update")
	public User updateUser(@RequestBody User newUser) {
		return userServices.updateUser(newUser);
	}
	
	@DeleteMapping("/delete/{id}")
	public void deleteUser(@PathVariable("id") String id) {
		userServices.deleteUser(UUID.fromString(id));
	}
	
	@PutMapping("/setFireman/{id}&{bool}")
	public void setFireman(@PathVariable("id") String id, @PathVariable("bool") boolean bool) {
		userServices.setFireman(UUID.fromString(id), bool);
	}
}
