import express from 'express';
import { apiEditSchoolEvent, apiGetSchoolEvent, apiGetSchoolEvents, apiInsertSchoolEvent } from './api/events';
import { apiAdminPanelLogin, apiExchangeConfirmationToken, apiLoginUser, apiLogoutUser, apiVerifySession } from './api/auth';
import { apiMarkTicketAsUsed, apiClaimFreeTicket, apiGetTicketById, apiGetTickets } from './api/tickets';
import { apiGetUserById } from './api/users';
import { apiCreateCheckoutSession } from './api/checkout';



const router = express.Router();


router.route("/events").get(apiGetSchoolEvents).post(apiInsertSchoolEvent);

router.route("/events/:id").get(apiGetSchoolEvent).put(apiEditSchoolEvent);

router.route("/events/:id/tickets").post(apiClaimFreeTicket);

router.route("/events/:id/checkout").post(apiCreateCheckoutSession);

router.route("/tickets").get(apiGetTickets);

router.route("/tickets/:id").get(apiGetTicketById);

router.route("/tickets/:id/markUsed").put(apiMarkTicketAsUsed);

router.route("/auth/login").post(apiLoginUser);

router.route("/auth/exchangeToken").post(apiExchangeConfirmationToken);

router.route("/auth/logout").post(apiLogoutUser);

router.route("/auth/verifySession").post(apiVerifySession);

router.route("/admin/auth/login").post(apiAdminPanelLogin);

router.route("/users/:id").get(apiGetUserById);

export default router;