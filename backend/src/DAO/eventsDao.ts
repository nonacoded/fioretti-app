import { MongoClient, Collection } from "mongodb";
import { ObjectId, UUID } from "bson";
import log from "../logger";
import LogLevel from "../enums/logLevel";
import SchoolEvent from "../interfaces/event";



let events: Collection<SchoolEvent>;


export default class EventsDao {
    static async injectDB(conn: MongoClient) {
        if (events) {
            return;
        }
        try {
            events = await conn.db(process.env.DB_NAME).collection("events");
        } catch (e) {
            log(LogLevel.Error, `Unable to establish collection handles in eventsDAO: ${e}`);
        }
    }


    static async getSchoolEvents() {
        try {
            return await events.find().toArray();
        } catch (e) {
            log(LogLevel.Error, `Unable to issue find command in events, ${e}`);
            return null;
        }
    }

    static async insertSchoolEvent(event: SchoolEvent) 
    { 
        try {
            return await events.insertOne(event);
        } catch (e) {
            log(LogLevel.Error, `Unable to issue insert command in events, ${e}`);
            return null;
        }
    }
}