package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

	public static String getPassword(String pass) {
		return BCrypt.hashpw(pass, BCrypt.gensalt());
	}
}
