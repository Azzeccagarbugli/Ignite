package com.github.azzeccagarbugli.ignite.services;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.repositories.HydrantRepository;

import lombok.NonNull;

@Service
public class HydrantServices {

	@Autowired
	private HydrantRepository repository;

	@Autowired
	private RequestServices requestServices;

	public Hydrant getHydrantById(@NonNull UUID id) {
		try {
			return repository.findById(id).get();
		} catch (NoSuchElementException e) {
			return null;
		}

	}

	public Hydrant addHydrant(@NonNull Hydrant newHydrant) {
		newHydrant.setId(UUID.randomUUID());
		return repository.insert(newHydrant);
	}

	public boolean deleteHydrant(@NonNull UUID id) {
		if (repository.existsById(id)) {
			repository.deleteById(id);
			return true;
		} else {
			return false;
		}

	}

	public Hydrant updateHydrant(@NonNull Hydrant updatedHydrant) {
		if (repository.existsById(updatedHydrant.getId())) {
			return repository.save(updatedHydrant);
		} else {
			return null;
		}

	}

	public List<Hydrant> getApprovedHydrants() {
		return requestServices.getApprovedRequests().stream()
				.map(request -> repository.findById(request.getHydrant()).get()).collect(Collectors.toList());
	}
}
