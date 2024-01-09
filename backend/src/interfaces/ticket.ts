import { ObjectId } from "mongodb";


export default interface Ticket {
    _id: ObjectId;
    eventId: ObjectId;
    userId: ObjectId;
}