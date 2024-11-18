'use client';
import { useEffect } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { Suspense } from 'react';

function LoggedInContent() {
    const searchParams = useSearchParams();
    const router = useRouter();

    useEffect(() => {
        if (!searchParams.has("token") || !searchParams.has("expires")) {
            router.push("/");
        } else if (parseInt(searchParams.get("expires") as string) < Date.now()) {
            router.push("/");
        } else {
            router.push(`fiorettiapp://fiorettiapplink.nl/login?token=${searchParams.get("token")}&expires=${searchParams.get("expires")}`);
        }
    }, [searchParams, router]);

    return (
        <div className="grid static place-content-center h-screen w-screen">
            <div className="static bg-white rounded-lg p-7">
                <h1 className="text-4xl text-slate-600 text-center font-medium pb-4">✅Je bent ingelogd!</h1>
                <h2 className="text-lg text-slate-500 text-center pb-7">Open deze pagina in de fioretti app om toegang te krijgen</h2>
            </div>
        </div>
    );
}

export default function LoggedInPage() {
    return (
        <Suspense fallback={<div>Loading...</div>}>
            <LoggedInContent />
        </Suspense>
    );
}
