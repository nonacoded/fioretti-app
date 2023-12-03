import { ObjectId, UUID } from "mongodb";

export default interface ConfirmationToken {
    _id: UUID;
    userId: ObjectId;
    expires: Date;
}