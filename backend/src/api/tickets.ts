import { ObjectId } from "mongodb";
import { Request, Response, NextFunction } from "express";
import User from "../interfaces/user";
import { getUserFromSessionCookie } from "./auth";
import ApiFuncError from "../interfaces/apiFuncError";
import Ticket from "../interfaces/ticket";
import TicketsDao from "../DAO/ticketsDao";
import SchoolEvent from "../interfaces/event";
import EventsDao from "../DAO/eventsDao";
import { TicketWithEvent, ticketToTicketWithEvent } from "../interfaces/ticket";




export async function apiClaimFreeTicket(req: Request, res: Response, next: NextFunction) {
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

    const event = await EventsDao.getSchoolEventById(new ObjectId(eventId));
    if (event == null) {
        res.status(500).json({message: "Niet gelukt om event op te halen"});
        return;
    }

    if (event.price >= 0.10 && !user.isAdmin) {
        res.status(400).json({message: "Dit evenement is niet gratis"});
        return;
    }

    let ticket: Ticket;
    try {
        ticket = await createTicket(event, user);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }
    
   

    res.status(200).json({message: "Ticket inserted"});
}



export async function createTicket(event: SchoolEvent, user: User) {
    const ticket: Ticket = {
        _id: new ObjectId(),
        eventId: event._id,
        userId: user._id,
        createdAt: new Date(),
        expiresAt: new Date(event.date.getTime() + 1000 * 60 * 60 * 24 * 2), // expires after 2 days
        isUsed: false
    };

    const result = await TicketsDao.insertTicket(ticket);
    if (result == null) {
        let err: ApiFuncError = {
            message: "Niet gelukt om ticket toe te voegen", 
            code: 500
        };
        throw err;
    }
    return ticket;

}




export async function apiGetTickets(req: Request, res: Response, next: NextFunction) {
    let sessionCookie = req.cookies["session"];

    let user: User;
    try {
        user = await getUserFromSessionCookie(sessionCookie);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }
    const tickets = await TicketsDao.getTicketsByUserId(user._id);
    if (tickets == null) {
        res.status(500).json({message: "Niet gelukt om tickets op te halen"});
        return;
    }


    if (req.query.event) {
        apiGetTicketByUserIdAndEventId(req, res, next, user);
        return;
    }
    

    let ticketsWithEvents: TicketWithEvent[] = [];

    for (let ticket of tickets) {
        let ticketWithEvent: TicketWithEvent;
        try {
            ticketWithEvent = await ticketToTicketWithEvent(ticket);
            
            ticketsWithEvents.push(ticketWithEvent);
        } catch (err) {
            const e = err as ApiFuncError;
            res.status(e.code).json({message: e.message});
            return;
        }

        ticketsWithEvents.push();
    }

    res.status(200).json(ticketsWithEvents);
}


async function apiGetTicketByUserIdAndEventId(req: Request, res: Response, next: NextFunction, user: User) {

    let eventId = req.query.event;

    if (eventId == null) {
        res.status(400).json({message: "eventId is null"});
        return;
    }

    eventId = eventId.toString();
    

    let ticket = await TicketsDao.getTicketByUserIdAndEventId(user._id, new ObjectId(eventId));
    if (ticket == null) {
        res.status(404).json({message: "Ticket niet gevonden"});
        return;
    }

    let ticketWithEvent: TicketWithEvent;
    try {
        ticketWithEvent = await ticketToTicketWithEvent(ticket);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }

    res.status(200).json(ticketWithEvent);
}



export async function apiGetTicketById(req: Request, res: Response, next: NextFunction) {
    let sessionCookie = req.cookies["session"];

    let user: User;
    try {
        user = await getUserFromSessionCookie(sessionCookie);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }

    const ticketId = req.params.id;

    if (ticketId == null) {
        res.status(400).json({message: "ticketId is null"});
        return;
    }

    let ticket: Ticket;
    console.log(ticketId);
    try {
        const t = await TicketsDao.getTicketById(new ObjectId(ticketId));
        if (t == null) {
            res.status(404).json({message: "Ticket niet gevonden"});
            return;
        }

        ticket = t;
    } catch (e) {
        res.status(500).json({message: `Niet gelukt om ticket op te halen (${e})`});
        return;
    }
    


    if (ticket.userId.toString() != user._id.toString() && !user.isAdmin) {
        res.status(403).json({message: "Je hebt geen toegang tot dit ticket"});
        return;
    }

    let ticketWithEvent: TicketWithEvent;
    try {
        ticketWithEvent = await ticketToTicketWithEvent(ticket);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }

    res.status(200).json(ticketWithEvent);
}


export async function apiMarkTicketAsUsed(req: Request, res: Response, next: NextFunction) {
    let sessionCookie = req.cookies["session"];

    console.log(req.body);

    let user: User;
    try {
        user = await getUserFromSessionCookie(sessionCookie);
    } catch (err) {
        const e = err as ApiFuncError;
        res.status(e.code).json({message: e.message});
        return;
    }

    if (!user.isAdmin) {
        res.status(403).json({ message: "Je bent geen admin" });
        return;
    }

    const ticketId = req.params.id;

    if (req.body.value == null || typeof req.body.value != "boolean") {
        res.status(400).json({message: "body.value is geen boolean"})
    }

    const value = req.body.value as boolean;

    if (value == undefined) {
        res.status(400).json({message: "value is undefined"});
        return;
    }

    let ticket = await TicketsDao.getTicketById(new ObjectId(ticketId));
    if (ticket == null) {
        res.status(404).json({message: "Ticket niet gevonden"});
        return;
    }

    ticket.isUsed = value;

    const updateResult = TicketsDao.updateTicket(ticket);

    if (updateResult == null) {
        res.status(500).json({message: "Failed to update ticket"});
        return;
    }

    res.status(200).json();
}