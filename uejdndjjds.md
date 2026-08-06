# Customer CERSAI Consent API

## API Specification

**Version:** 1.1\
**Method:** `POST`\
**Endpoint:** `/api/v1/customers/cersai-consent`

------------------------------------------------------------------------

# Purpose

This API enables the CRM application to submit a customer's consent for
authorizing the Bank to download the customer's CKYC/CERSAI documents.

The API is exposed through **EIS (DMZ)** and performs:

-   Customer resolution
-   Mobile verification
-   Consent TAT validation
-   Idempotency validation
-   Consent recording/updation
-   Audit logging

------------------------------------------------------------------------

# Authentication

-   HTTPS
-   HTTP Basic Authentication (handled by EIS)

------------------------------------------------------------------------

# Headers

## Request

  Header             Mandatory   Description
  ------------------ ----------- -------------------------------------
  Authorization      Yes         HTTP Basic Authentication
  X-Correlation-Id   Yes         End-to-end request trace identifier
  Content-Type       Yes         application/json
  Accept             Yes         application/json

## Response

  Header             Description
  ------------------ ---------------------
  X-Correlation-Id   Echoed from request

------------------------------------------------------------------------

# Request

``` json
{
  "transactionReference": "CRM-20260806-000001",
  "cifNumber": "12345678901",
  "mobileNumber": "9876543210",
  "consent": "YES",
  "consentTimestamp": "2026-08-06T16:15:30+05:30",
  "agentId": "EMP12345",
  "remarks": "Customer consent received."
}
```

------------------------------------------------------------------------

# Processing Flow

1.  Authenticate request.
2.  Adaptive Request Admission Control.
3.  Validate request payload.
4.  Resolve customer by CIF (parallel lookup across four databases).
5.  Verify registered mobile number.
6.  Validate Consent TAT.
7.  Validate transaction idempotency.
8.  Check existing consent.
9.  Insert Consent History.
10. Update Latest Consent.
11. Return standard response.

------------------------------------------------------------------------

# Business Validation Rules

## Customer Resolution

-   Customer is resolved using the globally unique CIF Number.
-   Lookup is executed in parallel across four Oracle databases.

  Condition                        HTTP   Business Code
  -------------------------------- ------ ----------------------
  Customer Found                   200    Continue Processing
  CIF Not Found                    404    CIF_NOT_FOUND
  Customer found in multiple DBs   409    DATA_INTEGRITY_ERROR
  Database timeout/unavailable     503    SERVICE_UNAVAILABLE

## Mobile Verification

After resolving the customer, the supplied mobile number shall match the
registered mobile number.

Failure:

-   HTTP 409
-   Code: CUSTOMER_DETAILS_MISMATCH

## Consent Validity Window

Consent is valid only if:

``` text
consentTimestamp <= smsDeliveryTimestamp + Configured TAT (Default: 3 Days)
```

Failure:

-   HTTP 409
-   Code: CONSENT_TAT_EXPIRED

## Existing Consent

  Existing   Incoming   Result
  ---------- ---------- --------------------------
  None       YES / NO   CONSENT_RECORDED
  YES        YES        CONSENT_ALREADY_RECORDED
  NO         NO         CONSENT_ALREADY_RECORDED
  YES        NO         CONSENT_UPDATED
  NO         YES        CONSENT_UPDATED

## Idempotency

`transactionReference` uniquely identifies a CRM transaction.

Duplicate transactions shall not create duplicate records and shall
return the previously processed result.

------------------------------------------------------------------------

# Standard Response Format

``` json
{
  "status": "SUCCESS | FAILED",
  "code": "BUSINESS_CODE",
  "message": "Human readable message",
  "data": {},
  "errors": [
    {
      "field": "fieldName | null",
      "reason": "Detailed reason"
    }
  ]
}
```

> **Note:** `field` shall always be present in the error object. For
> non-field-specific errors, its value shall be `null`.

------------------------------------------------------------------------

# Sample Responses

## Consent Recorded (200)

``` json
{
  "status": "SUCCESS",
  "code": "CONSENT_RECORDED",
  "message": "Customer consent recorded successfully.",
  "data": {
    "transactionReference": "CRM-20260806-000001",
    "consent": "YES",
    "processedAt": "2026-08-06T16:16:12+05:30"
  },
  "errors": []
}
```

------------------------------------------------------------------------

## Consent Updated (200)

``` json
{
  "status": "SUCCESS",
  "code": "CONSENT_UPDATED",
  "message": "Customer consent updated successfully.",
  "data": {
    "transactionReference": "CRM-20260806-000001",
    "consent": "NO",
    "processedAt": "2026-08-06T16:16:12+05:30"
  },
  "errors": []
}
```

------------------------------------------------------------------------

## Consent Already Recorded (200)

``` json
{
  "status": "SUCCESS",
  "code": "CONSENT_ALREADY_RECORDED",
  "message": "The same customer consent has already been recorded.",
  "data": {
    "transactionReference": "CRM-20260806-000001",
    "consent": "YES",
    "processedAt": "2026-08-06T16:16:12+05:30"
  },
  "errors": []
}
```

------------------------------------------------------------------------

## Duplicate Transaction (200)

``` json
{
  "status": "SUCCESS",
  "code": "DUPLICATE_TRANSACTION",
  "message": "The transaction has already been processed.",
  "data": {
    "transactionReference": "CRM-20260806-000001",
    "consent": "YES",
    "processedAt": "2026-08-06T16:16:12+05:30"
  },
  "errors": []
}
```

------------------------------------------------------------------------

## CIF Not Found (404)

