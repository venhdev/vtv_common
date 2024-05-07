part of '../api.dart';

//! authentication-controller
const String kAPIAuthLoginURL = '/auth/login';
const String kAPIAuthRefreshTokenURL = '/auth/refresh-token';
const String kAPIAuthLogoutURL = '/auth/logout';
const String kAPIAuthRegisterURL = '/auth/register';

//! customer-controller (~auth)
const String kAPICustomerForgotPasswordURL = '/customer/forgot-password';
const String kAPICustomerResetPasswordURL = '/customer/reset-password';
const String kAPICustomerChangePasswordURL = '/customer/change-password'; // PATCH
const String kAPICustomerProfileURL = '/customer/profile'; // GET, PUT
const String kAPICustomerActiveAccountURL = '/customer/active-account'; // POST
const String kAPICustomerSendEmailActiveAccountURL = '/customer/active-account/send-email'; // POST