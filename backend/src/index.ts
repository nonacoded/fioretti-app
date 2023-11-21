import express, { Express, Request, Response } from 'express';
import dotenv from 'dotenv';
import { ServerApiVersion, MongoClient } from 'mongodb';
import cors from 'cors';
import router from "./route";
import EventsDao from './DAO/eventsDao';


// Load environment variables from .env file, where API keys and passwords are configured
dotenv.config();


// Create Express server
const app: Express = express();
const port = process.env.PORT;

// Express configuration
app.use(cors());
app.use(express.json());
app.use("/api", router);

// Connect to MongoDB
const client = new MongoClient(process.env.MONGO_DB_LOGIN as string, {
    serverApi: {
      version: ServerApiVersion.v1,
      strict: true,
      deprecationErrors: true,
    }
  });
  
client.connect().then(async (client) => {
    console.log("Connected to MongoDB");

    // Inject the database connection into the DAOs
    EventsDao.injectDB(client);


    // Start the server
    app.listen(port, () => {
        console.log(`⚡️ Server is running at http://localhost:${port}`);
      });
}).catch((err) => {
    console.log(err);
});

