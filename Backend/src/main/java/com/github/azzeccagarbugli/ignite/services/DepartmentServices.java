package com.github.azzeccagarbugli.ignite.services;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.Department;
import com.github.azzeccagarbugli.ignite.repositories.DepartmentRepository;

@Service
public class DepartmentServices {

	@Autowired
	private DepartmentRepository repository;

	public List<Department> getDepartments() {
		return repository.findAll();
	}

	public Department addDepartment(Department newDepartment) {
		newDepartment.setId(UUID.randomUUID());
		return repository.insert(newDepartment);
	}
}
