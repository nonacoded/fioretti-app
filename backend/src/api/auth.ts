import { OAuth2Client, TokenPayload } from 'google-auth-library';
import {Request, Response, NextFunction} from "express";
import usersDao from '../DAO/usersDAO';
import User from '../interfaces/user';
import ApiFuncError from '../interfaces/apiFuncError';
import { ObjectId, UUID } from 'mongodb';
import { v4 as uuidv4 } from 'uuid';
import confirmationToken from '../interfaces/confirmationToken';
import loginConfirmationsDAO from '../DAO/loginConfirmationsDAO';


const client = new OAuth2Client(process.env.CLIENT_ID);





/**
 * Logs in the user, or creates a new account if the user doesn't exist yet.
 * In the request's body a google token is expected.
 * 
 * If the token is valid, the user is logged in and a cookie containing the session ID is sent.
 * @param req Express request
 * @param res Express response
 * @param next Next function
 * @returns 
 */
export async function apiLoginUser(req: Request, res: Response, next: NextFunction) {

    const verify = await verifyGoogleToken(req.body.token);

    // check if google token is valid
    if (!verify.valid) {
        res.status(401).json({error: "Google token bestaat niet of is verlopen"});
        return;
    }

    // for typescript to make sure it's not undefined
    if (!verify.payload) return;


    // get access_token
    //const access_token = await client.getToken(req.body.token);

    // get user from database
    let user = await usersDao.getUserByGoogleId(verify.payload.sub);

    // create user if it doesn't exist
    if (!user) {
        try {
            user = await registerUser(verify.payload);
        } catch (e) {
            const err = e as ApiFuncError;
            res.status(err.code).json({error: err.message});
            return;
        }
    }
    

    // check if user exists (if not something went wrong while creating the user)
    if (!user) {
        res.status(500).json({error: "Niet gelukt om gebruiker te maken of te vinden"});
        return;
    };

    // create confirmation token
    const confirmationToken = {
        _id: new UUID(uuidv4()),
        userId: user._id,
        expires: new Date(Date.now() + 1000 * 60) // 1 minute
    } as confirmationToken;


    // insert confirmation token into database
    const result = await loginConfirmationsDAO.insertConfirmationToken(confirmationToken);

    if (!result) {
        res.status(500).json({error: "Niet gelukt om in te loggen (login confirmation token kon niet in de database gezet worden)"});
    }

    res.status(200).json(confirmationToken);
}




/**
 * Creates a new user in the database
 * @param google_payload Information about the user's google account gathered from the JWT token
 * @returns The created user
 */
async function registerUser(google_payload: TokenPayload) {

    if (!google_payload.email) {
        let err: ApiFuncError = {
            message: "Er is geen email op je google-account gevonden.",
            code: 400
        }
        throw err;
    }

    /*if (!google_payload.email.endsWith("@fiorettileerling.nl") || 
        !google_payload.email.endsWith("@fioretti.nl") || 
        !google_payload.email.endsWith("@sft-vo.nl")) {

        let err: ApiFuncError = {
            message: "Je moet je school-email gebruiken om in te loggen.",
            code: 403
        }
        throw err;
    }*/ // temp comment

    const userObj: User = {
        _id: new ObjectId(),
        googleId: google_payload.sub,
        email: google_payload.email,
        firstName: google_payload.given_name,
        lastName: google_payload.family_name,
        createdAt: new Date()
    }

    const result = await usersDao.createUser(userObj);

    if (!result) {
        let err: ApiFuncError = {
            message: "Unable to create user",
            code: 500
        }
        throw err;
    }

    let user = await usersDao.getUserById(result);

    return user;
}





/**
 * Checks if the google JWT token returned by the "log in with google button" from the frontend is valid.
 * @param token Google token
 * @returns Object containing a boolean indicating if the token is valid and the payload of the token
 */
async function verifyGoogleToken(token: string) {

    try {
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: process.env.GOOGLE_CLIENT_ID as string
        });

        const payload = ticket.getPayload();

        return {valid: true, payload: payload};
    } catch(e) {
        return {valid: false, payload: undefined}
    }
}