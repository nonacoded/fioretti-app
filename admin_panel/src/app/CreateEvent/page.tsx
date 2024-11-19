'use client';

import CheckLogin from "@/components/checkLogin";
import { Suspense, useRef, useState, useEffect } from "react";
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
  location: string;
  price: number;
}

function ActualCreateEventPage() {
  const eventNameRef = useRef<HTMLInputElement>(null);
  const eventDescriptionRef = useRef<HTMLTextAreaElement>(null);
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
      axios
        .get(`${process.env.NEXT_PUBLIC_API_URL}/events/${id}`, { withCredentials: true })
        .then((res) => {
          const event = res.data as SchoolEvent;
          const evdata = {
            _id: event._id,
            title: event.title,
            description: event.description,
            date: new Date(event.date).getTime(),
            location: event.location,
            price: event.price,
          };

          setEventData(evdata);
          setEventId(id);
          setEditingEvent(true);
          console.log("event set");

          if (eventDateRef.current != null) {
            eventDateRef.current.valueAsNumber = evdata.date;
          }
        })
        .catch((e: AxiosError) => {
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
  }, [searchParams]);

  function CreateEvent(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    console.log("Form submitted");

    let price = parseFloat(eventPriceRef.current?.value || "0");
    if (isNaN(price) || price < 0) {
      setErrorMessage("Vul een geldige prijs in!");
      setErrorTitle("Evenement aanmaken mislukt!");
      setErrorHidden(false);
      return;
    }

    let eventData: EventData = {
      _id: eventId,
      title: eventNameRef.current?.value || "",
      description: eventDescriptionRef.current?.value || "",
      date: new Date(eventDateRef.current?.value || "").getTime(),
      location: eventLocationRef.current?.value || "",
      price,
    };

    if (
      !eventData.title ||
      !eventData.description ||
      !eventData.location ||
      isNaN(eventData.date) ||
      eventData.date < Date.now()
    ) {
      setErrorMessage("Vul alle velden correct in!");
      setErrorTitle("Evenement aanmaken mislukt!");
      setErrorHidden(false);
      return;
    }

    const apiCall = editingEvent
      ? axios.put(`${process.env.NEXT_PUBLIC_API_URL}/events/${eventId}`, eventData, { withCredentials: true })
      : axios.post(`${process.env.NEXT_PUBLIC_API_URL}/events`, eventData, { withCredentials: true });

    apiCall
      .then(() => router.push("/"))
      .catch((e: AxiosError) => {
        if (e.response) {
          if ((e.response.data as Object).hasOwnProperty("message")) {
            setErrorMessage((e.response.data as ApiError).message);
            setErrorTitle(`Evenement aanmaken mislukt! [${e.response.status}]`);
          } else {
            setErrorMessage(`Er is een onbekende fout opgetreden!`);
            setErrorTitle(`Evenement aanmaken mislukt! [${e.response.status}]`);
          }
        } else {
          setErrorMessage(`Er is een onbekende fout opgetreden! (${e})`);
          setErrorTitle(`Evenement aanmaken mislukt!`);
        }
        setErrorHidden(false);
      });
  }

  return (
    <div>
      <CheckLogin />
      <ErrorMessage
        title={errorTitle}
        desc={errorMessage}
        setHiddenCallback={setErrorHidden}
        hidden={errorHidden}
      />
      <div className="grid h-screen place-items-center">
        <div className="bg-white p-20 rounded-3xl text-slate-800 text-center">
          <form onSubmit={CreateEvent}>
            <p>Naam Evenement:</p>
            <input
              type="text"
              placeholder="Evenement naam"
              className="text-black bg-slate-200 rounded-md p-3"
              ref={eventNameRef}
              defaultValue={eventData?.title}
            />
            <p>Evenement beschrijving:</p>
            <textarea
              cols={30}
              placeholder="Evenement beschrijving"
              className="text-black bg-slate-200 rounded-md p-3"
              ref={eventDescriptionRef}
              defaultValue={eventData?.description}
            />
            <p>Evenement datum:</p>
            <input
              type="datetime-local"
              placeholder="Evenement datum"
              className="text-black bg-slate-200 rounded-md p-3"
              ref={eventDateRef}
            />
            <p>Evenement locatie:</p>
            <input
              type="text"
              placeholder="Evenement locatie"
              className="text-black bg-slate-200 rounded-md p-3"
              ref={eventLocationRef}
              defaultValue={eventData?.location}
            />
            <p>Evenement prijs:</p>
            <input
              type="text"
              inputMode="numeric"
              placeholder="Evenement prijs"
              className="text-black bg-slate-200 rounded-md p-3"
              ref={eventPriceRef}
              defaultValue={eventData?.price?.toString()}
            />
            <br />
            <input
              type="submit"
              value={editingEvent ? "Pas evenement aan" : "Maak evenement aan"}
              className="bg-green-500 m-5 p-3 rounded-md text-white"
            />
          </form>
        </div>
      </div>
    </div>
  );
}

export default function CreateEventPage() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <ActualCreateEventPage />
    </Suspense>
  );
}
