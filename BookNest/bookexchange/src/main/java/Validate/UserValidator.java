package Validate;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import dto.UserDTO;

public class UserValidator {
	
	private static final Pattern Email_Pattern = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
	
	private static final Pattern Fullname_Pattern = Pattern.compile("^[A-Za-z\\s]{2,50}$");
	
	public static ValidationResult validate(UserDTO form) {
		
		Map<String, String> feildErrors = new HashMap<>();
		
		if(isNullOrEmpty(form.getFullname())) {
			feildErrors.put("fullName", "Fullname is required.");
		}
		
		if(isNullOrEmpty(form.getEmail())) {
			feildErrors.put("email", "Email is required.");
		}
		
		if(isNullOrEmpty(form.getPassword())) {
			feildErrors.put("password", "Password is required.");
		}
		
		if(isNullOrEmpty(form.getPhone())) {
			feildErrors.put("phone", "Phone number is required.");
		}
		
		if(feildErrors.isEmpty()) {
			if(!Email_Pattern.matcher(form.getEmail()).matches()) {
				feildErrors.put("email", "Invalid email address.");
			}
			
			String password = form.getPassword();
			if(password.length() < 8) {
				feildErrors.put("password", "Password must be at least 8 characters.");
			}
			
			if(!password.matches(".*\\d.*")) {
				feildErrors.put("password", "Password must contain at least one digit.");
			}
			
			if(!Fullname_Pattern.matcher(form.getFullname()).matches()) {
				feildErrors.put("fullName", "Full name should only contain letters and spaces (2-50 chars).");
			}
		}
		
		boolean isValid = feildErrors.isEmpty();
		
		return new ValidationResult(isValid, feildErrors);
		
		
	}
	
	private static boolean isNullOrEmpty(String str) {
		return str == null || str.trim().isEmpty();
		
	}

}
