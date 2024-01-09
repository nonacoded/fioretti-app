import { Request, Response, NextFunction } from "express";
import EventsDao from "../DAO/eventsDao";
import SchoolEvent from "../interfaces/event";
import { ObjectId } from "mongodb";



/**
 * Returns all events in the database
 * @param req Express request object, no parameters needed
 * @param res Response object
 * @param next Next function
 * @returns All events in the database
 */
export async function getSchoolEvents(req: Request, res: Response, next: NextFunction) {
    
    const events = await EventsDao.getSchoolEvents();
    if (!events) {
        res.status(404).json({ message: "Not found" });
        return;
    }
    res.json(events);
}


/**
 * Inserts a new event into the database
 * @param req Express request object with the event to insert in the body as req.body.event
 * @param res Response object
 * @param next Next function
 * @returns 201 code if the event was inserted successfully, 400 code if the request body was invalid, 500 code if an error occured
 */

export async function insertSchoolEvent(req: Request, res: Response, next: NextFunction) {

    const sessionCookie = req.cookies["session"];

    if (!sessionCookie) {
        res.status(401).json({message: "Je bent niet ingelogd"});
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
        reqEvent = req.body.event as {
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
            date: new Date(reqEvent.date * 1000),
            location: reqEvent.location,
            price: reqEvent.price
        } as SchoolEvent;

    } catch (e) {
        res.status(400).json({ message: "Invalid request body" });
        throw e;
        return;
    }
    

    
    
    const insertResult = await EventsDao.insertSchoolEvent(event);


    if (!insertResult) {
        res.status(500).json({ message: "Internal server error" });
        return;
    }

    res.status(201).json({ message: "Event inserted" });


}