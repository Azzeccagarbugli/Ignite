package com.github.azzeccagarbugli.ignite.services;

import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.User;
import com.github.azzeccagarbugli.ignite.repositories.UserRepository;

import lombok.NonNull;

import java.util.NoSuchElementException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;

@Service
public class UserServices {

	@Autowired
	private UserRepository repository;

	public User getUserById(@NonNull UUID id) {
		try {
			return repository.findById(id).get();
		} catch (NoSuchElementException e) {
			return null;
		}
	}

	public User getUserByMail(@NonNull String mail) {
		try {
			return repository.findByMail(mail).get(0);
		} catch (IndexOutOfBoundsException e) {
			return null;
		}
	}

	public boolean isUserFiremanById(@NonNull UUID id) {
		return (this.getUserById(id) == null) ? false : this.getUserById(id).isFireman();
	}

	public boolean isUserFirstAccessById(@NonNull UUID id) {
		return (this.getUserById(id) == null) ? false : this.getUserById(id).isFirstAccess();
	}

	public boolean setFirstAccessToFalseById(@NonNull UUID id) {
		User user = this.getUserById(id);
		if (user == null) {
			return false;
		}
		user.setFirstAccess(false);
		this.updateUser(user);
		return true;
	}

	public User addUser(@NonNull User newUser) {
		newUser.setId(UUID.randomUUID());
		return repository.insert(newUser);
	}

	public User updateUser(@NonNull User newUser) {
		if (repository.existsById(newUser.getId())) {
			return repository.save(newUser);
		} else {
			return null;
		}

	}

	public boolean deleteUser(@NonNull UUID id) {
		if (repository.existsById(id)) {
			repository.deleteById(id);
			return true;
		} else {
			return false;
		}

	}

	public boolean toggleFireman(@NonNull UUID id) {
		User user = this.getUserById(id);
		if (user == null) {
			return false;
		}
		user.setFireman(!user.isFireman());
		this.updateUser(user);
		return true;
	}
}
