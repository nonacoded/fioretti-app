import { OAuth2Client, TokenPayload } from 'google-auth-library';
import {Request, Response, NextFunction} from "express";
import UsersDao from '../DAO/usersDao';
import User from '../interfaces/user';
import ApiFuncError from '../interfaces/apiFuncError';
import { ObjectId, UUID } from 'mongodb';
import { v4 as uuidv4 } from 'uuid';
import ConfirmationToken from '../interfaces/confirmationToken';
import LoginConfirmationsDao from '../DAO/loginConfirmationsDao';
import SessionsDao from '../DAO/sessionsDao';
import Session from '../interfaces/session';


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
        res.status(401).json({message: "Google token bestaat niet of is verlopen"});
        return;
    }

    // for typescript to make sure it's not undefined
    if (!verify.payload) return;


    // get user from database
    let user = await UsersDao.getUserByGoogleId(verify.payload.sub);

    // create user if it doesn't exist
    if (!user) {
        try {
            user = await registerUser(verify.payload);
        } catch (e) {
            const err = e as ApiFuncError;
            res.status(err.code).json({message: err.message});
            return;
        }
    }
    

    // check if user exists (if not something went wrong while creating the user)
    if (!user) {
        res.status(500).json({message: "Niet gelukt om gebruiker te maken of te vinden"});
        return;
    };

    // create confirmation token
    const confirmationToken = {
        _id: new UUID(uuidv4()),
        userId: user._id,
        expires: new Date(Date.now() + 1000 * 60) // 1 minute
    } as ConfirmationToken;


    // insert confirmation token into database
    const result = await LoginConfirmationsDao.insertConfirmationToken(confirmationToken);

    if (!result) {
        res.status(500).json({message: "Niet gelukt om in te loggen (login confirmation token kon niet in de database gezet worden)"});
    }

    res.status(200).json(confirmationToken);
}


export async function apiAdminPanelLogin(req: Request, res: Response, next: NextFunction) {

    const verify = await verifyGoogleToken(req.body.token);

    // check if google token is valid
    if (!verify.valid) {
        res.status(401).json({message: "Google token bestaat niet of is verlopen"});
        return;
    }

    // for typescript to make sure it's not undefined
    if (!verify.payload) return;

    // for typescript to make sure it's not undefined
    if (!verify.payload) return;


    // get user from database
    let user = await UsersDao.getUserByGoogleId(verify.payload.sub);

    // create user if it doesn't exist
    if (!user) {
        try {
            user = await registerUser(verify.payload);
        } catch (e) {
            const err = e as ApiFuncError;
            res.status(err.code).json({message: err.message});
            return;
        }
    }
    
    // check if user exists (if not something went wrong while creating the user)
    if (!user) {
        res.status(500).json({message: "Niet gelukt om gebruiker te maken of te vinden"});
        return;
    };


    // check if user is admin
    if (!user.isAdmin) {
        res.status(403).json({message: "Je bent geen admin"});
        return;
    }

    const sessionToken = {
        _id: new UUID(uuidv4()),
        userId: user._id,
        expires: new Date(Date.now() + 1000 * 60 * 60 * 24)
    } as Session;


    const result = await SessionsDao.insertSession(sessionToken);
    if (!result) {
        res.status(500).json({message: "Niet gelukt om in te loggen (session token kon niet in de database gezet worden)"});
        return;
    }

    res.cookie("session", sessionToken._id.toString(), 
        {
            expires: sessionToken.expires, 
            httpOnly: true, sameSite: "lax", 
            secure: process.env.ENV !== "dev"
        });

    res.status(200).json(user);
}



