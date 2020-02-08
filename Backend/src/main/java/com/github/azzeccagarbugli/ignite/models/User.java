package com.github.azzeccagarbugli.ignite.models;

import java.util.Date;
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
@Document(collection = "user")
public class User {
	@EqualsAndHashCode.Include
	@Id
	private UUID id;
	private UUID department;
	private Date birthday;
	private String cap;

	private String mail;

	private String name;
	private String surname;
	private String streetNameNumber;
	private boolean isFacebook;
	private boolean isFireman;
	private boolean isFirstAccess;
	private boolean isGoogle;
}
