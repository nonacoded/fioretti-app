import express from 'express';
import { getSchoolEvents, insertSchoolEvent } from './api/events';
import { apiLoginUser } from './api/auth';



const router = express.Router();


router.route("/events").get(getSchoolEvents).post(insertSchoolEvent);

router.route("/auth/login").post(apiLoginUser);


export default router;