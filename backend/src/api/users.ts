import User from "../interfaces/user";
import UsersDao from "../DAO/usersDao";
import { Request, Response, NextFunction } from "express";
import { ObjectId } from "mongodb";
import { getUserFromSessionCookie } from "./auth";



export async function getUserById(req: Request, res: Response, next: NextFunction) {
    const sessionCookie = req.cookies["session"];
    let requester: User;
    try {
        requester = await getUserFromSessionCookie(sessionCookie);
    } catch (e) {
        res.status(401).json({ message: "Je bent niet ingelogd" });
        return;
    }

    if (!requester.isAdmin) {
        res.status(403).json({ message: "Je bent geen admin" });
        return;
    }


    let user: User | null;
    try {
        user = await UsersDao.getUserById(new ObjectId(req.params.id));
    } catch (e) {
        res.status(500).json({ message: `Internal server error (${e})` });
        return;
    }
    if (!user) {
        res.status(404).json({ message: "Not found" });
        return;
    }

    res.status(200).json(user);


}