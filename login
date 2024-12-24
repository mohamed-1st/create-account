const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
// 
exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // 
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ msg: 'Invalid email or password' });
        }

        // 
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: 'Invalid email or password' });
        }

        // 
        const payload = { user: { id: user.id } };
        jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' }, (err, token) => {
            if (err) throw err;
            res.json({ token });
        });

    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};
const express = require('express');
const router = express.Router();
const { register, login } = require('../controllers/authController');

router.post('/register', register);
router.post('/login', login);

module.exports = router;
http://localhost:5000/api/auth/login
{
    "email": "john@example.com",
    "password": "123456"
  }

<form id="login-form">
    <input type="email" placeholder="Email" id="login-email" required>
    <input type="password" placeholder="Password" id="login-password" required>
    <button type="submit">Login</button>
</form>

<script>
document.getElementById('login-form').addEventListener('submit', async (e) => {
    e.preventDefault();

    const email = document.getElementById('login-email').value;
    const password = document.getElementById('login-password').value;

    try {
        const res = await fetch('http://localhost:5000/api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        const data = await res.json();

        if (data.token) {
            localStorage.setItem('token', data.token);
            alert('Login Successful!');
        } else {
            alert('Login Failed: ' + data.msg);
        }
    } catch (err) {
        console.error(err);
        alert('An error occurred during login');
    }
});
</script>