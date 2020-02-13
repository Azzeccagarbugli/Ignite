package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/all")
	public List<Department> getDepartments() {
		return departmentServices.getDepartments();
	}
	
	@PreAuthorize("hasAuthority('ADMIN')")
	@PostMapping("/new")
	public Department addDepartment(@RequestBody Department newDepartment) {
		return departmentServices.addDepartment(newDepartment);
	}
}
