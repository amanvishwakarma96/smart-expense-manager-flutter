# PiggyAI Privacy Policy

**Effective date:** 11 August 2026

PiggyAI is an offline-first personal expense manager. This policy describes how the PiggyAI mobile app handles information on Android and iOS.

## Summary

PiggyAI does not operate a user account system, backend, cloud synchronization service, advertising platform, analytics service, telemetry service, or remote AI service. Financial data is processed and stored on the user's device unless the user explicitly creates and shares an encrypted backup.

## Android SMS access

Android SMS access is optional and is used only for PiggyAI's core SMS-based money-management functionality.

When the user explicitly enables SMS detection, PiggyAI may:

- read recent SMS inbox messages to identify bank and payment transaction alerts; and
- receive new SMS alerts so eligible transactions can be detected when they arrive, including while PiggyAI is not open.

SMS messages are parsed on the device. Matching financial alerts become pending transactions that require user review. Unmatched messages are not stored by PiggyAI. PiggyAI does not send SMS text or detected financial data to the developer, a server, an advertiser, an analytics provider, or another third party.

The user can decline or revoke SMS permission and continue using manual transaction entry. iOS does not expose the SMS inbox to PiggyAI, so iOS uses manual entry.

## Information stored locally

Depending on the features the user chooses, PiggyAI may store the following information locally on the device:

- pending and confirmed transactions;
- transaction amounts, dates, debit/credit direction, and transaction purposes;
- merchant names and account tails;
- transaction notes and categories;
- merchant-category rules and learned mappings;
- recurring items and reminder preferences;
- budgets, savings goals, challenges, and local planning metadata; and
- privacy, lock, backup-reminder, and other app settings.

Sensitive persisted text follows PiggyAI's encrypted-storage pattern. Installation encryption material is stored using platform secure-storage facilities.

## Data collection and sharing

PiggyAI does not transmit user financial data, SMS content, analytics events, advertising identifiers, diagnostics, or app-usage telemetry to the developer or third parties. The Android production manifest does not request the `INTERNET` permission.

For store privacy-label terminology, PiggyAI does not "collect" user data because app data is not transmitted off the device to the developer or a third party by PiggyAI.

## Encrypted backup export

Backups are created only when the user explicitly requests an export. Backup contents are encrypted before export. The user chooses where to send or save the encrypted backup using the operating system's share flow.

After the user selects an external app or service as the destination, that destination is outside PiggyAI and is governed by the privacy practices of the destination selected by the user.

PiggyAI does not provide automatic cloud backup or automatic cloud synchronization.

## Device backup, screenshots, and app lock

Android cloud/device-transfer backup is disabled for PiggyAI app data. PiggyAI also supports privacy masking, optional biometric or device-lock protection, and secure-screen controls on supported platforms.

## Retention and deletion

Local financial records remain on the device until the user edits or deletes them, restores a different encrypted backup, clears all local financial data, or removes the app according to operating-system behavior.

PiggyAI provides a Delete all financial data action that removes local financial records and the installation encryption key managed by PiggyAI.

## User choices

Users can:

- use manual transaction entry without SMS permission;
- decline SMS permission or revoke it later in Android system settings;
- review every SMS-detected transaction before it affects financial records;
- hide financial amounts in the user interface;
- enable or disable app-lock options;
- explicitly export an encrypted backup; and
- permanently delete local financial data from Settings.

## Children's privacy

PiggyAI is a personal money-management application and is not designed or marketed as a child-directed service. It does not contain advertising or behavioral tracking.

## Security limitations

PiggyAI is designed to reduce accidental exposure and ordinary app-to-app leakage, but no mobile application can guarantee protection on a rooted, jailbroken, malware-compromised, or physically unlocked device. Users should keep their operating system and device lock up to date.

## Changes to this policy

If PiggyAI's data practices change, this policy and the relevant app-store privacy disclosures should be updated before the changed behavior is released.

## Developer and support

Developer: **Aman Vishwakarma / PiggyAI project**.

The official app-store listing and the public PiggyAI project repository provide the current support/contact channel for privacy questions and release support.
