import { ObjectId } from "mongodb";
import { Request, Response, NextFunction } from "express";
import User from "../interfaces/user";
import { getUserFromSessionCookie } from "./auth";
import ApiFuncError from "../interfaces/apiFuncError";
import Ticket from "../interfaces/ticket";
import TicketsDao from "../DAO/ticketsDao";
import SchoolEvent from "../interfaces/event";
import EventsDao from "../DAO/eventsDao";


export async function createTicket(req: Request, res: Response, next: NextFunction) {
    let sessionCookie = req.cookies["session"];

    let user: User;
    try {
        user = await getUserFromSessionCookie(sessionCookie);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }

    const eventId = req.params.id;

    if (eventId == null) {
        res.status(400).json({message: "eventId is null"});
        return;
    }

    const ticket: Ticket = {
        _id: new ObjectId(),
        eventId: new ObjectId(eventId),
        userId: user._id
    };

    const result = await TicketsDao.insertTicket(ticket);
    if (result == null) {
        res.status(500).json({message: "Niet gelukt om ticket toe te voegen"});
        return;
    }

    res.status(200).json({message: "Ticket inserted"});
}


export async function getTickets(req: Request, res: Response, next: NextFunction) {
    let sessionCookie = req.cookies["session"];

    let user: User;
    try {
        user = await getUserFromSessionCookie(sessionCookie);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }
    console.log(user._id);
    const tickets = await TicketsDao.getTicketsByUserId(user._id);
    if (tickets == null) {
        res.status(500).json({message: "Niet gelukt om tickets op te halen"});
        return;
    }

    console.log(tickets);

    interface TicketWithEvent {
        _id: ObjectId,
        eventId: ObjectId,
        userId: ObjectId,
        event: SchoolEvent
    }

    let ticketsWithEvents: TicketWithEvent[] = [];

    for (let ticket of tickets) {
        const event = await EventsDao.getSchoolEventById(ticket.eventId);
        if (event == null) {
            res.status(500).json({message: `Niet gelukt om event ${ticket.eventId} op te halen`});
            return;
        }

        ticketsWithEvents.push({
            _id: ticket._id,
            eventId: ticket.eventId,
            userId: ticket.userId,
            event: event
        });
    }

    console.log(ticketsWithEvents);

    res.status(200).json(ticketsWithEvents);
}


export async function getTicker(req: Request, res: Response, next: NextFunction) {

}