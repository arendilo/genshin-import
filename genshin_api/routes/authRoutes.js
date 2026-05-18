const express = require('express');
const router = express.Router();
const db = require('../config/db');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'A9xQ2B5vM8cT4kP1rY7wL3zJ6nH0mF';

// REGISTER
router.post('/register', (req, res) => {
    const { name, email, password } = req.body;
    db.query("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'User')", [name, email, password], (err) => {
        if (err) return res.status(500).json({ success: false, message: "Email is already used!" });
        res.json({ success: true, message: "Registration Successfull!" });
    });
});

// LOGIN MANUAL
router.post('/login', (req, res) => {
    const { email, password, role } = req.body;
    const query = "SELECT * FROM users WHERE email = ? AND password = ? AND role = ?";
    db.query(query, [email, password, role], (err, results) => {
        if (err) return res.status(500).json({ success: false, message: err.message });

        if (results.length > 0) {
            const user = results[0];
            const token = jwt.sign({ id: user.id, role: user.role }, JWT_SECRET, { expiresIn: '24h' });
            res.json({
                success: true,
                token: token,
                user: { id: user.id, name: user.name, email: user.email, role: user.role }
            });
        } else {
            res.status(401).json({ success: false, message: "Email/Password/Role is Incorrect!" });
        }
    });
});

// LOGIN GOOGLE OAUTH
router.post('/google', (req, res) => {
    const { email, name } = req.body;
    res.json({
        success: true,
        message: "Login By Google Successfull",
        token: "test-google-token-123",
        user: {
            id: 123,
            name: name || "bram",
            email: email || "bram@mail.com",
            role: "User"
        }
    });
});

module.exports = router;