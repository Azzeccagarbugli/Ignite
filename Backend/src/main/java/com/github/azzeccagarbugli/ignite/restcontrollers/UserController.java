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

	@GetMapping("/isFireman/{id}")
	public boolean isUserFiremanByMail(@PathVariable("id") String id) {
		return userServices.isUserFiremanById(UUID.fromString(id));
	}

	@GetMapping("/isFirstAccess/{id}")
	public boolean isUserFirstAccessByMail(@PathVariable("id") String id) {
		return userServices.isUserFirstAccessById(UUID.fromString(id));
	}

	@PutMapping("/setFirstAccess/{id}")
	public boolean setFirstAccessToFalseByMail(@PathVariable("id") String id) {
		return userServices.setFirstAccessToFalseById(UUID.fromString(id));
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
	public boolean setFireman(@PathVariable("id") String id, @PathVariable("bool") boolean bool) {
		return userServices.toggleFireman(UUID.fromString(id));
	}
}
