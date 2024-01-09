'use client';

import { useState, useEffect } from "react";
import axios from "axios";
import SchoolEvent from "@/interfaces/event";

export default function EventsList() {

    const [events, setEvents] = useState<SchoolEvent[]>([]);

    useEffect(() => {
        axios.get(`${process.env.NEXT_PUBLIC_API_URL}/events`).then((res) => {
            setEvents(res.data);
        }).catch((e) => {
            console.log(e);
        });
    }, []);

    


    
    return <div className="flex-coulumn items-start inline-block">
        {events.map((event) => {
            return <div className="bg-white m-10 p-10 rounded-xl text-slate-800" key={event._id}>
                <h1>{event.title}</h1>
                <h2>{event.description}</h2>
                <h3>{event.date.toString()}</h3>
                <h4>{event.location}</h4>
            </div>
        })}
    </div>
}