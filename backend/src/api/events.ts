import { Request, Response, NextFunction } from "express";
import EventsDao from "../DAO/eventsDao";
import SchoolEvent from "../interfaces/event";
import { ObjectId } from "mongodb";




export async function getSchoolEvents(req: Request, res: Response, next: NextFunction) {
    
    const events = await EventsDao.getSchoolEvents();
    if (!events) {
        res.status(404).json({ error: "Not found" });
        return;
    }
    res.json(events);
}


export async function insertSchoolEvent(req: Request, res: Response, next: NextFunction) {

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
            date: new Date(reqEvent.date),
            location: reqEvent.location,
            price: reqEvent.price
        } as SchoolEvent;

    } catch (e) {
        res.status(400).json({ error: "Invalid request body" });
        throw e;
        return;
    }
    

    
    
    const insertResult = await EventsDao.insertSchoolEvent(event);


    if (!insertResult) {
        res.status(500).json({ error: "Internal server error" });
        return;
    }

    res.status(201).json({ message: "Event inserted" });


}