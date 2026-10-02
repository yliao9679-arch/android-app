# BulkChef — Android WebView App

A lightweight Android app that wraps the BulkChef website in a native shell.
It opens the site full-screen (no browser address bar), handles the back
button, supports pull-to-refresh, and opens external links (maps, email,
phone) in the system browser. Essentially the website, packaged as an app.

> The website itself is also a **PWA** (installable from the browser, no APK
> needed). Use this Android project when you want a real APK for the Play Store
> or for sideloading.

---

## Repository contents

This folder is a **self-contained Android project** — it is meant to be the
**root of its own GitHub repository**. Upload the *contents* of this
`android-app/` folder (not the parent monorepo) to a new GitHub repo.

```
.
├── .github/workflows/build-apk.yml   # GitHub Actions: builds APKs in the cloud
├── app/                              # The Android app module (Kotlin + resources)
│   ├── build.gradle.kts
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/com/bulkchef/app/MainActivity.kt
│       └── res/                      # icons, strings, colors, theme, network config
├── gradle/                           # Gradle wrapper + version catalog
├── build.gradle.kts                  # Top-level Gradle config
├── settings.gradle.kts
├── gradle.properties
├── gradlew / gradlew.bat             # Gradle wrapper launchers
├── .gitignore
└── README.md                         # This file
```

## Requirements

- Android Studio (Hedgehog 2023.1.1 or newer) — only for local builds
- JDK 17
- Android SDK 35 (Android Studio installs this on first open)

> You do **not** need Android Studio, JDK, or the Android SDK installed on your
> computer to get an APK — the GitHub Actions workflow builds it in the cloud
> for free (see below).

---

## Option A — Build the APK online with GitHub Actions (recommended)

This is the easiest path: push the project to GitHub and let a cloud runner
build the APK for you. No local toolchain required.

### 1. Upload the project to GitHub

1. Create a new, empty repository on GitHub
   (e.g. `https://github.com/<your-user>/bulkchef-android`). Do **not** add a
   README, `.gitignore`, or license during creation — this folder already has
   them.
2. From inside this `android-app/` folder, run:

   ```bash
   # initialize git in this folder only
   git init
   git branch -M main
   git add .
   git commit -m "BulkChef Android WebView app"

   # paste your own repository URL from GitHub
   git remote add origin https://github.com/<your-user>/bulkchef-android.git
   git push -u origin main
   ```

   > If you cloned this project as part of a larger monorepo, copy the
   > `android-app/` folder somewhere fresh first, then run the commands above
   > from inside that copy so the Android project becomes the repo root.

### 2. Run the build workflow

The workflow at `.github/workflows/build-apk.yml` runs **automatically** on
every push that changes the app sources. You can also trigger it manually:

1. Open your repository on GitHub → **Actions** tab.
2. On the left, select **Build Android APK**.
3. Click **Run workflow** → choose the `main` branch → **Run workflow**.
4. Wait for the run to finish (a green ✓). A typical run takes 4–8 minutes.

### 3. Download the APK

1. Open the completed run (click the run title or the green ✓).
2. Scroll to the **Artifacts** section at the very bottom of the run summary.
3. Download one of:
   - **BulkChef-debug-APK** — signed with the debug key, installable right
     away for testing/sideloading.
   - **BulkChef-release-APK** — unsigned; sign it with your own key before
     publishing to the Play Store.
4. Unzip the downloaded file — the `.apk` inside is your installable app.

> The debug APK is auto-signed and can be sideloaded on any Android device
> with **Settings → "Install unknown apps"** enabled for your file manager.
> The release APK is unsigned; sign it with `apksigner` (or Android Studio's
> **Build → Generate Signed Bundle / APK**) before publishing.

---

## Option B — Build locally with Android Studio

1. Open Android Studio → **Open** → select this folder (the one containing
   `settings.gradle.kts`).
2. Let Gradle sync (it downloads dependencies on first run).
3. To run on a device/emulator: connect a device with USB debugging on, then
   press **Run ▶**.
4. To build a release APK: **Build → Build Bundle(s) / APK(s) → Build APK(s)**.
   The APK lands in `app/build/outputs/apk/release/`.
5. For a signed, Play-Store-ready bundle use
   **Build → Generate Signed Bundle / APK**.

---

## Configure the website URL

Before shipping, point the app at your **published** domain.

Open `app/src/main/java/com/bulkchef/app/MainActivity.kt` and edit:

```kotlin
const val SITE_URL = "https://your-bulkchef-domain.com/"
```

The value shipped in the file is a preview URL for testing only. After
changing it, commit and push — GitHub Actions will rebuild the APK
automatically.

## What the app does

- Loads the BulkChef site in a full-screen WebView.
- JavaScript, DOM storage, and offline cache enabled (the site's own service
  worker handles offline).
- Back button walks WebView history; exits only at the root page.
- Pull-to-refresh with the BulkChef orange spinner.
- `tel:`, `mailto:`, maps and social links open in the matching external app.
- Survives screen rotation without reloading the page.

## Package & signing

- Application ID: `com.bulkchef.app`
- Generate your own signing key with `keytool` and configure it in
  **Build → Generate Signed Bundle** before publishing to the Play Store.
- Never commit your signing key or `keystore` file (`.gitignore` already
  excludes `*.keystore`).
