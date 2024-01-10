import express, { Express, Request, Response, NextFunction } from 'express';
import dotenv from 'dotenv';
import { ServerApiVersion, MongoClient } from 'mongodb';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import router from "./route";
import EventsDao from './DAO/eventsDao';
import UsersDao from './DAO/usersDao';
import LoginConfirmationsDao from './DAO/loginConfirmationsDao';
import SessionsDao from './DAO/sessionsDao';
import TicketsDao from './DAO/ticketsDao';


// Load environment variables from .env file, where API keys and passwords are configured
dotenv.config();


// Create Express server
const app: Express = express();
const port = process.env.PORT;

// Express configuration
app.use(cors({
  origin: process.env.ADMIN_PANEL_URL,
  credentials: true
}));
app.use(express.json());
app.use(cookieParser());



// Routes
app.use("/fioretti-app-api", router);

app.use("*", (req: Request, res: Response) => {res.status(404).json({message: `Method not found: ${req.method} to ${req.originalUrl}`})});


// Error handling
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).send(`Error (${err})`);
});


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
    UsersDao.injectDB(client);
    LoginConfirmationsDao.injectDB(client);
    SessionsDao.injectDB(client);
    TicketsDao.injectDB(client);
    


    // Start the server
    app.listen(port, () => {
        console.log(`⚡️ Server is running at http://localhost:${port}`);
      });
}).catch((err) => {
    console.log(err);
});

