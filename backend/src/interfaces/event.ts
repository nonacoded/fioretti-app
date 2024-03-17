import { ObjectId } from "mongodb";



/**
 * Interface for SchoolEvent
 */
export default interface SchoolEvent {
    _id: ObjectId;
    title: string;
    description: string;
    date: Date;
    //time: Time;
    location: string;
    price: number;
}


export interface SchoolEventWithIntDate {
    _id: ObjectId;
    title: string;
    description: string;
    date: number;
    //time: number;
    location: string;
    price: number;
}


export function schoolEventToSchoolEventWithIntDate(event: SchoolEvent) {
    return {
        _id: event._id,
        title: event.title,
        description: event.description,
        date: event.date.getTime(),
       // time: event.time.getTime(),
        location: event.location,
        price: event.price
    } as SchoolEventWithIntDate;
}