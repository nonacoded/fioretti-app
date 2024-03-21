'use client';

import LogoutButton from "@/components/logoutButton";
import EventsList from "@/components/eventsList";
import GreenButton from "@/components/greenButton";
import CheckLogin from "@/components/checkLogin";


export default function Home() {


  function createNewEvent() { 

  }

  return (
    <div>
      <CheckLogin />
      <div className="m-auto w-1/6">
        <div className="text-center">
          <div className="m-10">
            <LogoutButton />
          </div>
          <div className="m-10">
            <GreenButton text="Nieuw Evenement Aanmaken" href={"CreateEvent"} />
          </div>
        </div>
        
      </div>
      


      <div className="flex justify-center">
        <EventsList />
      </div>
    </div>
  )
}
