package com.github.azzeccagarbugli.ignite.restcontrollers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.models.Request;
import com.github.azzeccagarbugli.ignite.services.RequestServices;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@RestController
@RequestMapping("ignite/api/request")
public class RequestController {

	@Autowired
	private RequestServices requestServices;

	@PostMapping("/new")
	public void addRequest(@RequestBody NewRequest newRequest) {
		requestServices.addRequest(newRequest.hydrant, newRequest.isFireman, newRequest.userMail);
	}

	@PostMapping("/approve")
	public void approveRequest(@RequestBody ApprovedRequest approvedRequest) {
		requestServices.approveRequest(approvedRequest.hydrant, approvedRequest.request, approvedRequest.userMail);
	}

	@PostMapping("/deny")
	public void denyRequest(@RequestBody Request request) {
		requestServices.denyRequest(request);
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

	@Setter
	@Getter
	@NoArgsConstructor
	@AllArgsConstructor
	static class NewRequest {
		private Hydrant hydrant;
		private boolean isFireman;
		private String userMail;
	}

	@Setter
	@Getter
	@NoArgsConstructor
	@AllArgsConstructor
	static class ApprovedRequest {
		private Hydrant hydrant;
		private Request request;
		private String userMail;
	}

}
