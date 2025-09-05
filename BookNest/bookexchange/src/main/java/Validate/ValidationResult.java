package Validate;

import java.util.Map;

public class ValidationResult {
	
	private boolean valid;
	private Map<String, String> feildErrors;
	
	public ValidationResult(boolean valid, Map<String, String> feildErrors) {
		this.valid = valid;
		this.feildErrors = feildErrors;
	}
	
	public boolean isValid() {
		return valid;
	}
	
	public Map<String, String> getFeildErrors(){
		return feildErrors;
	}

}
