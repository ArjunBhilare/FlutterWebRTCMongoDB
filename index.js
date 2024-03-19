const express = require('express');
const app = express();
const mongoose = require('mongoose');  
const { MONGO_DB_CONFIG } = require('./config/app.config');
const http = require("http");
const server = http.createServer(app);
const { initMeetingServer } = require('./meeting-server');

initMeetingServer(server);

mongoose.Promise = global.Promise;
mongoose.connect(MONGO_DB_CONFIG.DB, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log("Successfully connected to the database");    
}).catch(err => {
    console.log('Could not connect to the database. Exiting now...', err);
});

app.use(express.json());
app.use("/api", require("./routes/app.routes"));

// Specify the IP address and port here
const IP_ADDRESS = '10.0.0.8';
const PORT = process.env.PORT || 4000;

server.listen(PORT, IP_ADDRESS, function () {
    const address = server.address().address;
    const port = server.address().port;
    const protocol = server instanceof http.Server ? 'http' : 'https';
    const baseUrl = `${protocol}://${address}:${port}`;
    console.log('Server is running on', baseUrl);
});

// Call: nodemon js  // to run the server