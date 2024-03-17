'use client';

import CheckLogin from "@/components/checkLogin";
import { useRef, useState, useEffect } from "react";
import axios, { AxiosError } from "axios";
import ErrorMessage from "@/components/errorMessage";
import { useRouter, useSearchParams } from "next/navigation";
import ApiError from "@/interfaces/apiError";
import SchoolEvent from "@/interfaces/event";


interface EventData {
    _id?: string;
    title: string;
    description: string;
    date: number;
    time: number;
    location: string;
    price: number;
} 



export default function CreateEventPage() {

    const eventNameRef = useRef<HTMLInputElement>(null);
    const eventDescriptionRef = useRef<HTMLInputElement>(null);
    const eventDateRef = useRef<HTMLInputElement>(null);
    const eventLocationRef = useRef<HTMLInputElement>(null);
    const eventPriceRef = useRef<HTMLInputElement>(null);

    const router = useRouter();
    const searchParams = useSearchParams();


    const [errorHidden, setErrorHidden] = useState(true);
    const [errorMessage, setErrorMessage] = useState("");
    const [errorTitle, setErrorTitle] = useState("");

    const [eventData, setEventData] = useState<EventData>();
    const [eventId, setEventId] = useState<string | undefined>(undefined);
    const [editingEvent, setEditingEvent] = useState(false);

    useEffect(() => {
        if (searchParams.has("edit")) {
            let id = searchParams.get("edit") as string;
            axios.get(`${process.env.NEXT_PUBLIC_API_URL}/events/${id}`, {withCredentials: true}).then((res) => {
                const event = res.data as SchoolEvent;
                const evdata = {
                    _id: event._id,
                    title: event.title,
                    description: event.description,
                    date: new Date(event.date).getTime(),
                    time: new Date(event.time).getTime(),
                    location: event.location,
                    price: event.price
                };

                setEventData(evdata);
                setEventId(id);
                setEditingEvent(true);
                console.log("event set");

                if (eventDateRef.current != null) {
                    eventDateRef.current.valueAsNumber = evdata.date;
                }
            }).catch((e: AxiosError) => {
                if (e.response) {
                    if ((e.response.data as Object).hasOwnProperty("message")) {
                        setErrorMessage((e.response.data as ApiError).message);
                        setErrorTitle(`Evenement ophalen mislukt! [${e.response.status}]`);
                        setErrorHidden(false);
                    } else {
                        setErrorMessage(`Er is een onbekende fout opgetreden! `);
                        setErrorTitle(`Evenement ophalen mislukt! [${e.response.status}]`);
                        setErrorHidden(false);
                    }
                } else {
                    setErrorMessage(`Er is een onbekende fout opgetreden! (${e})`);
                    setErrorTitle(`Evenement ophalen mislukt!`);
                    setErrorHidden(false);
                }
            });
        }
    }, []);

    function CreateEvent(e: React.FormEvent<HTMLFormElement>) {
        e.preventDefault();

        console.log("Form submitted");

        let eventData: EventData = {
            _id: eventId,
            title: eventNameRef.current?.value as string,
            description: eventDescriptionRef.current?.value as string,
            date: new Date(eventDateRef.current?.value as string).getTime(),
            time: new Date(eventDateRef.current?.value as string).getTime(),
            location: eventLocationRef.current?.value as string,
            price: parseFloat(eventPriceRef.current?.value as string)
        };

        if (eventData.title.length < 1 || eventData.description.length < 1 || eventData.location.length < 1 || eventData.price < 1 || isNaN(eventData.date)) {
            setErrorMessage("Vul alle velden in!");
            setErrorTitle("Evenement aanmaken mislukt!");
            setErrorHidden(false);
            return;
        }

        if (isNaN(eventData.price)) {
            setErrorMessage("Vul een geldige prijs in!");
            setErrorTitle("Evenement aanmaken mislukt!");
            setErrorHidden(false);
            return;
        }
        if (eventData.date < Date.now()) {
            setErrorMessage("Evenement moet in de toekomst zijn!");
            setErrorTitle("Evenement aanmaken mislukt!");
            setErrorHidden(false);
            return;
        }


        if (editingEvent) {
            
            axios.put(`${process.env.NEXT_PUBLIC_API_URL}/events/${eventId}`, eventData, {withCredentials: true}).then((res) => {
                router.push("/");
            }).catch((e: AxiosError) => {
                if (e.response) {
                    if ((e.response.data as Object).hasOwnProperty("message")) {
                        setErrorMessage((e.response.data as ApiError).message);
                        setErrorTitle(`Evenement aanmaken mislukt! [${e.response.status}]`);
                        setErrorHidden(false);
                    } else {
                        setErrorMessage(`Er is een onbekende fout opgetreden! `);
                        setErrorTitle(`Evenement aanmaken mislukt! [${e.response.status}]`);
                        setErrorHidden(false);
                    }
                } else {
                    setErrorMessage(`Er is een onbekende fout opgetreden! (${e})`);
                    setErrorTitle(`Evenement aanmaken mislukt!`);
                    setErrorHidden(false);
                }
            });
            return;
        } else {
            axios.post(`${process.env.NEXT_PUBLIC_API_URL}/events`, eventData, {withCredentials: true}).then((res) => {
                router.push("/");
            }).catch((e: AxiosError) => {
                if (e.response) {
                    if ((e.response.data as Object).hasOwnProperty("message")) {
                        setErrorMessage((e.response.data as ApiError).message);
                        setErrorTitle(`Evenement aanmaken mislukt! [${e.response.status}]`);
                        setErrorHidden(false);
                    } else {
                        setErrorMessage(`Er is een onbekende fout opgetreden! `);
                        setErrorTitle(`Evenement aanmaken mislukt! [${e.response.status}]`);
                        setErrorHidden(false);
                    }
                } else {
                    setErrorMessage(`Er is een onbekende fout opgetreden! (${e})`);
                    setErrorTitle(`Evenement aanmaken mislukt!`);
                    setErrorHidden(false);
                }
            });
        }
    }

    return (<div>
        <CheckLogin />
        <ErrorMessage title={errorTitle} desc={errorMessage} setHiddenCallback={setErrorHidden} hidden={errorHidden} />
        <form onSubmit={CreateEvent}>
            <p>Naam Evenement:</p>
            <input type="text" placeholder="Evenement naam" className="text-slate-600" ref={eventNameRef} defaultValue={eventData?.title} />
            <p>Evenement beschrijving:</p>
            <input type="text" placeholder="Evenement beschrijving" className="text-slate-600" ref={eventDescriptionRef} defaultValue={eventData?.description} />
            <p>Evenement datum:</p>
            <input type="datetime-local" placeholder="Evenement datum" className="text-slate-600" ref={eventDateRef} />
            <p>Evenement locatie:</p>
            <input type="text" placeholder="Evenement locatie" className="text-slate-600" ref={eventLocationRef} defaultValue={eventData?.location} />
            <p>Evenement prijs:</p>
            <input type="text" inputMode="numeric" pattern="^[1-9]\d*(\.\d+)?$" placeholder="Evenement prijs" className="text-slate-600" ref={eventPriceRef} defaultValue={eventData?.price} />
            <br />
            <input type="submit" value={editingEvent ? "Pas evenement aan" : "Maak evenement aan"} className="bg-green-500 m-5 p-3 rounded-md" />
        </form>
    </div>)
}