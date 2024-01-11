import { ObjectId } from "mongodb";
import { SchoolEventWithIntDate, schoolEventToSchoolEventWithIntDate } from "./event";
import ApiFuncError from "./apiFuncError";
import EventsDao from "../DAO/eventsDao";


export default interface Ticket {
    _id: ObjectId;
    eventId: ObjectId;
    userId: ObjectId;
    createdAt: Date;
    expiresAt: Date;
    isUsed: boolean
}



export interface TicketWithEvent {
    _id: ObjectId;
    eventId: ObjectId;
    userId: ObjectId;
    createdAt: number;
    expiresAt: number;
    isUsed: boolean;
    event: SchoolEventWithIntDate
}


export async function ticketToTicketWithEvent(ticket: Ticket) {

    const event = await EventsDao.getSchoolEventById(ticket.eventId);
    if (event == null) {
        const err: ApiFuncError = {
            code: 500,
            message: `Niet gelukt om event ${ticket.eventId} op te halen`
        }
        throw err;
    }

    return {
        _id: ticket._id,
        eventId: ticket.eventId,
        userId: ticket.userId,
        createdAt: ticket.createdAt.getTime(),
        expiresAt: ticket.expiresAt.getTime(),
        event: schoolEventToSchoolEventWithIntDate(event)
    } as TicketWithEvent
}