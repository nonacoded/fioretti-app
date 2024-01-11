import express from 'express';
import { editSchoolEvent, getSchoolEvent, getSchoolEvents, insertSchoolEvent } from './api/events';
import { apiAdminPanelLogin, apiExchangeConfirmationToken, apiLoginUser, apiLogoutUser, apiVerifySession } from './api/auth';
import { createTicket, getTicketById, getTickets } from './api/tickets';
import { getUserById } from './api/users';



const router = express.Router();


router.route("/events").get(getSchoolEvents).post(insertSchoolEvent);

router.route("/events/:id").get(getSchoolEvent).put(editSchoolEvent);

router.route("/events/:id/tickets").post(createTicket);

router.route("/tickets").get(getTickets);

router.route("/tickets/:id").get(getTicketById);

router.route("/auth/login").post(apiLoginUser);

router.route("/auth/exchangeToken").post(apiExchangeConfirmationToken);

router.route("/auth/logout").post(apiLogoutUser);

router.route("/auth/verifySession").post(apiVerifySession);

router.route("/admin/auth/login").post(apiAdminPanelLogin);

router.route("/user/:id").get(getUserById);

export default router;