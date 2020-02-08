package com.github.azzeccagarbugli.ignite.services;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.repositories.HydrantRepository;

@Service
public class HydrantServices {

	@Autowired
	private HydrantRepository repository;

	@Autowired
	private RequestServices requestServices;

	public Hydrant getHydrantById(UUID id) {
		return repository.findById(id).get();
	}

	public Hydrant addHydrant(Hydrant newHydrant) {
		newHydrant.setId(UUID.randomUUID());
		return repository.insert(newHydrant);
	}

	public void deleteHydrant(UUID id) {
		repository.deleteById(id);
	}

	public Hydrant updateHydrant(Hydrant updatedHydrant) {
		return repository.save(updatedHydrant);
	}

	public List<Hydrant> getApprovedHydrants() {
		return requestServices.getApprovedRequests().stream()
				.map(request -> repository.findById(request.getHydrant()).get()).collect(Collectors.toList());
	}
}
