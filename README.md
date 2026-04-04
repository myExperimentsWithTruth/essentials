# Eight

A minimal, intentional phone launcher for iPhone. Eight apps. No more.

Strip your phone back to what matters — no icons, no colours, no distractions. Just text, time, and the few apps you chose to keep.

<p align="center">
  <img src="screenshots/home-dark.png" alt="eight — home" width="150">
  &nbsp;
  <img src="screenshots/settings-eink.png" alt="eight — e-ink theme" width="150">
  &nbsp;
  <img src="screenshots/settings-oled.png" alt="eight — power saver theme" width="150">
</p>

---

## Why Eight.

We could have called it Minimal. Or Focus. Or Zen. Or any word that sounds calm and photographs well.

We called it Eight because that is the entire product. Eight apps. Not nine. Not "up to twelve with premium." Eight.

The name is the constraint. The constraint is the philosophy. There is nothing behind it to configure, nothing beneath it to unlock. You open your phone, you see eight things you chose, and you get on with your life.

We did not name it after a feeling. We named it after a limit. Because feelings fade. Limits hold.

## The problem is not your phone. It is the menu.

A smartphone is an infinite menu. Every app on it competes for your attention. Every notification is a tap on the shoulder. Every home screen is a negotiation you did not ask for.

The default state of a modern phone is overstimulation. Not because the technology is bad, but because it was designed to hold you — not to let you go.

## Less is not a limitation. It is a decision.

Eight does not help you use your phone better. It helps you use it less.

You get eight slots. Eight apps. That is it. If you want to add something, you have to remove something. This is not a restriction — it is a conversation with yourself. What do I actually need right now? What can I let go of?

Most people have never asked themselves that question. Not because they do not care, but because no one forced them to.

## This is not for monks.

Eight is not for people who have already achieved simplicity. It is for people who are trying to. People who are stretched across too many things. People who open their phone for a reason and forget it thirty minutes later. People who have tried other minimalist apps and ended up with fifteen customisation options for how to be minimal.

The irony is not lost on us. The app that helps you do less should not ask you to do more.

## The grayscale principle.

Every phone has a grayscale mode. It is buried in accessibility settings. Almost no one uses it — not because it does not work, but because no one surfaces it. Studies show that removing colour from a screen reduces compulsive usage. The dopamine hit fades when Instagram looks like a newspaper.

Eight surfaces this. Not as a gimmick, but as a default posture. Pair it with grayscale. See what changes.

## Design by removal.

MUJI does not remove features because it cannot afford them. It removes them because the absence is the design. No branding, no decoration, no excess. What remains is only what is necessary.

Eight follows the same principle. There are no widgets. No feed. No badges. No colour themes competing for your preference. The interface is text on a surface. The typography is light. The separators are thin. Everything that is not essential has been removed — including the word "app" from the experience.

## The rules.

1. Eight apps. No more. Choose carefully.
2. To add one, let go of one. The friction is the feature.
3. No notifications. If it is urgent, someone will call.
4. Grayscale is recommended, not enforced. But try it for a week.
5. The phone is a tool. Use it, then put it down.

## A quiet admission.

This app was not built from research or market analysis. It started with one person trying to take back control of his own device.

It began with notifications. Then email — switched to pull, not push. Then scheduled notification windows. But none of it was enough, because the phone itself is designed to pull you back. The colours, the badges, the layout — every pixel is optimised to keep you on the device longer.

He looked for apps that could help. Most of them asked him to spend thirty minutes configuring how to be distracted less. The irony was hard to ignore.

So he built one. No onboarding wizard. No feature list. No customisation rabbit hole. Just a dark screen, a few words, and the discipline of eight.

If that sounds like you, welcome. If it does not, that is fine too. There are plenty of other apps for that.

## Why this is free.

Because charging for it would contradict everything it stands for. You do not monetise someone's attempt to reclaim their attention. The time we spent building this was not an investment. It was a belief that fewer people staring at their phones is a good thing. No ads, no premium tier, no data collection, no "upgrade to unlock ten apps." Eight is eight. For everyone.

---

## Features

### Launcher
- Large clock — 64pt ultralight, always visible
- Date — lowercase, minimal
- App list — tap a label, open the app. That is it.

### Phone (built-in)
- Favourites tab — add contacts from your address book, tap to message via WhatsApp
- Dialler tab — full numeric keypad, tap the green button to call
- Contact search — search your entire contact list, add to favourites

### Camera
Opens the iOS camera inline. Take a photo, it saves to your library, and you return to the launcher. No gallery, no filters, no editing.

### Themes
Three themes, persisted across launches:
- **default** — dark (#121212), white text
- **e-ink** — warm paper background, dark text, muted accents
- **power saver** — pure OLED black, dim text, minimal battery draw

Pair any theme with iOS Settings > Accessibility > Display > Color Filters > Grayscale for the full experience.

## Requirements

- iPhone running iOS 17+
- Xcode 15+
- Apple ID (free personal team works for sideloading)

## Setup

```bash
git clone https://github.com/myExperimentsWithTruth/essentials.git
cd essentials
open EssentialsApp.xcodeproj
```

1. In Xcode: Signing & Capabilities > select your Apple ID team
2. Connect your iPhone via USB
3. Select your iPhone as the build target
4. Cmd + R to build and run

### First launch on device
iOS will show "Untrusted Developer". Go to:
Settings > General > VPN & Device Management > [your Apple ID] > Trust

Then run again from Xcode.

> Free Apple ID signing lasts 7 days. Re-run from Xcode to refresh. A paid Developer account ($99/year) makes it permanent.

## Permissions

| Permission | Why |
|------------|-----|
| Contacts | To search and call contacts from the phone view |
| Camera | To take photos from the camera launcher item |
| Photo Library (add) | To save captured photos |

---

*crafted with [claude](https://claude.ai)*
