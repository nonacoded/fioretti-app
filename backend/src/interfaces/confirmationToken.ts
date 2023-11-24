import { ObjectId, UUID } from "mongodb";

export default interface confirmationToken {
    _id: UUID;
    userId: ObjectId;
    expires: Date;
}