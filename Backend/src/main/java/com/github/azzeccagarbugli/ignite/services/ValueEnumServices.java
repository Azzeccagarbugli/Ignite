package com.github.azzeccagarbugli.ignite.services;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.ValueEnum;
import com.github.azzeccagarbugli.ignite.repositories.ValueEnumRepository;

@Service
public class ValueEnumServices {

	@Autowired
	private ValueEnumRepository repository;

	private List<String> getEnumByName(String name) {
		return repository.findByName(name).get(0).getValues();
	}

	public List<String> getColors() {
		return getEnumByName("color");
	}

	public List<String> getAttacks() {
		return getEnumByName("attack");
	}

	public List<String> getOpenings() {
		return getEnumByName("opening");
	}

	public List<String> getTypes() {
		return getEnumByName("type");
	}

	public List<String> getPressures() {
		return getEnumByName("pressure");
	}

	public List<String> getVehicles() {
		return getEnumByName("vehicle");
	}
	
	public ValueEnum addValues(ValueEnum valueEnum) {
		valueEnum.setId(UUID.randomUUID());
		return repository.insert(valueEnum);
	}
}
