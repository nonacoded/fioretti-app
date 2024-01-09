import { MongoClient, Collection } from "mongodb";
import { ObjectId, UUID } from "bson";
import log from "../logger";
import LogLevel from "../enums/logLevel";
import SchoolEvent from "../interfaces/event";



let events: Collection<SchoolEvent>;

/**
 * Data Access Object for events
 * 
 */
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


    /**
     * Returns all events in the database
     * @returns {SchoolEvent[] | null} Returns an array of SchoolEvents or null if an error occured
     */
    static async getSchoolEvents() {
        try {
            return await events.find().toArray();
        } catch (e) {
            log(LogLevel.Error, `Unable to issue find command in events, ${e}`);
            return null;
        }
    }

    static async getSchoolEventById(id: ObjectId) {
        try {
            return await events.findOne({ _id: id });
        } catch (e) {
            log(LogLevel.Error, `Unable to issue find command in events, ${e}`);
            return null;
        }
    }


    static async editSchoolEvent(event: SchoolEvent) {
        try {
            return await events.updateOne({ _id: event._id }, { $set: event });
        } catch (e) {
            log(LogLevel.Error, `Unable to issue update command in events, ${e}`);
            return null;
        }
    }


    /**
     * Inserts a new event into the database
     * @param event The event to insert into the database
     * @returns {InsertOneResult | null} Returns the result of the insert command or null if an error occured
     */

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