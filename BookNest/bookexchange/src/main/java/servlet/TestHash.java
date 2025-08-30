package servlet;
import org.mindrot.jbcrypt.BCrypt;

public class TestHash {
	public static void main(String [] args) {
		String password = "";
		String hash = BCrypt.hashpw(password, BCrypt.gensalt());
		System.out.println(hash);
	}

}
