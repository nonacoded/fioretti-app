import { Request, Response, NextFunction } from "express";
import EventsDao from "../DAO/eventsDao";
import SchoolEvent, { SchoolEventWithIntDate, schoolEventToSchoolEventWithIntDate } from "../interfaces/event";
import { ObjectId } from "mongodb";
import { getUserFromSessionCookie } from "./auth";
import User from "../interfaces/user";
import ApiFuncError from "../interfaces/apiFuncError";



/**
 * Returns all events in the database
 * @param req Express request object, no parameters needed
 * @param res Response object
 * @param next Next function
 * @returns All events in the database
 */
export async function apiGetSchoolEvents(req: Request, res: Response, next: NextFunction) {
    let events: SchoolEvent[] | null;
    try {
        events = await EventsDao.getSchoolEvents();
    } catch (e) {
        res.status(500).json({ message: `Internal server error (${e})` });
        return;
    }
    if (!events) {
        res.status(404).json({ message: "Not found" });
        return;
    }

    let eventsWithIntDates: SchoolEventWithIntDate[] = events.map(schoolEventToSchoolEventWithIntDate);

    res.json(eventsWithIntDates.reverse());
}


export async function apiGetSchoolEvent(req: Request, res: Response, next: NextFunction) {
    let event: SchoolEvent | null;
    try {
        event = await EventsDao.getSchoolEventById(new ObjectId(req.params.id));
    } catch (e) {
        res.status(500).json({ message: `Internal server error (${e})` });
        return;
    }
    if (!event) {
        res.status(404).json({ message: "Not found" });
        return;
    }

    let eventWithIntDate = schoolEventToSchoolEventWithIntDate(event);
    res.status(200).json(eventWithIntDate);
}




/**
 * Inserts a new event into the database
 * @param req Express request object with the event to insert in the body as req.body.event
 * @param res Response object
 * @param next Next function
 * @returns 201 code if the event was inserted successfully, 400 code if the request body was invalid, 500 code if an error occured
 */

export async function apiInsertSchoolEvent(req: Request, res: Response, next: NextFunction) {
    try {
        const sessionCookie = req.cookies["session"];

        let user: User;
        try {
            user = await getUserFromSessionCookie(sessionCookie);
        } catch (err) {
            const e = err as ApiFuncError;
            res.status(e.code).json({ message: e.message });
            return;
        }
        
        if (!user.isAdmin) {
            res.status(403).json({ message: "Je bent geen admin" });
            return;
        }


        let reqEvent: {
            title: string;
            description: string;
            date: number;
            location: string;
            price: number;
        };

        let event: SchoolEvent;

        try {
            reqEvent = req.body as {
                title: string;
                description: string;
                date: number;
                location: string;
                price: number;
            };

            event = {
                _id: new ObjectId(),
                title: reqEvent.title,
                description: reqEvent.description,
                date: new Date(reqEvent.date),
                location: reqEvent.location,
                price: reqEvent.price
            } as SchoolEvent;


        } catch (e) {
            res.status(400).json({ message: `Invalid request body (${e})` });
            return;
        }
        
        const insertResult = await EventsDao.insertSchoolEvent(event);


        if (!insertResult) {
            res.status(500).json({ message: "Internal server error" });
            return;
        }

        res.status(201).json({ message: "Event inserted" });

    } catch (e) {
        res.status(500).json({ message: `Internal server error (${e})` });
    }
}


export async function apiEditSchoolEvent(req: Request, res: Response, next: NextFunction) {
    try {
        const sessionCookie = req.cookies["session"];

        let user: User;
        try {
            user = await getUserFromSessionCookie(sessionCookie);
        } catch (err) {
            const e = err as ApiFuncError;
            res.status(e.code).json({ message: e.message });
            return;
        }
        
        if (!user.isAdmin) {
            res.status(403).json({ message: "Je bent geen admin" });
            return;
        }


        interface ReqBody {
            _id: string;
            title: string;
            description: string;
            date: number;
            location: string;
            price: number;
        }
        const body = req.body as ReqBody;

        const event: SchoolEvent = {
            _id: new ObjectId(body._id),
            title: body.title,
            description: body.description,
            date: new Date(body.date),
            location: body.location,
            price: body.price
        } as SchoolEvent;


        const editResult = await EventsDao.editSchoolEvent(event);
        console.log(editResult);
        if (!editResult) {
            res.status(500).json({ message: "Kon evenement niet aanpassen" });
            return;
        }

        if (editResult.modifiedCount === 0) { 
            res.status(404).json({ message: "Evenement niet gevonden" });
            return;
        }

        res.status(200).json({ message: "Event edited" });

    } catch (e) {
        res.status(500).json({ message: `Internal server error (${e})` });
    }
}