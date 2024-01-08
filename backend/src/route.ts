import express from 'express';
import { getSchoolEvents, insertSchoolEvent } from './api/events';
import { apiAdminPanelLogin, apiExchangeConfirmationToken, apiLoginUser, apiLogoutUser, apiVerifySession } from './api/auth';



const router = express.Router();


router.route("/events").get(getSchoolEvents).post(insertSchoolEvent);

router.route("/auth/login").post(apiLoginUser);

router.route("/auth/exchangeToken").post(apiExchangeConfirmationToken);

router.route("/auth/logout").post(apiLogoutUser);

router.route("/auth/verifySession").post(apiVerifySession);

router.route("/admin/auth/login").post(apiAdminPanelLogin);

export default router;