package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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

	@GetMapping("/colors")
	public List<String> getColors() {
		return valueEnumServices.getColors();
	}

	@GetMapping("/attacks")
	public List<String> getAttacks() {
		return valueEnumServices.getAttacks();
	}

	@GetMapping("/openings")
	public List<String> getOpenings() {
		return valueEnumServices.getOpenings();
	}

	@GetMapping("/types")
	public List<String> getTypes() {
		return valueEnumServices.getTypes();
	}

	@GetMapping("/pressures")
	public List<String> getPressures() {
		return valueEnumServices.getPressures();
	}
	
	@GetMapping("/vehicles")
	public List<String> getVehicles() {
		return valueEnumServices.getVehicles();
	}
	
	@PostMapping("/new")
	public ValueEnum addValues(@RequestBody ValueEnum valueEnum) {
		return valueEnumServices.addValues(valueEnum);
	}
}
