'use client';

import { useState, useEffect } from "react";
import axios from "axios";
import SchoolEvent from "@/interfaces/event";
import EventDisplay from "./eventDisplay";

export default function EventsList() {

    const [events, setEvents] = useState<SchoolEvent[]>([]);

    useEffect(() => {
        axios.get(`${process.env.NEXT_PUBLIC_API_URL}/events`).then((res) => {
            setEvents(res.data);
        }).catch((e) => {
            console.log(e);
        });
    }, []);

    


    
    return <ul className="flex-coulumn items-start inline-block">
        {events.map((event) => {
            return <EventDisplay event={event} key={events.indexOf(event)} />;
        })}
    </ul>
}