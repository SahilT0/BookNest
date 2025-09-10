package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

	public static String getPassword(String pass) {
		return BCrypt.hashpw(pass, BCrypt.gensalt());
	}
	
	public static boolean checkPassword(String pass, String hashpass) {
		return BCrypt.checkpw(pass, hashpass);
	}
	
	public static void main(String argd[]) {
		System.out.println(BCrypt.checkpw("@Sahil1540", "$2a$10$GwWg9wBDcBiKStMKTO3ZUOt5NyY.l8F7wx7m..dhd5LVKPwumV9Lu"));
	}
}
