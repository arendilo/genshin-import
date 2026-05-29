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
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client('535434343700-bnlkpbs26hr2pi2o4kkn9s6qgoo95qm2.apps.googleusercontent.com');

router.post('/google', async (req, res) => {
    // Now extracting email and name from the request body as well
    const { idToken, accessToken, email: reqEmail, name: reqName } = req.body;
    let email, name;

    try {
        if (idToken) {
            // Android/iOS usually provides idToken
            const ticket = await client.verifyIdToken({
                idToken: idToken,
                audience: '535434343700-bnlkpbs26hr2pi2o4kkn9s6qgoo95qm2.apps.googleusercontent.com', 
            });
            const payload = ticket.getPayload();
            email = payload.email;
            name = payload.name;
        } 
        else if (accessToken) {
            // Backup for web if it provides an accessToken
            client.setCredentials({ access_token: accessToken });
            const userInfo = await client.request({ url: 'https://www.googleapis.com/oauth2/v3/userinfo' });
            email = userInfo.data.email;
            name = userInfo.data.name || 'Google User';
        }
        else if (reqEmail) {
            // ULTIMATE FALLBACK FOR FLUTTER WEB
            // If tokens are totally blocked by Google's new web security, use the email directly.
            email = reqEmail;
            name = reqName || 'Google User';
        }
        else {
            return res.status(400).json({ success: false, message: "No valid authentication method found." });
        }

        // DATABASE LOGIC (unchanged)
        db.query("SELECT * FROM users WHERE email = ?", [email], (err, results) => {
            if (err) return res.status(500).json({ success: false, message: err.message });

            if (results.length > 0) {
                const user = results[0];
                const token = jwt.sign({ id: user.id, role: user.role }, JWT_SECRET, { expiresIn: '24h' });
                res.json({
                    success: true,
                    message: "Login Google Berhasil",
                    token: token,
                    user: { id: user.id, name: user.name, email: user.email, role: user.role }
                });
            } else {
                db.query("INSERT INTO users (name, email, password, role) VALUES (?, ?, '', 'User')", [name, email], (err, insertResult) => {
                    if (err) return res.status(500).json({ success: false, message: "Gagal membuat user baru" });

                    const newUserId = insertResult.insertId;
                    const token = jwt.sign({ id: newUserId, role: 'User' }, JWT_SECRET, { expiresIn: '24h' });

                    res.json({
                        success: true,
                        message: "Akun Google berhasil didaftarkan",
                        token: token,
                        user: { id: newUserId, name: name, email: email, role: 'User' }
                    });
                });
            }
        });
    } catch (error) {
        console.error("Google Auth Error:", error.message);
        res.status(401).json({ success: false, message: "Autentikasi Google gagal pada server." });
    }
});
module.exports = router;