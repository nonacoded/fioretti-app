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

    const event = await EventsDao.getSchoolEventById(new ObjectId(eventId));
    if (event == null) {
        res.status(500).json({message: "Niet gelukt om event op te halen"});
        return;
    }


    const ticket: Ticket = {
        _id: new ObjectId(),
        eventId: new ObjectId(eventId),
        userId: user._id,
        createdAt: new Date(),
        expiresAt: new Date(event.date.getTime() + 1000 * 60 * 60 * 24 * 2) // expires after 2 days
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
    const tickets = await TicketsDao.getTicketsByUserId(user._id);
    if (tickets == null) {
        res.status(500).json({message: "Niet gelukt om tickets op te halen"});
        return;
    }


    if (req.query.event) {
        getTicketByUserIdAndEventId(req, res, next, user);
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


async function getTicketByUserIdAndEventId(req: Request, res: Response, next: NextFunction, user: User) {

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



export async function getTicketById(req: Request, res: Response, next: NextFunction) {
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
            res.status(500).json({message: "Niet gelukt om ticket op te halen"});
            return;
        }

        ticket = t;
    } catch (e) {
        res.status(500).json({message: `Niet gelukt om ticket op te halen (${e})`});
        return;
    }
    


    if (ticket.userId.toString() != user._id.toString()) {
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