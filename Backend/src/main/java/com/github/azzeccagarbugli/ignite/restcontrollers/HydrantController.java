package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.services.HydrantServices;

@RestController
@RequestMapping("ignite/api/hydrant")
public class HydrantController {

	@Autowired
	private HydrantServices hydrantServices;

	@GetMapping("/id/{id}")
	public Hydrant getHydrantById(@PathVariable("id") String id) {
		return hydrantServices.getHydrantById(UUID.fromString(id));
	}

	@PostMapping("/new")
	public Hydrant addHydrant(@RequestBody Hydrant newHydrant) {
		return hydrantServices.addHydrant(newHydrant);
	}
	
	@PostMapping("/update")
	public Hydrant updateHydrant(@RequestBody Hydrant newHydrant) {
		return hydrantServices.updateHydrant(newHydrant);
	}

	@DeleteMapping("/delete/{id}")
	public void deleteHydrant(@PathVariable("id") String id) {
		hydrantServices.deleteHydrant(UUID.fromString(id));
	}

	@GetMapping("/approved")
	public List<Hydrant> getApprovedHydrants() {
		return hydrantServices.getApprovedHydrants();
	}
}
