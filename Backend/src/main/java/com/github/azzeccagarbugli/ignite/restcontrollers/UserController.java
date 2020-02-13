package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/id/{id}")
	public User getUserById(@PathVariable("id") String id) {
		return userServices.getUserById(UUID.fromString(id));
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/mail/{mail}")
	public User getUserByMail(@PathVariable("mail") String mail) {
		return userServices.getUserByMail(mail);
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/isFireman/{id}")
	public boolean isUserFiremanById(@PathVariable("id") String id) {
		return userServices.isUserFiremanById(UUID.fromString(id));
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/isFirstAccess/{id}")
	public boolean isUserFirstAccessById(@PathVariable("id") String id) {
		return userServices.isUserFirstAccessById(UUID.fromString(id));
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@PutMapping("/setFirstAccess/{id}")
	public boolean setFirstAccessToFalseById(@PathVariable("id") String id) {
		return userServices.setFirstAccessToFalseById(UUID.fromString(id));
	}

	@PreAuthorize("permitAll")
	@PostMapping("/new")
	public User addUser(@RequestBody User newUser) {
		return userServices.addUser(newUser);
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@PostMapping("/update")
	public User updateUser(@RequestBody User newUser) {
		return userServices.updateUser(newUser);
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@DeleteMapping("/delete/{id}")
	public void deleteUser(@PathVariable("id") String id) {
		userServices.deleteUser(UUID.fromString(id));
	}

	@PreAuthorize("hasAuthority('ADMIN')")
	@PutMapping("/toggleFireman/{id}")
	public boolean setFireman(@PathVariable("id") String id) {
		return userServices.toggleFireman(UUID.fromString(id));
	}
	
	@PreAuthorize("permitAll")
	@GetMapping("/exists/{mail}")
	public boolean userExistsByMail(@PathVariable("mail") String mail) {
		return userServices.userExistsByMail(mail);
	}
}
