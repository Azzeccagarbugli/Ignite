package com.github.azzeccagarbugli.ignite.models;


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
@Document(collection = "enum")
public class ValueEnum {

	@EqualsAndHashCode.Include
	@Id
	private UUID id;
	private String name;
	private List<String> values;
}
