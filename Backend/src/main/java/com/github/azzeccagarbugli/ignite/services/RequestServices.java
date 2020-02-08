package com.github.azzeccagarbugli.ignite.services;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.models.Request;
import com.github.azzeccagarbugli.ignite.repositories.RequestRepository;

@Service
public class RequestServices {

	@Autowired
	private RequestRepository repository;

	@Autowired
	private HydrantServices hydrantServices;

	@Autowired
	private UserServices userServices;

	public void addRequest(Hydrant hydrant, boolean isFireman, String userMail) {

		Request newRequest = new Request();
		newRequest.setApproved(isFireman);
		newRequest.setOpen(!isFireman);
		newRequest.setHydrant(hydrantServices.addHydrant(hydrant).getId());
		newRequest.setRequestedBy(userServices.getUserByMail(userMail).getId());
		if (isFireman) {
			newRequest.setApprovedBy(userServices.getUserByMail(userMail).getId());
		}
		newRequest.setId(UUID.randomUUID());
		repository.insert(newRequest);
	}

	public void approveRequest(Hydrant hydrant, Request request, String userMail) {
		hydrantServices.updateHydrant(hydrant);
		request.setApproved(true);
		request.setOpen(false);
		request.setApprovedBy(userServices.getUserByMail(userMail).getId());
		repository.save(request);
	}

	public void denyRequest(Request request) {
		hydrantServices.deleteHydrant(request.getHydrant());
		repository.delete(request);
	}

	public List<Request> getApprovedRequests() {
		return repository.findAll().stream().filter(request -> !request.isOpen() && request.isApproved())
				.collect(Collectors.toList());
	}

	public List<Request> getRequestsByDistance(double latitude, double longitude, double distance) {
		return repository.findAll().stream().filter(request -> {
			Hydrant hydrant = hydrantServices.getHydrantById(request.getHydrant());
			return (hydrant.getGeopoint().distance(latitude, longitude) < distance);
		}).collect(Collectors.toList());
	}

	public List<Request> getRequests() {
		return repository.findAll();
	}

	public List<Request> getPendingRequestsByDistance(double latitude, double longitude, double distance) {
		return this.getRequestsByDistance(latitude, longitude, distance).stream()
				.filter(request -> request.isOpen() && !request.isApproved()).collect(Collectors.toList());
	}
}
