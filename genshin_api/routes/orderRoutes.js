const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { authenticateToken } = require('../middleware/auth');

router.post('/', authenticateToken, (req, res) => {
    const items = req.body.items;
    let userId = req.body.user_id;

    if (!items || items.length === 0) {
        return res.status(400).json({ message: "Cart is empty!" });
    }

    db.query("SELECT id FROM users LIMIT 1", (err, userRows) => {
        if (err || userRows.length === 0) {
            return res.status(500).json({ message: "Database Error: User is not found" });
        }

        const finalUserId = (userId && userId !== 0) ? userId : userRows[0].id;
        let total_price = 0;
        items.forEach(item => total_price += (item.price * item.quantity));

        db.query("INSERT INTO orders (userId, total_price, status) VALUES (?, ?, 'Completed')",
            [finalUserId, total_price], (err, orderResult) => {
                if (err) {
                    return res.status(500).json({ message: "Failed to make order", error: err });
                }

                const newOrderId = orderResult.insertId;
                let completedCount = 0;

                items.forEach(item => {
                    db.query("INSERT INTO order_items (order_id, weapon_id, weapon_name, quantity, price) VALUES (?, ?, ?, ?, ?)",
                        [newOrderId, item.id, item.name || 'Weapon', item.quantity, item.price], (err) => {

                            // UPDATE STOK KE TABEL PRODUCTS
                            db.query("UPDATE products SET stock = stock - ? WHERE id = ?", [item.quantity, item.id], () => {
                                completedCount++;
                                if (completedCount === items.length) {
                                    res.json({
                                        success: true,
                                        message: "Checkout success.",
                                        order_id: newOrderId
                                    });
                                }
                            });
                        });
                });
            });
    });
});

module.exports = router;