import { MongoClient, Collection } from "mongodb";
import { ObjectId, UUID } from "bson";
import log from "../logger";
import LogLevel from "../enums/logLevel";
import SchoolEvent from "../interfaces/event";
import Ticket from "../interfaces/ticket";



let tickets: Collection<Ticket>;

/**
 * Data Access Object for events
 * 
 */
export default class TicketsDao {
    static async injectDB(conn: MongoClient) {
        if (tickets) {
            return;
        }
        try {
            tickets = await conn.db(process.env.DB_NAME).collection("tickets");
        } catch (e) {
            log(LogLevel.Error, `Unable to establish collection handles in ticketsDao: ${e}`);
        }
    }


    static async getTicketById(id: ObjectId) {
        try {
            return await tickets.findOne({ _id: id });
        } catch (e) {
            log(LogLevel.Error, `Unable to issue find command in events, ${e}`);
            return null;
        }
    }

    
    static async getTicketsByUserId(userId: ObjectId) {
        try {
            return await tickets.find({ userId: userId }).toArray();
        } catch (e) {
            log(LogLevel.Error, `Unable to issue find command in events, ${e}`);
            return null;
        }
    }

    static async getTicketByUserIdAndEventId(userId: ObjectId, eventId: ObjectId) {
        try {
            return await tickets.findOne({ userId: userId, eventId: eventId });
        } catch (e) {
            log(LogLevel.Error, `Unable to issue find command in events, ${e}`);
            return null;
        }
    }


    /**
     * Inserts a new event into the database
     * @param ticket The event to insert into the database
     * @returns {InsertOneResult | null} Returns the result of the insert command or null if an error occured
     */
    static async insertTicket(ticket: Ticket) 
    { 
        try {
            return await tickets.insertOne(ticket);
        } catch (e) {
            log(LogLevel.Error, `Unable to issue insert command in tickets, ${e}`);
            return null;
        }
    }
}