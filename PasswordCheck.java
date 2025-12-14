
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordCheck {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String raw = "admin123";
        String hash = "$2a$10$21ZmUkxQafc4Ch2g.W8Y.uFskVQnxIkPSAgrM2j83SgPk6vEbZsiO";
        boolean matches = encoder.matches(raw, hash);
        System.out.println("Matches: " + matches);
        System.out.println("New Hash: " + encoder.encode(raw));
    }
}
