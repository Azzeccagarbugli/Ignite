package com.github.azzeccagarbugli.ignite.services;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.GeoLocation;
import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.models.Request;
import com.github.azzeccagarbugli.ignite.models.User;
import com.github.azzeccagarbugli.ignite.repositories.RequestRepository;

import lombok.NonNull;

@Service
public class RequestServices {

	@Autowired
	private RequestRepository repository;

	@Autowired
	private HydrantServices hydrantServices;

	@Autowired
	private UserServices userServices;

	public Request addRequest(@NonNull Hydrant hydrant, @NonNull UUID userId) {
		User requestingUser = userServices.getUserById(userId);
		if (requestingUser == null) {
			return null;
		}
		Request newRequest = new Request();
		newRequest.setApproved(requestingUser.isFireman());
		newRequest.setOpen(!requestingUser.isFireman());
		newRequest.setHydrant(hydrantServices.addHydrant(hydrant).getId());

		newRequest.setRequestedBy(requestingUser.getId());
		if (requestingUser.isFireman()) {
			newRequest.setApprovedBy(requestingUser.getId());
		}
		newRequest.setId(UUID.randomUUID());
		return repository.insert(newRequest);
	}

	public boolean approveRequest(@NonNull Hydrant hydrant, @NonNull UUID requestId, @NonNull UUID userId) {
		hydrantServices.updateHydrant(hydrant);
		User approvingUser = userServices.getUserById(userId);

		Request toApprove = this.getRequestById(requestId);
		if (toApprove == null || approvingUser == null || !hydrant.getId().equals(toApprove.getRequestedBy())
				|| !approvingUser.isFireman()) {
			return false;
		}
		toApprove.setApproved(true);
		toApprove.setOpen(false);
		toApprove.setApprovedBy(approvingUser.getId());
		repository.save(toApprove);
		return true;
	}

	public boolean denyRequest(@NonNull UUID requestId, @NonNull UUID userId) {
		User approvingUser = userServices.getUserById(userId);
		if (approvingUser == null || !approvingUser.isFireman()) {
			return false;
		}
		Request requestToDeny = this.getRequestById(requestId);
		if (requestToDeny == null) {
			return false;
		}
		Hydrant hydrantToDeny = hydrantServices.getHydrantById(requestToDeny.getHydrant());
		if (hydrantToDeny == null) {
			return false;
		}
		hydrantServices.deleteHydrant(hydrantToDeny.getId());
		repository.deleteById(requestToDeny.getId());
		return true;
	}

	public List<Request> getApprovedRequests() {
		return repository.findAll().stream().filter(request -> !request.isOpen() && request.isApproved())
				.collect(Collectors.toList());
	}

	public List<Request> getRequestsByDistance(double latitude, double longitude, double distance) {
		return repository.findAll().stream().filter(request -> {
			Hydrant hydrant = hydrantServices.getHydrantById(request.getHydrant());
			return (hydrant.getGeopoint().distanceFrom(new GeoLocation(latitude, longitude)) < distance);
		}).collect(Collectors.toList());
	}

	public List<Request> getRequests() {
		return repository.findAll();
	}

	public List<Request> getPendingRequests() {
		return this.getRequests().stream().filter(request -> request.isOpen() && !request.isApproved())
				.collect(Collectors.toList());
	}

	public List<Request> getPendingRequestsByDistance(double latitude, double longitude, double distance) {
		return this.getRequestsByDistance(latitude, longitude, distance).stream()
				.filter(request -> request.isOpen() && !request.isApproved()).collect(Collectors.toList());
	}

	private Request getRequestById(@NonNull UUID id) {
		try {
			return repository.findById(id).get();
		} catch (NoSuchElementException e) {
			return null;
		}
	}
}