export async function apiExchangeConfirmationToken(req: Request, res: Response, next: NextFunction) {
    
    if (!req.body.confirmationToken) {
        res.status(400).json({message: "Geen login confirmation token meegegeven"});
        return;
    }

    const confirmationToken = await LoginConfirmationsDao.getConfirmationTokenById(new UUID(req.body.confirmationToken as string));

    if (!confirmationToken) {
        res.status(404).json({message: "Login confirmation token is niet gevonden"});
        return;
    }

    if (confirmationToken.expires < new Date()) {
        res.status(401).json({message: "Login confirmation token is verlopen"});
        return;
    }

    const user = await UsersDao.getUserById(confirmationToken.userId);

    if (!user) {
        res.status(500).json({message: "Niet gelukt om in te loggen (gebruiker niet gevonden)"});
        return;
    }

    const sessionToken = {
        _id: new UUID(uuidv4()),
        userId: user._id,
        expires: nextAugust1st()
    } as Session;


    const result = await SessionsDao.insertSession(sessionToken);
    if (!result) {
        res.status(500).json({message: "Niet gelukt om in te loggen (session token kon niet in de database gezet worden)"});
        return;
    }

    res.cookie("session", sessionToken._id.toString(), 
        {
            expires: sessionToken.expires, 
            httpOnly: true, sameSite: "lax", 
            secure: process.env.ENV !== "dev"
        });
    
    res.status(200).json(user);
}


export async function apiLogoutUser(req: Request, res: Response, next: NextFunction) {
    const sessionCookie = req.cookies["session"];

    if (!sessionCookie) {
        
        res.status(200).json({message: "Je bent uitgelogd"});
        return;
    }

    const session = await getValidSession(sessionCookie);
    if (!session) {
        res.clearCookie("session");
        res.status(200).json({message: "Je bent uitgelogd"});
        return;
    }


    const result = await SessionsDao.deleteSession(session._id);
    if (!result) {
        res.status(500).json({message: "Niet gelukt om uit te loggen (session token kon niet uit de database verwijderd worden)"});
        return;
    }


    res.clearCookie("session");

    res.status(200).json({message: "Je bent uitgelogd"});
}


export async function apiVerifySession(req: Request, res: Response, next: NextFunction) {

    const sessionCookie = req.cookies["session"];
    let user: User;
    try {
        user = await getUserFromSessionCookie(sessionCookie);
    } catch (e) {
        const err = e as ApiFuncError;
        res.status(err.code).json({message: err.message});
        return;
    }

    res.status(200).json(user);
}

export async function getUserFromSessionCookie(sessionCookie: any) {
    if (!sessionCookie) {
        let err: ApiFuncError = {
            message: "Je bent niet ingelogd",
            code: 401
        }
        throw err;
    }

    const session = await getValidSession(sessionCookie);
    if (!session) {
        let err: ApiFuncError = {
            message: "Je bent niet ingelogd",
            code: 401
        }
        throw err;
    }

    const user = await UsersDao.getUserById(session.userId);
    if (!user) {
        let err: ApiFuncError = {
            message: "Niet gelukt om in te loggen (gebruiker niet gevonden)",
            code: 500
        }
        throw err;
    }

    return user;

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
        createdAt: new Date(),
        isAdmin: false
    }

    const result = await UsersDao.createUser(userObj);

    if (!result) {
        let err: ApiFuncError = {
            message: "Unable to create user",
            code: 500
        }
        throw err;
    }

    let user = await UsersDao.getUserById(result);

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



/**
 * Checks if a session is valid, and if so return the session
 * @param sessionId Session ID
 * @returns Boolean
 */
export async function getValidSession(sessionId: string): Promise<Session | null> {

    const session = await SessionsDao.getSessionById(new UUID(sessionId));

    if (!session) return null;

    if (session.expires < new Date()) return null;

    return session;
}




function nextAugust1st() {
    var now = new Date();
    var nextAugust1st;
  
    // Check if the current date is after August 1st
    if (now.getMonth() > 7 || (now.getMonth() == 7 && now.getDate() > 1)) {
        // If the current date is after August 1st, set the year to the next year
        nextAugust1st = new Date(now.getFullYear() + 1, 7, 1);
    } else {
        // If the current date is before or on August 1st, set the year to the current year
        nextAugust1st = new Date(now.getFullYear(), 7, 1);
    }
  
    return nextAugust1st;
  }