package com.github.azzeccagarbugli.ignite.services;

import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.User;
import com.github.azzeccagarbugli.ignite.repositories.UserRepository;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;

@Service
public class UserServices {

	@Autowired
	private UserRepository repository;

	public User getUserById(UUID id) {
		return repository.findById(id).get();
	}

	public User getUserByMail(String mail) {
		return repository.findByMail(mail).get(0);
	}

	public boolean isUserFiremanByMail(String mail) {
		return this.getUserByMail(mail).isFireman();
	}

	public boolean isUserFirstAccessByMail(String mail) {
		return this.getUserByMail(mail).isFirstAccess();
	}

	public void setFirstAccessToFalseByMail(String mail) {
		User user = this.getUserByMail(mail);
		user.setFirstAccess(false);
		this.updateUser(user);
	}

	public User addUser(User newUser) {
		newUser.setId(UUID.randomUUID());
		return repository.insert(newUser);
	}

	public User updateUser(User newUser) {
		return repository.save(newUser);
	}

	public void deleteUser(UUID id) {
		repository.deleteById(id);
	}

	public void setFireman(UUID id, boolean isFireman) {
		User user = this.getUserById(id);
		user.setFireman(isFireman);
		this.updateUser(user);

	}
}
