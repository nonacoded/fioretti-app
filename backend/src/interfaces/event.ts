import { ObjectId } from "mongodb";



/**
 * Interface for SchoolEvent
 */
export default interface SchoolEvent {
    _id: ObjectId;
    title: string;
    description: string;
    date: Date;
    location: string;
    price: number;
}


export interface SchoolEventWithIntDate {
    _id: ObjectId;
    title: string;
    description: string;
    date: number;
    location: string;
    price: number;
}