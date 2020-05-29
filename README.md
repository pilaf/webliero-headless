# Headless WebLiero

## Relevant links

* [WebLiero Headless API](https://www.webliero.com/headlessdocs.txt)
* [HaxBall Headless API](https://github.com/haxball/haxball-issues/wiki/Headless-Host) (relevant portions identical to WebLiero)
* [Get headless token](http://www.webliero.com/headlesstoken)
* [Get player auth](https://www.webliero.com/playerauth)
* [WebLiero Headless Launcher](https://gitlab.com/basro/webliero-headless-launcher)

## Method 1: WebLiero Headless Launcher

### Setup

This requires installing nodejs and [WebLiero Headless Launcher](https://gitlab.com/basro/webliero-headless-launcher). Additionally `daemonize` is needed for the server launcher script.

Place this somewhere like `~/bin/wlhl-server-start` and `chmod +x` it:

```bash
#!/usr/bin/env bash

echo Starting wlhl server...

daemonize -p $HOME/tmp/wlhl-server.pid -l $HOME/tmp/wlhl-server.lock -o $HOME/log/wlhl-server.log -a $(which wlhl) server --chrome-path=$(which chromium-browser)
```

Place this somewhere like `~/bin/wlhl-server-stop` and `chmod +x` it:

```bash
#!/usr/bin/env bash

echo Stopping whlh server...

pkill -F $HOME/tmp/wlhl-server.pid && rm $HOME/tmp/wlhl-server.{pid,lock}
```

To make the wlhl server autostart on reboot add it to cron with `crontab -e`:

```
@reboot PATH=$PATH:/usr/local/bin ~/bin/wlhl-server-start >> ~/log/cron.log 2>&1
```

Create a directory like `~/wlhl-scripts` where to put your room .js scripts.

You can create a `basic.js` script with:

```js
(async function () {
  console.log("Running Server...");
  const room = window.WLInit({
    token: window.WLTOKEN,
    roomName: "Pro Mode ReRevisited ᴰᴱᴰ",
    maxPlayers: 12,
    public: true,
    geo: {lat: -14.2, lon: -51.9, code: "br"}
  });
  window.WLROOM = room;

  room.setSettings({
    scoreLimit: 10,
    respawnDelay: 3,
    bonusDrops: "health",
    maxDuplicateWeapons: 0
  });

  room.onRoomLink = (link) => console.log(link);
  room.onPlayerChat = (player, message) => console.log(`<${player.name}> ${message}`);
  room.onCaptcha = () => console.log("Invalid token");

  // ⚠️ Replace player auth with your own public key (the one shown here is pilaf's)
  const admins = new Set(["nilGYweBI76riN6nO1DEDfPYPhP7wO31PM55wqy-5QA"]);

  room.onPlayerJoin = (player) => {
    if ( admins.has(player.auth) ) {
      room.setPlayerAdmin(player.id, true);
    }
  }
})();
```

### Launching a room

Run:

```bash
wlhl launch ~/wlhl-scripts/basic.js --id=rerev --token=TOKEN
```

Make sure to replace TOKEN with an actual token

## Method 2 (the "old method"): Chromium Launcher script

### Setup

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

## Launching a room

See [server provisioning](#server-provisioning) below for initial server setup.

In a `screen` session in remote machine:

```bash
bin/webliero-headless 9222
```

In local machine:

```bash
ssh -L 9222:localhost:9222 %REMOTE_HOST%
```

Then in a local Chrome/Chromium access http://localhost:9222 and paste the following init script in the JS console:

```javascript
room = WLInit({
  token: "TOKEN", // ⚠️ Replace with token from http://www.webliero.com/headlesstoken
  roomName: "Pro Mode ᴰᴱᴰ", // ⚠️ Replace with actual room name
  noPlayer: true,
  maxPlayers: 12,
  public: true
});

room.setSettings({
  scoreLimit: 10,
  respawnDelay: 3,
  bonusDrops: "health",
  maxDuplicateWeapons: 0
});

// Provide admin on room join
room.onPlayerJoin = function(player) {
  // ⚠️ Replace player auth with your own public key (the one shown here is pilaf's)
  if (player.auth == "nilGYweBI76riN6nO1DEDfPYPhP7wO31PM55wqy-5QA") {
    room.setPlayerAdmin(player.id, true);
  }
};
```

## Server provisioning

### Arch Linux

Install tools:

```bash
sudo pacman -S vim screen chromium
```

Create `webliero` user:

```bash
sudo useradd -m -G wheel -s /bin/bash webliero
```

Make `vim` the default editor:

```
echo "EDITOR=vim" >> /etc/environment
source /etc/environment && export EDITOR
```

Edit `sudoers` file and grant `sudo` access to `wheel` group:

```bash
visudo
```

### Ubuntu

Install tools:

```bash
sudo apt install chromium-browser screen nodejs npm
```

Create `webliero` user:

```bash
sudo adduser webliero
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
