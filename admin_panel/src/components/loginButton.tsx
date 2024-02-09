'use client'

import ApiError from '@/interfaces/apiError';
import { GoogleLogin, GoogleOAuthProvider, CredentialResponse } from '@react-oauth/google';
import axios, { AxiosError } from 'axios';


/**
 * Login button component. Optionally you can pass a onFail and onSuccess callback.
 * 
 */
export default function LoginButton({onFail, onSuccess} : {onFail?: (status: number | undefined, message: string | undefined) => void, onSuccess?: () => void}) {

    /**
     * Run whenever the google login was completed
     * @param googleResponse 
     * @returns 
     */
    async function loginUser(googleResponse: CredentialResponse) {
        
        if (!googleResponse.credential) return;
        
        // Sends a request to the backend to login the user with the google JWT token
        axios.post(`${process.env.NEXT_PUBLIC_API_URL}/admin/auth/login`, 
        {
            token: googleResponse.credential
        }, 
        {
            withCredentials: true
        }).then((res) => {
                // Runs when the login was successful                
                if (onSuccess) onSuccess();

        }).catch((e: AxiosError) => {
            // Runs when the login failed. It calls the onFail callback if it exists
            if (e.response) {
                if ((e.response.data as Object).hasOwnProperty("message")) {
                    const res = e.response.data as ApiError;
                    if (onFail) onFail(e.status, res.message);
                } else {
                    if (onFail) onFail(e.status, undefined);
                }
            } else {
                if (onFail) onFail(e.status, undefined);
            }
            
        });
    }

    /**
     * Run whenever the google login failed. This is a fault at google, not in the backend
     */
    function googleLoginError() {
        if (onFail) onFail(undefined, "Google login mislukt!");
    }




    return (
        <>
            <GoogleOAuthProvider clientId={process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID as string}>
                <GoogleLogin onSuccess={loginUser} onError={googleLoginError} />
            </GoogleOAuthProvider>
        </>
    )
}