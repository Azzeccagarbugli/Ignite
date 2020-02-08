package com.github.azzeccagarbugli.ignite.models;


import java.awt.geom.Point2D;
import java.util.Date;
import java.util.List;
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
@Document(collection = "hydrant")
public class Hydrant {

	@EqualsAndHashCode.Include
	@Id
	private UUID id;
	private List<String> attacks;
	private String bar;
	private String cap;
	private String city;
	private String color;
	private Point2D.Double geopoint;
	private Date lastCheck;
	private String notes;
	private String streetNumber;
	private String opening;
	private String streetName;
	private String type;
	private String vehicle;
}
