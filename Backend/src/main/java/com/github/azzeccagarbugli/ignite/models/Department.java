package com.github.azzeccagarbugli.ignite.models;

import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Document(collection = "department")
public class Department {

}
