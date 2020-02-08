package com.github.azzeccagarbugli.ignite.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.github.azzeccagarbugli.ignite.models.ValueEnum;

@Repository
public interface ValueEnumRepository extends MongoRepository<ValueEnum, UUID> {

	List<ValueEnum> findByName(String name);
}