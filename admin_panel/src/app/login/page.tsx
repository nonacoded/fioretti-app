'use client';

import ErrorMessage from "@/components/errorMessage";
import LoginButton from "@/components/loginButton";
import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";

export default function LoginPage() {
    const router = useRouter();

    const [redirectPath, setRedirectPath] = useState<string | null>(null);
    const [errorHidden, setErrorHidden] = useState(true);
    const [errorMessage, setErrorMessage] = useState("");
    const [errorTitle, setErrorTitle] = useState("");

    useEffect(() => {
        const params = new URLSearchParams(window.location.search);
        setRedirectPath(params.get("r"));
    }, []);

    function onLoginError(status: number | undefined, message: string | undefined) {
        let msg = "";
        if (status) msg += `[${status}] `;
        if (message) msg += message;
        setErrorMessage(msg);
        setErrorTitle("Inloggen mislukt!");
        setErrorHidden(false);
    }

    function onLoginSuccess() {
        if (redirectPath) {
            router.push(redirectPath);
        } else {
            router.push("/");
        }
    }

    return (
        <div>
            <div className="grid static place-content-center h-screen w-screen">
                <div className="static bg-white rounded-lg p-7">
                    <h1 className="text-4xl text-slate-600 text-center font-medium pb-4">Log in</h1>
                    <h2 className="text-lg text-slate-500 text-center pb-7">
                        Log in met je school account om toegang te krijgen
                    </h2>
                    <div className="grid static place-content-center">
                        <LoginButton onFail={onLoginError} onSuccess={onLoginSuccess} />
                    </div>
                </div>
            </div>
            <ErrorMessage
                setHiddenCallback={setErrorHidden}
                title={errorTitle}
                desc={errorMessage}
                hidden={errorHidden}
            />
        </div>
    );
}
