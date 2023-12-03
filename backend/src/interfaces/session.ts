import { UUID, ObjectId } from "mongodb";


export default interface Session {
    _id: UUID,
    userId: ObjectId,
    expires: Date
}