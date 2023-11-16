import express, { Express, Request, Response } from 'express';
import dotenv from 'dotenv';
import { ServerApiVersion, MongoClient } from 'mongodb';
import cors from 'cors';
import router from "./route";

dotenv.config();

const app: Express = express();
const port = process.env.PORT;


app.use(cors());
app.use(express.json());
app.use("/api", router);


const client = new MongoClient(process.env.MONGO_DB_LOGIN as string, {
    serverApi: {
      version: ServerApiVersion.v1,
      strict: true,
      deprecationErrors: true,
    }
  });
  

client.connect().then(async (client) => {
    console.log("Connected to MongoDB");

    app.listen(port, () => {
        console.log(`⚡️ Server is running at http://localhost:${port}`);
      });
}).catch((err) => {
    console.log(err);
});

