const { authenticateToken, requireAdmin } = require('../middleware/auth');
const express = require('express');
const router = express.Router();
const db = require('../config/db');
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});
const upload = multer({ storage: storage });

// GET ALL PRODUCTS
router.get('/', (req, res) => {
    db.query("SELECT * FROM products ORDER BY id DESC", (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// GET PRODUCT BY ID
router.get('/:id', (req, res) => {
    db.query("SELECT * FROM products WHERE id = ?", [req.params.id], (err, results) => {
        if (err) return res.status(500).json(err);
        if (results.length > 0) res.json(results[0]);
        else res.status(404).json({ message: "No product!" });
    });
});

// CREATE PRODUCT
router.post('/', authenticateToken, requireAdmin, upload.single('image'), (req, res) => {
    const { name, type, rarity, price, stock, description } = req.body;
    const imageUrl = req.file ? `http://localhost:${process.env.PORT || 3000}/uploads/${req.file.filename}` : null;
    const query = "INSERT INTO products (name, type, rarity, price, stock, description, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
    db.query(query, [name, type, rarity, price, stock, description, imageUrl], (err, result) => {
        if (err) return res.status(500).json({ success: false, message: err.message });
        res.json({ success: true, message: "New weapon added!", id: result.insertId });
    });
});

// UPDATE PRODUCT
router.put('/:id', authenticateToken, requireAdmin, upload.single('image'), (req, res) => {
    const { name, type, rarity, price, stock, description } = req.body;
    const productId = req.params.id;

    let query, params;
    if (req.file) {
        const imageUrl = `http://localhost:${process.env.PORT || 3000}/uploads/${req.file.filename}`;
        query = "UPDATE products SET name=?, type=?, rarity=?, price=?, stock=?, description=?, image=? WHERE id=?";
        params = [name, type, rarity, price, stock, description, imageUrl, productId];
    } else {
        query = "UPDATE products SET name=?, type=?, rarity=?, price=?, stock=?, description=? WHERE id=?";
        params = [name, type, rarity, price, stock, description, productId];
    }

    db.query(query, params, (err) => {
        if (err) return res.status(500).json({ success: false, message: err.message });
        res.json({ success: true, message: "Weapon Updated!" });
    });
});

// DELETE PRODUCT
router.delete('/:id', authenticateToken, requireAdmin,(req, res) => {
    db.query("DELETE FROM products WHERE id = ?", [req.params.id], (err) => {
        if (err) return res.status(500).json(err);
        res.json({ success: true, message: "Weapon deleted!" });
    });
});

module.exports = router;