'use client';

import CheckLogin from "@/components/checkLogin";
import { useRef } from "react";

export default function CreateEventPage() {

    const eventNameRef = useRef<HTMLInputElement>(null);
    const eventDescriptionRef = useRef<HTMLInputElement>(null);
    const eventDateRef = useRef<HTMLInputElement>(null);
    const eventLocationRef = useRef<HTMLInputElement>(null);
    const eventPriceRef = useRef<HTMLInputElement>(null);


    function CreateEvent(e: React.FormEvent<HTMLFormElement>) {
        e.preventDefault();
        console.log(eventNameRef.current?.value);
        console.log(eventDescriptionRef.current?.value);
        console.log(new Date(eventDateRef.current?.value as string));
        console.log(eventLocationRef.current?.value);
        console.log(eventPriceRef.current?.value);

        
    }

    return (<div>
        <CheckLogin />
        <form onSubmit={CreateEvent}>
            <p>Naam Evenement:</p>
            <input type="text" placeholder="Evenement naam" className="text-slate-600" ref={eventNameRef} />
            <p>Evenement beschrijving:</p>
            <input type="text" placeholder="Evenement beschrijving" className="text-slate-600" ref={eventDescriptionRef} />
            <p>Evenement datum:</p>
            <input type="datetime-local" placeholder="Evenement datum" className="text-slate-600" ref={eventDateRef} />
            <p>Evenement locatie:</p>
            <input type="text" placeholder="Evenement locatie" className="text-slate-600" ref={eventLocationRef} />
            <p>Evenement prijs:</p>
            <input type="text" inputMode="numeric" pattern="[0-9]+" placeholder="Evenement prijs" className="text-slate-600" ref={eventPriceRef} />
            <br />
            <input type="submit" value="Maak evenement aan" className="bg-green-500 m-5 p-3 rounded-md" />
        </form>
    </div>)
}