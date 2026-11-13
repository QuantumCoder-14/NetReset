# NetReset

**Fix "connected but no internet" from one menu, without digging through network settings.**

A single `.bat` file. Double-click, pick a number, press Enter. Every option says what it
does and what it will cost you before it runs.

Sibling to [CrapClean](https://github.com/QuantumCoder-14/CrapClean): that one clears clutter,
this one clears the network state that goes stale.

---

## Run it

1. Download `netreset.bat` from [Releases](https://github.com/QuantumCoder-14/NetReset/releases).
2. Double-click it.
3. Windows asks for administrator rights — **Yes**. It needs them; the network commands
   do nothing without.
4. Pick a number.

---

## The menu

| Option | What it does | When to use it | Cost |
| --- | --- | --- | --- |
| **1. Flush DNS cache** | `ipconfig /flushdns` | "This site can't be reached" while other sites work | None. Instant. |
| **2. Renew IP address** | `ipconfig /release` then `/renew` | Connected to Wi-Fi but no internet; router changed | Connection drops for a few seconds |
| **3. Clear ARP cache** | `netsh interface ip delete arpcache` | Can reach nothing on the local network | None. Rebuilds in seconds. |
| **4. Reset Winsock + TCP/IP** | `netsh winsock reset`, `netsh int ip reset` | Still broken after 1-3; after a VPN, proxy tool or malware clean-up | **Needs a restart.** Can drop hand-set proxy and static IP settings. |
| **5. Safe steps (1 + 3)** | DNS and ARP only | The usual first attempt | None |
| **6. Show network config** | `ipconfig /all`, DNS cache | When you want to see what is actually happening | Read only |

Order that actually works: **try 5, then 2, then 4.** Option 4 is the sledgehammer and it
costs you a restart, so it should not be step one.

---

## What it never touches

No files, no folders, no registry keys, no installed programs, no Wi-Fi passwords, no
browser data. Every command it runs is an `ipconfig` or `netsh` network command, and each
one is printed in the README and visible in the file itself.

Option 4 is the only one that changes configuration rather than clearing a cache, which is
why it asks you to type `YES` and tells you it needs a restart.

---

## Honest limitations

- **Windows only.** These are Windows commands; there is no Linux or macOS version.
- **It cannot fix a broken router, a dead ISP, or a wrong Wi-Fi password.** It clears
  client-side state. If the router is the problem, restart the router.
- **Option 2 on a hand-configured static IP** can leave you offline. The menu says so before
  it runs. If you do not know whether you have a static IP, use option 1 instead.
- **Not code-signed**, so SmartScreen may warn on first run: *More info → Run anyway*. The
  file is 3 KB of plain text — open it in Notepad and read it first if you like.
- **Untested on this machine.** Written and reviewed, but the author had no Windows machine
  at hand when it was published. Every command is a documented Windows built-in, and the
  menu is deliberately boring so that a failure is obvious rather than silent. If something
  misbehaves, open an issue with your Windows version.

---

## Licence

MIT License with Commons Clause — use it, change it, share it, don't sell it.
See [LICENSE.md](LICENSE.md).

Copyright (c) 2026 Siddhant Neekhra.