``` json
{
  "status": "FAILED",
  "code": "CIF_NOT_FOUND",
  "message": "Customer could not be located for the supplied CIF Number.",
  "data": null,
  "errors": [
    {
      "field": "cifNumber",
      "reason": "No customer exists with the supplied CIF Number."
    }
  ]
}
```

------------------------------------------------------------------------

## Customer Details Mismatch (409)

``` json
{
  "status": "FAILED",
  "code": "CUSTOMER_DETAILS_MISMATCH",
  "message": "The supplied mobile number does not match the registered mobile number for the customer.",
  "data": null,
  "errors": [
    {
      "field": "mobileNumber",
      "reason": "Mobile number mismatch."
    }
  ]
}
```

------------------------------------------------------------------------

## Consent TAT Expired (409)

``` json
{
  "status": "FAILED",
  "code": "CONSENT_TAT_EXPIRED",
  "message": "Customer consent cannot be processed because the consent validity period has expired. A fresh consent request must be initiated.",
  "data": null,
  "errors": [
    {
      "field": "consentTimestamp",
      "reason": "Consent received after the configured TAT of 3 days from the SMS delivery timestamp."
    }
  ]
}
```

------------------------------------------------------------------------

## Data Integrity Error (409)

``` json
{
  "status": "FAILED",
  "code": "DATA_INTEGRITY_ERROR",
  "message": "Customer data integrity violation detected.",
  "data": null,
  "errors": [
    {
      "field": "cifNumber",
      "reason": "Customer record exists in multiple databases."
    }
  ]
}
```

------------------------------------------------------------------------

## Request Throttled (429)

``` json
{
  "status": "FAILED",
  "code": "REQUEST_THROTTLED",
  "message": "The service is currently processing the maximum number of concurrent requests. Please retry later.",
  "data": null,
  "errors": [
    {
      "field": null,
      "reason": "Concurrent request threshold exceeded."
    }
  ]
}
```

------------------------------------------------------------------------

## Validation Error (400)

``` json
{
  "status": "FAILED",
  "code": "VALIDATION_ERROR",
  "message": "Request validation failed.",
  "data": null,
  "errors": [
    {
      "field": "mobileNumber",
      "reason": "Mobile number must be a valid 10-digit number."
    }
  ]
}
```

------------------------------------------------------------------------

## Unauthorized (401)

``` json
{
  "status": "FAILED",
  "code": "UNAUTHORIZED",
  "message": "Authentication failed.",
  "data": null,
  "errors": [
    {
      "field": null,
      "reason": "Invalid credentials supplied."
    }
  ]
}
```

------------------------------------------------------------------------

## Service Unavailable (503)

``` json
{
  "status": "FAILED",
  "code": "SERVICE_UNAVAILABLE",
  "message": "Customer resolution could not be completed because one or more data sources are unavailable.",
  "data": null,
  "errors": [
    {
      "field": null,
      "reason": "One or more databases were unavailable or timed out during customer resolution."
    }
  ]
}
```

------------------------------------------------------------------------

## Internal Server Error (500)

``` json
{
  "status": "FAILED",
  "code": "INTERNAL_SERVER_ERROR",
  "message": "An unexpected error occurred while processing the request.",
  "data": null,
  "errors": [
    {
      "field": null,
      "reason": "Please contact the system administrator if the problem persists."
    }
  ]
}
```

------------------------------------------------------------------------

# Response Codes

  HTTP   Business Code
  ------ ---------------------------
  200    CONSENT_RECORDED
  200    CONSENT_UPDATED
  200    CONSENT_ALREADY_RECORDED
  200    DUPLICATE_TRANSACTION
  400    VALIDATION_ERROR
  401    UNAUTHORIZED
  404    CIF_NOT_FOUND
  409    CUSTOMER_DETAILS_MISMATCH
  409    CONSENT_TAT_EXPIRED
  409    DATA_INTEGRITY_ERROR
  429    REQUEST_THROTTLED
  503    SERVICE_UNAVAILABLE
  500    INTERNAL_SERVER_ERROR


# Response Codes

  HTTP   Code                        Description
  ------ --------------------------- ---------------------------------------
  200    CONSENT_RECORDED            Consent recorded
  200    CONSENT_UPDATED             Consent updated
  200    CONSENT_ALREADY_RECORDED    Consent already recorded
  200    DUPLICATE_TRANSACTION       Duplicate transaction received
  400    VALIDATION_ERROR            Invalid request
  401    UNAUTHORIZED                Authentication failed
  404    CIF_NOT_FOUND               Customer not found
  409    CUSTOMER_DETAILS_MISMATCH   Mobile number mismatch
  409    CONSENT_WINDOW_EXPIRED      Consent TAT expired
  409    DATA_INTEGRITY_ERROR        Customer found in multiple databases
  429    REQUEST_THROTTLED           Request rejected by admission control
  503    SERVICE_UNAVAILABLE         One or more databases unavailable
  500    INTERNAL_SERVER_ERROR       Unexpected error








  --------------------------------------------------------------------------------
  Field                  Mandatory                  Description
  ---------------------- -------------------------- ------------------------------
  transactionReference   Yes                        Unique CRM transaction
                                                    identifier used for
                                                    idempotency

  cifNumber              Yes                        Customer CIF Number

  mobileNumber           Yes                        Registered mobile number

  consent                Yes                        YES / NO

  consentTimestamp       Yes                        Time consent was captured by
                                                    CRM

  agentId                No                         CRM Agent Identifier

  remarks                No                         Additional remarks
  --------------------------------------------------------------------------------
