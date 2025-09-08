const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database connection with retry logic
const createConnection = () => {
    return mysql.createConnection({
        host: process.env.DB_HOST || '192.168.56.11',
        user: process.env.DB_USER || 'todouser',
        password: process.env.DB_PASSWORD || 'todopassword',
        database: process.env.DB_NAME || 'todo_app',
        acquireTimeout: 60000,
        timeout: 60000,
        reconnect: true
    });
};

let db = createConnection();

// Database connection with retry
const connectWithRetry = () => {
    db.connect((err) => {
        if (err) {
            console.error('Database connection failed:', err.stack);
            console.log('Retrying in 5 seconds...');
            setTimeout(connectWithRetry, 5000);
        } else {
            console.log('Connected to MySQL database at', process.env.DB_HOST);
        }
    });
};

// Handle disconnection
db.on('error', (err) => {
    console.error('Database error:', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        db = createConnection();
        connectWithRetry();
    }
});

connectWithRetry();

// API Routes

// Health check
app.get('/api/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        message: 'Backend VM is running',
        timestamp: new Date().toISOString(),
        database_host: process.env.DB_HOST
    });
});

// Get all todos
app.get('/api/todos', (req, res) => {
    const query = 'SELECT * FROM todos ORDER BY created_at DESC';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching todos:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        res.json(results);
    });
});

// Get single todo
app.get('/api/todos/:id', (req, res) => {
    const query = 'SELECT * FROM todos WHERE id = ?';
    db.query(query, [req.params.id], (err, results) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Todo not found' });
            return;
        }
        res.json(results[0]);
    });
});

// Create new todo
app.post('/api/todos', (req, res) => {
    const { title, description, priority = 'medium', due_date } = req.body;
    
    if (!title || title.trim() === '') {
        res.status(400).json({ error: 'Title is required' });
        return;
    }
    
    const query = 'INSERT INTO todos (title, description, priority, due_date) VALUES (?, ?, ?, ?)';
    
    db.query(query, [title, description, priority, due_date || null], (err, results) => {
        if (err) {
            console.error('Error creating todo:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        res.status(201).json({
            id: results.insertId,
            title,
            description,
            priority,
            due_date,
            completed: false,
            message: 'Todo created successfully'
        });
    });
});

// Update todo
app.put('/api/todos/:id', (req, res) => {
    const { title, description, completed, priority, due_date } = req.body;
    const query = 'UPDATE todos SET title = ?, description = ?, completed = ?, priority = ?, due_date = ? WHERE id = ?';
    
    db.query(query, [title, description, completed, priority, due_date || null, req.params.id], (err, results) => {
        if (err) {
            console.error('Error updating todo:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        if (results.affectedRows === 0) {
            res.status(404).json({ error: 'Todo not found' });
            return;
        }
        res.json({ message: 'Todo updated successfully' });
    });
});

// Delete todo
app.delete('/api/todos/:id', (req, res) => {
    const query = 'DELETE FROM todos WHERE id = ?';
    db.query(query, [req.params.id], (err, results) => {
        if (err) {
            console.error('Error deleting todo:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        if (results.affectedRows === 0) {
            res.status(404).json({ error: 'Todo not found' });
            return;
        }
        res.json({ message: 'Todo deleted successfully' });
    });
});

// Get todos statistics
app.get('/api/stats', (req, res) => {
    const query = `
        SELECT 
            COUNT(*) as total,
            SUM(completed) as completed,
            COUNT(*) - SUM(completed) as pending,
            COUNT(CASE WHEN priority = 'high' THEN 1 END) as high_priority,
            COUNT(CASE WHEN priority = 'medium' THEN 1 END) as medium_priority,
            COUNT(CASE WHEN priority = 'low' THEN 1 END) as low_priority
        FROM todos
    `;
    
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching stats:', err);
            res.status(500).json({ error: err.message });
            return;
        }
        res.json(results[0]);
    });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Backend VM server running on port ${PORT}`);
    console.log(`Connecting to database at: ${process.env.DB_HOST || '192.168.56.11'}`);
});