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
    const reqEvent = req.body.event as {
        title: string;
        description: string;
        date: number;
        location: string;
        price: number;
    };

    let event = {
        _id: new ObjectId(),
        title: reqEvent.title,
        description: reqEvent.description,
        date: new Date(reqEvent.date),
        location: reqEvent.location,
        price: reqEvent.price
    } as SchoolEvent;
    
    const insertResult = await EventsDao.insertSchoolEvent(event);



}