# Headless WebLiero

## Relevant links

* [WebLiero Headless API](https://www.webliero.com/headlessdocs.txt)
* [HaxBall Headless API](https://github.com/haxball/haxball-issues/wiki/Headless-Host) (relevant portions identical to WebLiero)
* [Get headless token](https://api.webliero.com/getheadlesstoken)
* [Get player auth](https://www.webliero.com/playerauth)

## Chromium Launcher script

Place this somewhere like `~/bin/webliero-headless` and `chmod +x` it.

```bash
#!/usr/bin/bash

# Based on:
# https://github.com/deepsweet/chromium-headless-remote/blob/master/entrypoint.sh
#
# --disable-features=WebRtcHideLocalIpsWithMdns is required with Chromium >= 78, otherwise
# rooms become unconnectable.
# See https://groups.google.com/forum/#!topic/discuss-webrtc/6stQXi72BEU

# First argument is the debug port
DEBUG_PORT=${1:-9222}

# Second argument is the website URL
URL=${2:-https://www.webliero.com/headless}

/usr/bin/chromium \
  --disable-background-networking \
  --disable-background-timer-throttling \
  --disable-breakpad \
  --disable-client-side-phishing-detection \
  --disable-default-apps \
  --disable-dev-shm-usage \
  --disable-extensions \
  --disable-sync \
  --disable-translate \
  --disable-popup-blocking \
  --disable-prompt-on-repost \
  --disable-audio-output \
  --headless \
  --hide-scrollbars \
  --ignore-certificate-errors \
  --ignore-certificate-errors-spki-list \
  --ignore-ssl-errors \
  --metrics-recording-only \
  --mute-audio \
  --no-sandbox \
  --no-first-run \
  --remote-debugging-address=127.0.0.1 \
  --remote-debugging-port=$DEBUG_PORT \
  --safebrowsing-disable-auto-update \
  --disable-gpu \
  --disable-features=WebRtcHideLocalIpsWithMdns \
  $URL
```

## Setup

In a `screen` session in remote machine:

```
bin/webliero-headless 9222
```

In local machine:

```
ssh -L 9222:localhost:9222 %REMOTE_HOST%
```

Then in a local Chrome/Chromium access http://localhost:9222 and paste the following init script in the JS console:

```javascript
room = WLInit({
  token: "TOKEN", # ⚠️ Replace with token from https://api.webliero.com/getheadlesstoken
  roomName: "Pro Mode ᴰᴱᴰ", # ⚠️ Replace with actual room name
  noPlayer: true,
  maxPlayers: 12,
  public: true,
  scoreLimit: 10,
  respawnDelay: 3,
  bonusDrops: "health"
});

# Provide admin on room join
room.onPlayerJoin = function(player) {
  # ⚠️ Replace player auth with your own public key (the one shown here is pilaf's)
  if (player.auth == "nilGYweBI76riN6nO1DEDfPYPhP7wO31PM55wqy-5QA") {
    room.setPlayerAdmin(player.id, true);
  }
};
```

## Recommended room settings

### Liero Promode Final

* Game Mode: Deathmatch (default)
* Score Limit: 10
* Time Limit: 10 (default)
* Level Pool: Arenas: Good (67)
* Expand Level: Off (default)
* Loading Times: 0.4 (default)
* Force Randomize Weapons: Off (default)
* Teams Locked: Off (default)
* Damage Multiplier: 1 (default)
* Respawn Delay: 3
* Reload Weapons On Spawn: On (default)
* Lock Weapons During Match: Off (default)
* Bonus Drops: Health only
* Bonus Spawn Frequency: 30 (default)
* Weapon Bans: Big Nuke, Hoover Crack, Bouncy Larpaa

### Liero 1.33

* Game Mode: Deathmatch (default)
* Score Limit: 10
* Time Limit: 10
* Level Pool: All: Best (52)
* Expand Level: Off (default)
* Loading Times: 0.4 (default)
* Force Randomize Weapons: Off (default)
* Teams Locked: Off (default)
* Damage Multiplier: 1 (default)
* Respawn Delay: 3
* Reload Weapons On Spawn: On (default)
* Lock Weapons During Match: Off (default)
* Bonus Drops: Health only
* Bonus Spawn Frequency: 30 (default)
* Weapon Bans: Big Nuke, Crackler, Bouncy Larpa
