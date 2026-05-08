const express = require('express');
const { Level } = require('level');

const app = express();

//const db = new Level(process.env.DB_PATH || './leveldb');  Testing withouth PVC 
const db = new Level(process.env.DB_PATH || '/data/leveldb');

app.get('/health', (req, res) => {
  res.send('OK');
});

app.get('/ready', (req, res) => {
  res.send('READY');
});

app.get('/write', async (req, res) => {
  try {
    await db.put('message', 'hello-leveldb');
    res.send('Data written');
  } catch (err) {
    console.error(err);
    res.status(500).send(err.message);
  }
});

app.get('/read', async (req, res) => {
  try {
    const value = await db.get('message');
    res.send(value);
  } catch (err) {
    res.send('No data found');
  }
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Server running on port 3000');
});