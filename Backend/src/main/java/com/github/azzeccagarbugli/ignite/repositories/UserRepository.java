package com.github.azzeccagarbugli.ignite.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.github.azzeccagarbugli.ignite.models.User;

@Repository
public interface UserRepository extends MongoRepository<User, UUID> {

	List<User> findByMail(String mail);
}
