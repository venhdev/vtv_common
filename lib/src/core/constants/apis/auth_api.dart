part of '../api.dart';

//! authentication-controller
const String kAPIAuthLoginURL = '/auth/login';
const String kAPIAuthRefreshTokenURL = '/auth/refresh-token';
const String kAPIAuthLogoutURL = '/auth/logout';
const String kAPIAuthRegisterURL = '/auth/register';

//! customer-controller (CUSTOMER)
const String kAPICustomerForgotPasswordURL = '/customer/forgot-password';
const String kAPICustomerResetPasswordURL = '/customer/reset-password';
const String kAPICustomerChangePasswordURL = '/customer/change-password'; // PATCH
const String kAPICustomerProfileURL = '/customer/profile'; // GET, PUT