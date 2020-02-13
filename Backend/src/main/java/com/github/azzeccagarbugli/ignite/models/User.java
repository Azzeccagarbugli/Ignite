package com.github.azzeccagarbugli.ignite.models;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.UUID;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@SuppressWarnings("serial")
@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Document(collection = "user")
public class User implements UserDetails {
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
	private Role role;

	public enum Role {
		CITIZEN, FIREMAN, ADMIN;
	}

	private String password = new BCryptPasswordEncoder().encode("Ignite");

	private boolean isFirstAccess;
	private boolean isGoogle;

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		ArrayList<GrantedAuthority> auth = new ArrayList<GrantedAuthority>();
		auth.add(new SimpleGrantedAuthority(role.name()));
		return auth;
	}

	@Override
	public String getUsername() {
		return id.toString();
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}
	
	public boolean isFireman() {
		return this.role.equals(Role.FIREMAN);
	}
}
