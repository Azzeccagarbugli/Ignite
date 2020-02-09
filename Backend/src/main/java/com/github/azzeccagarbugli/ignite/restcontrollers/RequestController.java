package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.models.Request;
import com.github.azzeccagarbugli.ignite.services.RequestServices;

@RestController
@RequestMapping("ignite/api/request")
public class RequestController {

	@Autowired
	private RequestServices requestServices;

	@PostMapping("/new/{userId}")
	public Request addRequest(@RequestBody Hydrant hydrant, @PathVariable("userId") String userId) {
		return requestServices.addRequest(hydrant, UUID.fromString(userId));
	}

	@PostMapping("/approve/{requestId}&{userId}")
	public boolean approveRequest(@RequestBody Hydrant hydrant, @PathVariable("userId") String userId,
			@PathVariable("requestId") String requestId) {
		return requestServices.approveRequest(hydrant, UUID.fromString(requestId), UUID.fromString(userId));
	}

	@PostMapping("/deny/{requestId}&{userId}")
	public boolean denyRequest(@PathVariable("userId") String userId, @PathVariable("requestId") String requestId) {
		return requestServices.denyRequest(UUID.fromString(requestId), UUID.fromString(userId));
	}

	@GetMapping("/approved")
	public List<Request> getApprovedRequests() {
		return requestServices.getApprovedRequests();
	}

	@GetMapping("/all")
	public List<Request> getRequests() {
		return requestServices.getRequests();
	}

	@GetMapping("/pending")
	public List<Request> getPendingRequests() {
		return requestServices.getPendingRequests();
	}

	@GetMapping("/all/{lat}&{long}&{distance}")
	public List<Request> getRequestsByDistance(@PathVariable("lat") double latitude,
			@PathVariable("long") double longitude, @PathVariable("distance") double distance) {
		return requestServices.getRequestsByDistance(latitude, longitude, distance);
	}

	@GetMapping("/pending/{lat}&{long}&{distance}")
	public List<Request> getPendingRequestsByDistance(@PathVariable("lat") double latitude,
			@PathVariable("long") double longitude, @PathVariable("distance") double distance) {
		return requestServices.getPendingRequestsByDistance(latitude, longitude, distance);
	}

}
