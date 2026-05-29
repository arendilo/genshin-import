const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.status(401).json({ message: "Access Denied! Please login." });

    jwt.verify(token, process.env.JWT_SECRET || 'A9xQ2B5vM8cT4kP1rY7wL3zJ6nH0mF', (err, user) => {
        if (err) return res.status(403).json({ message: "Session Expired, Please login." });
        req.user = user;
        next();
    });
};

const requireAdmin = (req, res, next) => {
    if (req.user && req.user.role.toLowerCase() === 'admin') {
        next();
    } else {
        return res.status(403).json({ message: "Access Denied! Only Admins can perform this action." });
    }
};

module.exports = { authenticateToken, requireAdmin };