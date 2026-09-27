# Official Sources

All public-system claims in this Proof of Work are based on official primary sources.

Access date for this version: **2026-09-27**.

## GOV.UK One Login

**Publisher:** Government Digital Service  
**Source:** GOV.UK One Login Technical Documentation  
**URL:** https://docs.sign-in.service.gov.uk/

Supporting official source:  
https://www.gov.uk/government/publications/govuk-one-login-privacy-notice/govuk-one-login-privacy-notice

Public facts used in the model:
- government services can use GOV.UK One Login to sign in users;
- government services can use it to prove users' identity;
- GOV.UK One Login is provided by the Government Digital Service.

Modeled relationship:
- Government Digital Service -[:PROVIDES]-> GOV.UK One Login

Modeled capabilities:
- Authentication
- Identity Verification

## Login.gov

**Publisher:** Login.gov / U.S. General Services Administration  
**Source:** About us  
**URL:** https://www.login.gov/about-us/

Public facts used in the model:
- Login.gov provides a single account for access to participating government websites;
- it supports authentication and identity verification;
- the program operates as a division integrated into GSA's Technology Transformation Services.

Modeled relationship:
- U.S. General Services Administration -[:OPERATES]-> Login.gov

Modeled capabilities:
- Authentication
- Identity Verification

## Singpass

**Publisher:** Government Technology Agency of Singapore  
**Source:** Singpass Developer Portal  
**URL:** https://developer.singpass.gov.sg/

Public facts used in the model:
- Singpass is described as a trusted digital identity;
- Singpass Login provides authentication;
- Myinfo supports consent-based use of verified data;
- Sign with Singpass supports secure electronic signatures;
- the official developer portal identifies the service as powered by GovTech.

Modeled relationship:
- Government Technology Agency of Singapore -[:POWERS]-> Singpass

Modeled capabilities:
- Digital Identity
- Authentication
- Digital Signature
- Consent-Based Data Sharing

## X-Road

**Publisher:** X-Road / Nordic Institute for Interoperability Solutions  
**Source:** X-Road Technology Overview  
**URL:** https://x-road.global/x-road-technology-overview

Supporting official sources:
- https://docs.x-road.global/Architecture/arc-sec_x_road_security_architecture.html
- https://www.niis.org/history
- https://www.niis.org/blog/2019/10/30/x-road-as-a-platform-to-exchange-mydata

Public facts used in the model:
- X-Road is a centrally managed distributed data exchange layer between information systems;
- it provides standardized and secure ways to produce and consume services;
- it supports interoperability;
- NIIS is responsible for development and maintenance of the X-Road core.

Modeled relationship:
- Nordic Institute for Interoperability Solutions -[:MAINTAINS]-> X-Road

Modeled capabilities:
- Secure Data Exchange
- Interoperability

## Claims boundary

This repository models only high-level public capabilities supported by the sources above.

It does **not** claim to reproduce:
- internal system architecture;
- implementation details not present in public documentation;
- security accreditation;
- operational topology;
- private integrations;
- government datasets;
- proprietary or confidential information.
