import SchoolEvent from "@/interfaces/event";
import greenButton from "./greenButton";
import GreenButton from "./greenButton";

export default function EventDisplay({event, i}: {event: SchoolEvent; i: number}) {


    return (
    <li className="bg-white m-10 p-10 rounded-xl text-slate-800" key={i}>
        <h1>{event.title}</h1>
        <h2>{event.description}</h2>
        <h3>{new Date(event.date).toString()}</h3>
        <h4>{event.location}</h4>
        <br />
        <GreenButton text="Aanpassen" href={`CreateEvent?edit=${event._id}`} />
    </li>);
}