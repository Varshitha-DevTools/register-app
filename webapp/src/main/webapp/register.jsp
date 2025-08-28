<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<title>DevTools Registration</title>
<style>
  body {
    margin: 0;
    padding: 0;
    background-color: #1A1A1A; /* rich dark charcoal */
    color: #E0E0E0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
  }
 
  .wrapper {
    background: #242424;
    padding: 30px 40px;
    border-radius: 10px;
    width: 90%;
    max-width: 500px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.7);
  }
 
  .logo {
    width: 150px;
    height: auto;
    display: block;
    margin: 0 auto 20px;
  }
 
  h1 {
    text-align: center;
    color: #FFFFFF;
    margin-bottom: 25px;
  }
 
  label {
    display: block;
    font-weight: bold;
    margin-top: 15px;
    margin-bottom: 6px;
    color: #CCCCCC;
  }
 
  input[type="text"],
  input[type="password"] {
    width: 100%;
    padding: 12px;
    border: 1px solid #444444;
    border-radius: 5px;
    background: #333333;
    color: #FFFFFF;
    box-sizing: border-box;
  }
 
  .registerbtn {
    background-color: #2979FF;
    color: white;
    padding: 14px 0;
    margin: 25px 0;
    border: none;
    cursor: pointer;
    width: 100%;
    border-radius: 5px;
    font-size: 1.1rem;
    transition: background-color 0.3s;
  }
  .registerbtn:hover {
    background-color: #1976D2;
  }
 
  .terms {
    font-size: 0.9rem;
    color: #AAAAAA;
  }
 
  .terms a {
    color: #2979FF;
    text-decoration: none;
  }
  .terms a:hover {
    text-decoration: underline;
  }
 
  .signin {
    text-align: center;
    margin-top: 20px;
  }
 
  .signin a {
    color: #2979FF;
    text-decoration: none;
  }
  .signin a:hover {
    text-decoration: underline;
  }
</style>
<script>
  function validateForm() {
    const pw = document.getElementById('psw').value;
    const pwRepeat = document.getElementById('psw-repeat').value;
    if (pw !== pwRepeat) {
      alert("Passwords do not match!");
      return false;
    }
    return true;
  }
</script>
</head>
<body>
 
<div class="wrapper">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_qLD3DqkyZ8i6x5Qs6DThOQG_w23dYdZe2w&s"
       alt="DevTools Logo" class="logo" draggable="false">
  <h1>Create Your Account</h1>
  <form action="action_page.jsp" method="post" onsubmit="return validateForm()">
    <label for="Name">Enter Name</label>
    <input type="text" name="Name" id="Name" placeholder="Full Name" required>
 
    <label for="mobile">Enter Mobile</label>
    <input type="text" name="mobile" id="mobile"
           placeholder="10-digit Mobile" pattern="[0-9]{10}" title="Please enter a 10-digit mobile number" required>
 
    <label for="email">Enter Email</label>
    <input type="text" name="email" id="email"
           placeholder="you@example.com"
           pattern="^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$" title="Enter a valid email address" required>
 
    <label for="psw">Password</label>
    <input type="password" name="psw" id="psw"
           pattern="^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%])[A-Za-z\\d!@#$%]{8,10}$"
           title="8‑10 chars, letters, number, & a special char (!@#$%)" required>
 
    <label for="psw-repeat">Confirm Password</label>
    <input type="password" name="psw-repeat" id="psw-repeat" required>
 
    <p class="terms">By creating an account you agree to our <a href="#">Terms & Privacy</a>.</p>
    <button type="submit" class="registerbtn">Register</button>
  </form>
 
  <div class="signin">
    <p>Already have an account? <a href="#">Sign in</a>.</p>
  </div>
</div>
 
</body>
</html>
 
 