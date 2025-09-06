package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

	public static String getPassword(String pass) {
		return BCrypt.hashpw(pass, BCrypt.gensalt());
	}
	
	public static boolean checkPassword(String pass, String hashpass) {
		return BCrypt.checkpw(pass, hashpass);
	}
}
