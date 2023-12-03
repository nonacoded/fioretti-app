import { MongoClient, Collection } from "mongodb";
import { ObjectId, UUID } from "bson";
import log from "../logger";
import LogLevel from "../enums/logLevel";
import Session from "../interfaces/session";


let sessions: Collection<Session>;

/**
 * Data Access Object for users. This code interacts directly with the database.
 */
export default class SessionsDao {
    /**
     * This function is called when the server starts.
     * It passes the connection over to this class so it can be used to interact with the database.
     * @param conn MongoDB connection
     * @returns 
     */
    static async injectDB(conn: MongoClient) {
        if (sessions) {
            return;
        }
        try {
            sessions = await conn.db(process.env.DB_NAME).collection("sessions");
        } catch (e) {
            log(LogLevel.Error, `Unable to establish collection handles in sessionDAO: ${e}`);
        }
    }

    /**
     * Gets a session token by its ID.
     * @param id session ID
     * @returns session
     */
    static async getSessionById(id: UUID) {
        try {
            return await sessions.findOne({_id: id});
        } catch (e) {
            log(LogLevel.Debug, `Unable to get session: ${e}`);
            return null;
        }
    }


    static async insertSession(token: Session) {
        try {
            return await sessions.insertOne(token);
        } catch (e) {
            log(LogLevel.Debug, `Unable to insert session: ${e}`);
            return null;
        }
    }


    static async deleteSession(id: UUID) {
        try {
            return await sessions.deleteOne({_id: id});
        } catch (e) {
            log(LogLevel.Debug, `Unable to delete session: ${e}`);
            return null;
        }
    }
    
}