package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.azzeccagarbugli.ignite.models.Department;
import com.github.azzeccagarbugli.ignite.services.DepartmentServices;

@RestController
@RequestMapping("ignite/api/department")
public class DepartmentController {

	@Autowired
	private DepartmentServices departmentServices;

	@GetMapping("/all")
	public List<Department> getDepartments() {
		return departmentServices.getDepartments();
	}
	
	@PostMapping("/new")
	public Department addDepartment(@RequestBody Department newDepartment) {
		return departmentServices.addDepartment(newDepartment);
	}
}
