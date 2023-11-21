import express from 'express';
import { getSchoolEvents, insertSchoolEvent } from './api/events';



const router = express.Router();


router.route("/events").get(getSchoolEvents).post(insertSchoolEvent);


export default router;