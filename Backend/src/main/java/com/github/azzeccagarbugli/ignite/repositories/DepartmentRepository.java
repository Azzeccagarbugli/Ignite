package com.github.azzeccagarbugli.ignite.repositories;

import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.github.azzeccagarbugli.ignite.models.Department;

@Repository
public interface DepartmentRepository extends MongoRepository<Department, UUID> {
}
