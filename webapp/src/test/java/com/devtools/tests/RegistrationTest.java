package com.devtools.tests;
 
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
 
public class RegistrationTest {
 
    @Test
    public void testValidEmail() {
        String email = "user@example.com";
        assertTrue(email.matches("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$"));
    }
 
    @Test
    public void testInvalidMobileNumber() {
        String mobile = "12345";
        assertFalse(mobile.matches("[0-9]{10}"));
    }
 
    @Test
    public void testValidPassword() {
        String password = "Dev@1234";
        assertTrue(password.matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%])[A-Za-z\\d!@#$%]{8,10}$"));
    }
 
    @Test
    public void testPasswordMismatch() {
        String pwd = "Dev@1234";
        String confirmPwd = "Dev@12345";
        assertNotEquals(pwd, confirmPwd);
    }
}