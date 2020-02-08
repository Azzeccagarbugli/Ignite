package com.github.azzeccagarbugli.ignite.models;


import java.util.UUID;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Document(collection = "department")
public class Department {

	@EqualsAndHashCode.Include
	@Id
	private UUID id;
	private String cap;
	private String city;
	private GeoLocation geopoint;
	private String mail;
	private String streetName;
	private String streetNumber;
	private String phoneNumber;
}
