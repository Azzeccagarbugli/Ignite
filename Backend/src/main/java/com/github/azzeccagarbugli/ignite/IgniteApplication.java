package com.github.azzeccagarbugli.ignite;


import java.util.Arrays;
import java.util.Date;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.github.azzeccagarbugli.ignite.models.Department;
import com.github.azzeccagarbugli.ignite.models.GeoLocation;
import com.github.azzeccagarbugli.ignite.models.Hydrant;
import com.github.azzeccagarbugli.ignite.models.User;
import com.github.azzeccagarbugli.ignite.models.ValueEnum;
import com.github.azzeccagarbugli.ignite.models.User.Role;
import com.github.azzeccagarbugli.ignite.services.DepartmentServices;
import com.github.azzeccagarbugli.ignite.services.RequestServices;
import com.github.azzeccagarbugli.ignite.services.UserServices;
import com.github.azzeccagarbugli.ignite.services.ValueEnumServices;

@SpringBootApplication
public class IgniteApplication implements CommandLineRunner {

	@Autowired
	private DepartmentServices departmentServices;
	@Autowired
	private RequestServices requestServices;
	@Autowired
	private UserServices userServices;
	@Autowired
	private ValueEnumServices valueEnumServices;

	public static void main(String[] args) {
		SpringApplication.run(IgniteApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		Department depAncona = new Department();
		depAncona.setCap("60100");
		depAncona.setCity("Ancona");
		depAncona.setGeopoint(new GeoLocation(43.6081285, 13.513968));
		depAncona.setMail("com.ancona@cert.vigilfuoco.it");
		depAncona.setPhoneNumber("071280801");
		depAncona.setStreetName("Via Valle Miano");
		depAncona.setStreetNumber("50");
		UUID depAnconaID = departmentServices.addDepartment(depAncona).getId();

		ValueEnum types = new ValueEnum();
		types.setName("type");
		types.setValues(Arrays.asList("Colonna", "Muro", "Colonna con cappellotto", "Interrato"));
		valueEnumServices.addValues(types);
		ValueEnum colors = new ValueEnum();
		colors.setName("color");
		colors.setValues(Arrays.asList("Rosso", "Giallo", "Arancione", "Bianco", "Nero"));
		valueEnumServices.addValues(colors);
		ValueEnum attacks = new ValueEnum();
		attacks.setName("attack");
		attacks.setValues(Arrays.asList("2x45", "1x70", "1x45", "2x70", "1x100"));
		valueEnumServices.addValues(attacks);
		ValueEnum pressures = new ValueEnum();
		pressures.setName("pressure");
		pressures.setValues(Arrays.asList("1 bar", "2 bar", "3 bar"));
		valueEnumServices.addValues(pressures);
		ValueEnum vehicles = new ValueEnum();
		vehicles.setName("vehicle");
		vehicles.setValues(Arrays.asList("ABP", "Automezzo", "APS", "Chilolitrica", "Ca Idrica", "Act Boschivo"));
		valueEnumServices.addValues(vehicles);
		ValueEnum openings = new ValueEnum();
		openings.setName("opening");
		openings.setValues(Arrays.asList("Chiave", "Chiave polifunzionale"));
		valueEnumServices.addValues(openings);

		User pompiere = new User();
		pompiere.setBirthday(new Date());
		pompiere.setCap("60027");
		pompiere.setMail("pompiere@mail.com");
		pompiere.setDepartment(depAnconaID);
		pompiere.setFacebook(false);
		pompiere.setGoogle(false);
		pompiere.setFirstAccess(false);
		pompiere.setRole(Role.FIREMAN);
		pompiere.setName("Francesco");
		pompiere.setSurname("Stelluti");
		pompiere.setStreetNameNumber("Via Coppi 30");
		UUID pompiereId = userServices.addUser(pompiere).getId();

		User cittadino = new User();
		cittadino.setMail("cittadino@mail.com");
		cittadino.setFacebook(false);
		cittadino.setRole(Role.CITIZEN);
		cittadino.setFirstAccess(false);
		cittadino.setGoogle(false);
		UUID cittadinoId = userServices.addUser(cittadino).getId();

		User admin = new User();
		admin.setMail("admin@mail.com");
		admin.setRole(Role.ADMIN);
		userServices.addUser(admin);
		
		Hydrant idranteUno = new Hydrant();
		idranteUno.setAttacks(Arrays.asList("2x45", "2x45"));
		idranteUno.setBar("1 bar");
		idranteUno.setCap("62100");
		idranteUno.setColor("Rosso");
		idranteUno.setCity("Piediripa");
		idranteUno.setGeopoint(new GeoLocation(43.2777185, 13.5043565));
		idranteUno.setLastCheck(new Date());
		idranteUno.setNotes("Multiplex");
		idranteUno.setOpening("Chiave polifunzionale");
		idranteUno.setStreetName("Via Giovan Battista Velluti");
		idranteUno.setStreetNumber("5");
		idranteUno.setType("Colonna");
		idranteUno.setVehicle("ABP");

		Hydrant idranteDue = new Hydrant();
		idranteDue.setAttacks(Arrays.asList("2x45", "2x45"));
		idranteDue.setBar("1 bar");
		idranteDue.setCap("62032");
		idranteDue.setColor("Rosso");
		idranteDue.setCity("Camerino");
		idranteDue.setGeopoint(new GeoLocation(43.1471347, 13.067087500000014));
		idranteDue.setLastCheck(new Date());
		idranteDue.setNotes("https://youtu.be/4-VLmhQSzr8");
		idranteDue.setOpening("Chiave polifunzionale");
		idranteDue.setStreetName("Via D'accorso");
		idranteDue.setStreetNumber("5");
		idranteDue.setType("Colonna");
		idranteDue.setVehicle("ABP");

		requestServices.addRequest(idranteUno, pompiereId);
		requestServices.addRequest(idranteDue, pompiereId);
	}
}
