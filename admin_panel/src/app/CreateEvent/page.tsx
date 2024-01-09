'use client';

import CheckLogin from "@/components/checkLogin";
import { useRef, useState } from "react";
import axios, { AxiosError } from "axios";
import ErrorMessage from "@/components/errorMessage";
import Router from "next/router";
import ApiError from "@/interfaces/apiError";

export default function CreateEventPage() {

    const eventNameRef = useRef<HTMLInputElement>(null);
    const eventDescriptionRef = useRef<HTMLInputElement>(null);
    const eventDateRef = useRef<HTMLInputElement>(null);
    const eventLocationRef = useRef<HTMLInputElement>(null);
    const eventPriceRef = useRef<HTMLInputElement>(null);


    const [errorHidden, setErrorHidden] = useState(true);
    const [errorMessage, setErrorMessage] = useState("");
    const [errorTitle, setErrorTitle] = useState("");

    function CreateEvent(e: React.FormEvent<HTMLFormElement>) {
        e.preventDefault();
        console.log(eventNameRef.current?.value);
        console.log(eventDescriptionRef.current?.value);
        console.log(new Date(eventDateRef.current?.value as string));
        console.log(eventLocationRef.current?.value);
        console.log(eventPriceRef.current?.value);

        let eventData: {
            title: string;
            description: string;
            date: number;
            location: string;
            price: number;
        } = {
            title: eventNameRef.current?.value as string,
            description: eventDescriptionRef.current?.value as string,
            date: new Date(eventDateRef.current?.value as string).getTime(),
            location: eventLocationRef.current?.value as string,
            price: parseInt(eventPriceRef.current?.value as string)
        };

        console.log(eventData);


        axios.post(`${process.env.NEXT_PUBLIC_API_URL}/events`, eventData, {withCredentials: true}).then((res) => {
            Router.push("/");
        }).catch((e: AxiosError) => {
            console.log(e);
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
                setErrorMessage(`Er is een onbekende fout opgetreden!`);
                setErrorTitle(`Evenement aanmaken mislukt!`);
                setErrorHidden(false);
            }
         });
    }

    return (<div>
        <CheckLogin />
        <ErrorMessage title={errorTitle} desc={errorMessage} setHiddenCallback={setErrorHidden} hidden={errorHidden} />
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