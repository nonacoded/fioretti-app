import { ObjectId } from "mongodb";
import { Request, Response, NextFunction } from "express";
import User from "../interfaces/user";
import { getUserFromSessionCookie } from "./auth";
import ApiFuncError from "../interfaces/apiFuncError";
import Ticket from "../interfaces/ticket";
import TicketsDao from "../DAO/ticketsDao";
import SchoolEvent from "../interfaces/event";
import EventsDao from "../DAO/eventsDao";
import { TicketWithEvent, ticketToTicketWithEvent } from "../interfaces/ticket";
import GlobalVars from "../globalVars";



export async function apiCreateCheckoutSession(req: Request, res: Response, next: NextFunction) {

    const stripe = GlobalVars.stripeObject;


    const sessionCookie = req.cookies["session"];

    let user: User;
    try {
        user = await getUserFromSessionCookie(sessionCookie);
    } catch (e) {
        res.status(401).json({ message: "Je bent niet ingelogd" });
        return;
    }


    let eventId = req.params.id;
    let event = await EventsDao.getSchoolEventById(new ObjectId(eventId));

    if (!event) {
        res.status(404).json({ message: "Evenement niet gevonden" });
        return;
    }

    const price = event.price;
    if (price < 0.10) {
        res.status(400).json({ message: "Evenement is gratis, er is een request naar de verkeerde endpoint gestuurt. Herstart de app en probeer het opnieuw" });
        return;
    }

    try {
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['ideal'],
            line_items: [
                {
                    price_data: {
                        currency: 'eur',
                        product_data: {
                            name: event.title,
                        },
                        unit_amount: price * 100,
                    },
                    quantity: 1,
                },
            ],
        });
        res.status(200).json({ id: session.id });
    }
    catch (e) {
        res.status(500).json({ message: `Er is iets fout gegaan bij het aanmaken van de checkout sessie: ${e}` });
    }
    
}