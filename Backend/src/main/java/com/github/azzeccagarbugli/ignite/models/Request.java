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
@Document(collection = "request")
public class Request {

	@EqualsAndHashCode.Include
	@Id
	private UUID id;
	private boolean approved;
	private UUID approvedBy;
	private UUID hydrant;
	private boolean open;
	private UUID requestedBy;
}
