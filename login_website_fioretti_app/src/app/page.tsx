'use client';

import ErrorMessage from '@/components/errorMessage';
import LoginButton from '@/components/loginButton'
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import ConfirmationToken from '@/interfaces/confirmationToken';


export default function Home() {

  const [errorMessage, setErrorMessage] = useState<string>("");
  const [errorTitle, setErrorTitle] = useState<string>("");
  const [errorHidden, setErrorHidden] = useState<boolean>(true);

  const router = useRouter();


  function onLoginFailed(status: number | undefined, message: string | undefined) {
    setErrorTitle("Inloggen mislukt!");
    setErrorMessage(message ?? "Er is iets fout gegaan bij het inloggen. Probeer het later opnieuw.");
    setErrorHidden(false);
  }

  function onLoginSuccess(confirmationToken: ConfirmationToken) {
    const expireNum = Date.parse(confirmationToken.expires).valueOf();
    if (Date.now() < expireNum) {
      router.push(`/loggedin?token=${confirmationToken._id}&expires=${expireNum}`);
    } else {
      setErrorTitle("Inloggen mislukt!");
      setErrorMessage("Deze inlog link is verlopen, probeer het opniew.");
      setErrorHidden(false);
    }
  }


  return (
    <>
      <div className="grid static place-content-center h-screen w-screen">
          <div className="static bg-white rounded-lg p-7">
            <h1 className="text-4xl text-slate-600 text-center font-medium pb-4">Log in</h1>
            <h2 className="text-lg text-slate-500 text-center pb-7">Log in met je school account om toegang te krijgen</h2>
            <div className="grid static place-content-center">
            <a href="fiorettiapp://fiorettiapplink.nl/test">test</a>
            <LoginButton onFail={onLoginFailed} onSuccess={onLoginSuccess} />
            </div>
          </div>
      </div>

      <ErrorMessage title={errorTitle} desc={errorMessage} hidden={errorHidden} setHiddenCallback={setErrorHidden} />

      
    </>
  )
}
