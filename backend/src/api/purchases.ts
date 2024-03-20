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
import { createTicket } from "./tickets";
import UsersDao from "../DAO/usersDao";



export async function apiBuyTicket(req: Request, res: Response, next: NextFunction) {

    console.log("Creating checkout session");
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
        const intent = await stripe.paymentIntents.create({
            payment_method_types: ['ideal', 'paypal'],
            currency: 'eur',
            amount: price * 100,
            metadata: {
                event_id: eventId,
                user_id: user._id.toString()
            }
        });
        res.status(200).json(intent);
    }
    catch (e) {
        res.status(500).json({ message: `Er is iets fout gegaan bij het aanmaken van de checkout sessie: ${e}` });
    }
    
}



export async function apiReceiveStripeWebhookEvent(req: Request, res: Response, next: NextFunction) {
    const stripe = GlobalVars.stripeObject;

    const sig = req.headers['stripe-signature'];
    let event = null;

    if (!sig) {
        res.status(400).json({ message: "No signature" });
        return;
    }

    const webhook_secret = process.env.STRIPE_WEBHOOK_SECRET as string;
    if (!webhook_secret) {
        res.status(500).json({ message: "Webhook secret not set" });
        return;
    }

    try {
        event = stripe.webhooks.constructEvent(req.body, sig, webhook_secret);
    } catch (err) {
        // invalid signature
        res.status(400).json({ message: `Failed to construct event: ${err}` });
        return;
    }

    let intent = null;
    switch (event['type']) {
    case 'payment_intent.succeeded':
        intent = event.data.object;

        // create new ticket for paid event
        const eventId = intent.metadata.event_id;
        const userId = intent.metadata.user_id;
        if (!eventId || !userId) {
            console.log("Warning: metadata is missing in successful payment, this might mean someone paid but won't receive anything");
            res.status(400).json({ message: "Missing metadata" });
            return;
        }
        const user = await UsersDao.getUserById(new ObjectId(userId));
        const schoolEvent = await EventsDao.getSchoolEventById(new ObjectId(eventId));
        if (!user || !schoolEvent) {
            console.log(`Warning: user or event couldn't be found, this might mean someone paid but won't receive anything. User id: ${userId}, event id: ${eventId}`);

            res.status(404).json({ message: "User or event not found" });
            return;
        }

        try {
            const ticket = await TicketsDao.getTicketByUserIdAndEventId(new ObjectId(userId), new ObjectId(eventId));
            if (ticket) {
                res.status(400).json({ message: "User already has a ticket for this event" });
                return;
            }
            
            // create new ticket
            await createTicket(schoolEvent, user);

            res.status(200).json({ message: "Ticket created" });
        } catch (e) {
            var err = e as ApiFuncError;
            res.status(err.code).json({ message: err.message });
        }


        break;
    /*case 'payment_intent.payment_failed':
        intent = event.data.object;
        const message = intent.last_payment_error && intent.last_payment_error.message;
        console.log('Failed:', intent.id, message);
        break;*/
    default:
        console.log(`Unhandled event type: ${event['type']}`);
        res.status(200);
    }
}