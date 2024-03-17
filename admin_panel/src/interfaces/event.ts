



/**
 * Interface for SchoolEvent
 */
export default interface SchoolEvent {
    _id: string;
    title: string;
    description: string;
    date: Date;
   // time: TimeRanges;
    location: string;
    price: number;
}