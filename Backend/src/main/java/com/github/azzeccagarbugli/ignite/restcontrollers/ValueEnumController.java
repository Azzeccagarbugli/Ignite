package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.azzeccagarbugli.ignite.models.ValueEnum;
import com.github.azzeccagarbugli.ignite.services.ValueEnumServices;

@RestController
@RequestMapping("ignite/api/values")
public class ValueEnumController {

	@Autowired
	private ValueEnumServices valueEnumServices;

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/colors")
	public List<String> getColors() {
		return valueEnumServices.getColors();
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/attacks")
	public List<String> getAttacks() {
		return valueEnumServices.getAttacks();
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/openings")
	public List<String> getOpenings() {
		return valueEnumServices.getOpenings();
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/types")
	public List<String> getTypes() {
		return valueEnumServices.getTypes();
	}

	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/pressures")
	public List<String> getPressures() {
		return valueEnumServices.getPressures();
	}
	
	@PreAuthorize("hasAuthority('ADMIN') or hasAuthority('FIREMAN') or hasAuthority('CITIZEN')")
	@GetMapping("/vehicles")
	public List<String> getVehicles() {
		return valueEnumServices.getVehicles();
	}
	
	@PreAuthorize("hasAuthority('ADMIN')")
	@PostMapping("/new")
	public ValueEnum addValues(@RequestBody ValueEnum valueEnum) {
		return valueEnumServices.addValues(valueEnum);
	}
}
