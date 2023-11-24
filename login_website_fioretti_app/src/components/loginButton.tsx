'use client'

import ApiError from '@/interfaces/apiError';
import ConfirmationToken from '@/interfaces/confirmationToken';
import {GoogleOAuthProvider, CredentialResponse, GoogleLogin} from "@react-oauth/google"
import axios, { AxiosError } from 'axios';


/**
 * Login button component. Optionally you can pass a onFail and onSuccess callback.
 * 
 */
export default function LoginButton({onFail, onSuccess} : {onFail?: (status: number | undefined, message: string | undefined) => void, onSuccess?: (loginConfirmationToken: ConfirmationToken) => void}) {

    /**
     * Run whenever the google login was completed
     * @param googleResponse 
     * @returns 
     */
    async function loginUser(googleResponse: CredentialResponse) {
        
        if (!googleResponse.credential) return;
        
        // Sends a request to the backend to login the user with the google JWT token
        axios.post(`${process.env.NEXT_PUBLIC_API_URL}/auth/login`, 
        {
            token: googleResponse.credential
        }, 
        {
            withCredentials: true
        }).then((res) => {
                
            // Runs when the login was successful                
            if (onSuccess) onSuccess(res.data);
            

        }).catch((e: AxiosError) => {
            // Runs when the login failed. It calls the onFail callback if it exists
            if (e.response) {
                if ((e.response.data as Object).hasOwnProperty("error")) {
                    const res = e.response.data as ApiError;
                    if (onFail) onFail(e.status, res.error);
                    console.log(e);
                } else {
                    if (onFail) onFail(e.status, undefined);
                    console.log(e);
                }
            } else {
                if (onFail) onFail(e.status, undefined);
                console.log(e);
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
            <GoogleOAuthProvider clientId="714726516267-hn2jg6dl88eset2hbt78p6l74s5smj2v.apps.googleusercontent.com">
                <GoogleLogin onSuccess={loginUser} onError={googleLoginError} />
            </GoogleOAuthProvider>
        </>
    )
}