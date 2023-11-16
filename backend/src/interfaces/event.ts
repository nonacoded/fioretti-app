import { ObjectId } from "mongodb";

export default interface SchoolEvent {
    _id: ObjectId;
    title: string;
    description: string;
    date: Date;
    location: string;
    price: number;
}