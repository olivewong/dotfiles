#!/usr/bin/env python3
"""cute statusline: gradient ctx bar, real period spend, clickable git, a little pet habitat."""

import json, os, random, subprocess, sys, time, hashlib
from datetime import date, datetime
from pathlib import Path

HOME = Path.home()
STATE = HOME / ".claude" / "statusline-state"
PROJECTS = HOME / ".claude" / "projects"
BUDGET = float(os.environ.get("CLAUDE_BUDGET_USD") or 400)

C = dict(
    base="#1e1e2e",
    s0="#313244",
    s1="#45475a",
    s2="#585b70",
    text="#cdd6f4",
    sub="#a6adc8",
    ov="#7f849c",
    pink="#f5c2e7",
    mauve="#cba6f7",
    red="#f38ba8",
    maroon="#eba0ac",
    peach="#fab387",
    yellow="#f9e2af",
    green="#a6e3a1",
    teal="#94e2d5",
    sky="#89dceb",
    blue="#89b4fa",
    lav="#b4befe",
)
RST = "\x1b[0m"
GRAD = [C["green"], C["teal"], C["sky"], C["lav"], C["pink"], C["peach"], C["red"]]

# glyphs verified present in the installed fira code / hack nerd fonts
G = dict(
    model="\U000f06a9",
    dir="\U000f024b",
    branch="\U000f062c",
    pr="\U000f04c2",
    ctx="\U000f035b",
    coin="\U000f01c1",
    vault="\U000f0116",
    vim="",
    plus="+",
    pencil="✎",
    quest="?",
    up="↑",
    down="↓",
    warn="!",
    bolt="",
    leaf="",
    tree="\U000f0405",
    grass="\U000f0e66",
)

PETS = [  # 2h blocks: who is out at that time of day (owl removed)
    ("\U000f15c6", "\U000f0b5f"),  # bird, bat
    ("\U000f01e5", "\U000f1677"),  # duck, snail
    ("\U000f01e5", "\U000f0907"),  # duck, rabbit
    ("\U000f15c6", "\U000f0907"),  # bird, rabbit
    ("\U000f011b", "\U000f0a43"),  # cat, dog
    ("\U000f0a44", "\U000f1589"),  # dog (side), butterfly
    ("\U000f011b", "\U000f0907"),  # cat, rabbit
    ("\U000f0907", "\U000f0fa1"),  # rabbit, bee
    ("\U000f0ec0", "\U000f0cd7"),  # penguin, turtle
    ("\U000f011b", "\U000f01e5"),  # cat, duck
    ("\U000f1677", "\U000f15c6"),  # snail, bird
    ("\U000f011b", "\U000f0b5f"),  # cat, bat
]
EXTRA_PETS = [
    "\U0001f980︎",  # crab
    "\U0001f9ad︎",  # seal
    "\U0001f98b︎",  # butterfly
    "\U0001f422︎",  # turtle
]
TOYS = [
    "\U000f010f",  # carrot
    "\U000f0198",  # cookie
    "\U000f023a",  # fish
    "\U000f024a",  # flower
    "\U000f02d1",  # heart
    "\U000f04b2",  # sleep (zzz)
    "\U000f04b8",  # soccer ball
    "\U000f0507",  # tennis ball
    "\U000f0a26",  # balloon
    "\U000f07df",  # mushroom
    "\U000f0387",  # music note
    "\U0000ec1b",  # music (codicon)
    "\U000f025b",  # apple
    "\U0001f338\U0000fe0e",  # flower (emoji)
    "\U0001fab4\U0000fe0e",  # potted plant (no watering-can emoji exists; closest match)
    "\U0001f3b8\U0000fe0e",  # guitar
    "\U0001f36c\U0000fe0e",  # candy
    "\U0001f3d2\U0000fe0e",  # hockey stick and puck
    "\U00002728\U0000fe0e",  # sparkle
    "\U0001f9f9\U0000fe0e",  # broom
    "\U0001f496\U0000fe0e",  # heart sparkle
    "\U0001f49c\U0000fe0e",  # purple heart
    "\U0001f495\U0000fe0e",  # double/two hearts
    "\U0001f308\U0000fe0e",  # rainbow
    "\U0001f3f3\U0000fe0f\U0000200d\U0001f308",  # pride flag (ZWJ sequence; no text form)
    "\U0001f6cd\U0000fe0e",  # shopping bags
    "\U0001f490\U0000fe0e",  # bouquet
    "\U0001fab7\U0000fe0e",  # lotus (no lily-pad emoji exists; closest match)
    "\U0001f3a4\U0000fe0e",  # mic
    "\U0001fa87\U0000fe0e",  # maracas
    "\U0001f3b7\U0000fe0e",  # sax
    "\U0001f9c3\U0000fe0e",  # juice box
    "\U0001f94d\U0000fe0e",  # lacrosse
    "\U0001f9f8\U0000fe0e",  # teddy bear
    "\U000f04e5",
]  # sword
FOLIAGE_L = [
    "\U000f0405",  # pine tree
    "\U000f024a",  # flower
    "\U000f0db5",  # cactus
]
FOLIAGE_R = [
    "\U000f09f1",  # tulip
    "\U000f0405",  # pine tree
    "\U000f0e66",  # sprout
]
FOOD = [
    "\U000f010f",  # carrot
    "\U000f025b",  # apple
    "\U000f1044",  # grapes
    "\U000f0e66",  # sprout
    "\U000f07c8",  # croissant
    "\U0001f36c",  # candy
    "\U0001f361",  # dango (mochi balls)
    "\U0001f353",  # strawberry
    "\U0001f349",  # watermelon
    "\U0000e29b",  # cherry
    "\U0000e264",  # cheese
    "\U0000e281",  # banana
    "\U000f0725",  # corn
]
PET_COLOR_OVERRIDE = {
    "\U000f01e5": C["yellow"],  # duck: yellow
}
ITEM_COLOR_OVERRIDE = {
    # --- previously added ---
    "\U000f0725": C["yellow"],  # corn: yellow
    "\U0001f3c0\U0000fe0e": C["peach"],  # basketball: orange (closest palette color)
    # --- nerd-font FOOD, hardcoded by theme ---
    "\U000f010f": C["peach"],  # carrot: orange
    "\U000f025b": C["red"],  # apple: red
    "\U000f1044": C["mauve"],  # grapes: purple
    "\U000f0e66": C["green"],  # sprout: green
    "\U000f07c8": C["peach"],  # croissant: golden brown
    "\U0000e29b": C["red"],  # cherry: red
    "\U0000e264": C["yellow"],  # cheese: yellow
    "\U0000e281": C["yellow"],  # banana: yellow
    # --- nerd-font TOYS, hardcoded by theme ---
    "\U000f00b9": C["sub"],  # bone: bone-white
    "\U000f0198": C["peach"],  # cookie: golden brown
    "\U000f023a": C["sky"],  # fish: blue
    "\U000f024a": C["pink"],  # flower: pink
    "\U000f02d1": C["red"],  # heart: red
    "\U000f04b2": C["lav"],  # sleep (zzz): lavender
    "\U000f04b8": C["sub"],  # soccer ball: black/white
    "\U000f0507": C["green"],  # tennis ball: green
    "\U000f095a": C["pink"],  # cupcake: pink
    "\U000f0a26": C["red"],  # balloon: red
    "\U000f07df": C["red"],  # mushroom: red cap
    "\U000f0387": C["lav"],  # music note: lavender
    "\U0000ec1b": C["lav"],  # music (codicon): lavender
    "\U0000ed67": C["ov"],  # dumbbell: steel grey
    "\U000f04e5": C["sky"],  # sword: steel blue
}
FEED_AUTO_SECS = 300
FEED_WINDOW_SECS = 30

PRICE = {  # $ per 1M tokens: (input, output)
    "claude-opus-5": (5.0, 25.0),
    "claude-opus-4-8": (5.0, 25.0),
    "claude-opus-4-7": (5.0, 25.0),
    "claude-opus-4-6": (5.0, 25.0),
    "claude-fable-5": (10.0, 50.0),
    "claude-fable-5-1": (10.0, 50.0),
    "claude-mythos-5": (10.0, 50.0),
    "claude-mythos-5-1": (10.0, 50.0),
    "claude-sonnet-5": (2.0, 10.0),
    "claude-sonnet-4-6": (3.0, 15.0),
    "claude-haiku-4-5": (1.0, 5.0),
}
FLAT_READ = {"claude-fable-5-1": 0.25, "claude-mythos-5-1": 0.25}


def _rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i : i + 2], 16) for i in (0, 2, 4))


def fg(c, s, bold=False):
    r, g, b = _rgb(c)
    return ("\x1b[1m" if bold else "") + f"\x1b[38;2;{r};{g};{b}m{s}{RST}"


def grad(t):
    t = max(0.0, min(1.0, t))
    n = len(GRAD) - 1
    i = min(int(t * n), n - 1)
    a, b, u = _rgb(GRAD[i]), _rgb(GRAD[i + 1]), t * n - i
    return "#%02x%02x%02x" % tuple(round(a[j] + (b[j] - a[j]) * u) for j in range(3))


def link(url, s):
    return f"\x1b]8;;{url}\x1b\\{s}\x1b]8;;\x1b\\" if url else s


class S:
    """one chunk: rendered text, printable width, drop priority (higher drops first)."""

    def __init__(self, ansi, plain, prio=5):
        self.ansi, self.plain, self.prio = ansi, plain, prio


_sep_i = [0]


def sep():
    i = _sep_i[0] % len(GRAD)
    _sep_i[0] += 1
    return S(fg(GRAD[i], "│"), "│", 9)


def _norm(xs):
    out = []
    for s in xs:
        if s.prio == 9 and (not out or out[-1].prio == 9):
            continue
        out.append(s)
    while out and out[-1].prio == 9:
        out.pop()
    return out


def fit(segs, cols, gap):
    segs = _norm([s for s in segs if s])
    while segs:
        w = sum(len(s.plain) for s in segs) + len(gap) * (len(segs) - 1)
        if w <= cols:
            return segs, w
        keep = [s for s in segs if s.prio < 9]
        if not keep:
            return [], 0
        segs.remove(max(keep, key=lambda s: s.prio))
        segs = _norm(segs)
    return [], 0


def row(left, right, cols, gap="  "):
    right, rw = fit(right, int(cols * 0.62), gap)
    left, lw = fit(left, max(0, cols - rw - 2), gap)
    out = gap.join(s.ansi for s in left)
    if right:
        out += " " * max(1, cols - lw - rw) + gap.join(s.ansi for s in right)
    return out


# ---------- git ----------
def git(cwd):
    cache = STATE / f"git-{hashlib.md5(cwd.encode()).hexdigest()[:12]}.json"
    try:
        d = json.loads(cache.read_text())
        if time.time() - d["ts"] < 5:
            return d["v"]
    except Exception:
        pass

    def run(*a, t=2.0):
        try:
            return subprocess.run(
                ("git", "--no-optional-locks", "-C", cwd) + a,
                capture_output=True,
                text=True,
                timeout=t,
            ).stdout.strip()
        except Exception:
            return ""

    branch = run("rev-parse", "--abbrev-ref", "HEAD", t=1.0)
    v = None
    if branch:
        v = dict(
            branch=branch, staged=0, dirty=0, untracked=0, conflict=0, ahead=0, behind=0
        )
        for ln in run("status", "--porcelain=v2", "--branch").splitlines():
            if ln.startswith("# branch.ab"):
                for tok in ln.split()[2:]:
                    v["ahead" if tok[0] == "+" else "behind"] = int(tok[1:])
            elif ln[:1] in ("1", "2"):
                xy = ln.split()[1]
                v["staged"] += xy[0] != "."
                v["dirty"] += xy[1] != "."
            elif ln.startswith("?"):
                v["untracked"] += 1
            elif ln.startswith("u"):
                v["conflict"] += 1
        head = run("symbolic-ref", "--short", "refs/remotes/origin/HEAD", t=1.0)
        v["default"] = head.split("/", 1)[-1] if head else "main"
    try:
        STATE.mkdir(parents=True, exist_ok=True)
        cache.write_text(json.dumps(dict(ts=time.time(), v=v)))
    except Exception:
        pass
    return v


def branch_url(repo, g):
    if not (repo and g and repo.get("host") and repo.get("owner") and repo.get("name")):
        return None
    root = f"https://{repo['host']}/{repo['owner']}/{repo['name']}"
    b, dflt = g["branch"], g.get("default", "main")
    if b in ("HEAD", dflt):
        return f"{root}/tree/{b}"
    return (
        f"{root}/-/compare/{dflt}...{b}"
        if "gitlab" in repo["host"]
        else f"{root}/compare/{dflt}...{b}"
    )


# ---------- spend: priced from the transcripts, cached incrementally ----------
def rates(model):
    if model in PRICE:
        inp, out = PRICE[model]
    elif "opus" in model:
        inp, out = 5.0, 25.0
    elif "fable" in model or "mythos" in model:
        inp, out = 10.0, 50.0
    elif "sonnet" in model:
        inp, out = 3.0, 15.0
    elif "haiku" in model:
        inp, out = 1.0, 5.0
    else:
        inp, out = 5.0, 25.0
    return inp, out, FLAT_READ.get(model, inp * 0.1)


def line_cost(d):
    """usd for one assistant transcript entry, or None if it is not a billable response."""
    m = d.get("message") or {}
    u = m.get("usage")
    model = m.get("model")
    if d.get("type") != "assistant" or not u or not model or model.startswith("<"):
        return None
    inp, out, read = rates(model)
    cc = u.get("cache_creation") or {}
    w5 = cc.get("ephemeral_5m_input_tokens")
    w1 = cc.get("ephemeral_1h_input_tokens") or 0
    if w5 is None and not w1:
        w5 = u.get("cache_creation_input_tokens") or 0
    return (
        u.get("input_tokens", 0) * inp
        + (w5 or 0) * inp * 1.25
        + w1 * inp * 2.0
        + u.get("cache_read_input_tokens", 0) * read
        + u.get("output_tokens", 0) * out
    ) / 1e6


def scan_file(path, prev):
    """parse only the appended tail when we can; dupe entries repeat requestId contiguously."""
    st = path.stat()
    if prev and prev["s"] == st.st_size and prev["m"] == int(st.st_mtime):
        return prev, False
    base = prev if (prev and st.st_size >= prev["s"]) else None
    days = dict(base["d"]) if base else {}
    off, last = (base["off"], base.get("last")) if base else (0, None)
    with path.open("rb") as fh:
        fh.seek(off)
        blob = fh.read()
    parts = blob.split(b"\n")
    tail = parts.pop()  # incomplete final line, if any
    for raw in parts:
        off += len(raw) + 1
        if b'"usage"' not in raw:
            continue
        try:
            d = json.loads(raw)
        except Exception:
            continue
        rid = d.get("requestId")
        if rid and rid == last:
            continue
        c = line_cost(d)
        if c is None:
            continue
        last = rid
        day = (d.get("timestamp") or "")[:10]
        days[day] = days.get(day, 0.0) + c
    return dict(s=st.st_size, m=int(st.st_mtime), off=off, d=days, last=last), True


def period_spend():
    cf = STATE / "usage.json"
    try:
        cache = json.loads(cf.read_text())
    except Exception:
        cache = {}
    fresh, dirty = {}, False
    for p in PROJECTS.glob("*/*.jsonl"):
        k = str(p)
        try:
            e, ch = scan_file(p, cache.get(k))
        except OSError:
            continue
        fresh[k] = e
        dirty = dirty or ch
    if dirty or len(fresh) != len(cache):
        try:
            STATE.mkdir(parents=True, exist_ok=True)
            tmp = cf.with_suffix(".tmp")
            tmp.write_text(json.dumps(fresh))
            tmp.replace(cf)
        except Exception:
            pass
    mo = f"{date.today():%Y-%m}"
    return sum(v for e in fresh.values() for k, v in e["d"].items() if k.startswith(mo))


def money(v):
    return f"${v:,.2f}" if v < 100 else f"${v:,.0f}"


def cost_color(v):
    return (
        C["green"]
        if v < 1
        else C["yellow"]
        if v < 5
        else C["peach"]
        if v < 20
        else C["red"]
    )


# ---------- pets ----------
def feed_active():
    """True if a feeding animation should show: auto every FEED_AUTO_SECS, or /feed ran recently."""
    STATE.mkdir(parents=True, exist_ok=True)
    auto_f = STATE / "last-auto-feed"
    manual_f = STATE / "feed-request"
    now = time.time()
    try:
        last = auto_f.stat().st_mtime
    except FileNotFoundError:
        last = 0.0
    if now - last >= FEED_AUTO_SECS:
        auto_f.touch()
        last = now
    manual_active = False
    try:
        manual_active = now - manual_f.stat().st_mtime < FEED_WINDOW_SECS
    except FileNotFoundError:
        pass
    return (now - last < FEED_WINDOW_SECS) or manual_active


def _is_emoji(ch):
    return ord(ch[0]) < 0xF0000  # nerd-font icons live in the f0000-fffff PUA range


def _gap(ch):
    n = (
        2 if _is_emoji(ch) else 1
    )  # emoji get a little more breathing room, they render wider
    return [(" ", C["s0"])] * n


def _item_col(item):
    return ITEM_COLOR_OVERRIDE.get(
        item, C["teal"]
    )  # turquoise default, same family as the month-spend figure


def _pet_group(rnd, a, b, fed):
    grp = []
    if fed:
        item = rnd.choice(FOOD)
        grp += [(item, _item_col(item))] + _gap(item)
    elif rnd.random() < 0.55:
        item = rnd.choice(TOYS)
        grp += [(item, _item_col(item))] + _gap(item)
    grp += (
        [(a, PET_COLOR_OVERRIDE.get(a, C["peach"]))]
        + [(" ", C["s0"])] * rnd.randint(1, 2)
        + [(b, PET_COLOR_OVERRIDE.get(b, C["pink"]))]
    )
    if fed:
        item = rnd.choice(FOOD)
        grp += _gap(item) + [(item, _item_col(item))]
    elif rnd.random() < 0.45:
        item = rnd.choice(TOYS)
        grp += _gap(item) + [(item, _item_col(item))]
    return grp


def habitat(W):
    now = datetime.now()
    # true entropy each render (was: seeded by 10s tick, which repeated picks
    # when the statusline redraws more than once per tick, e.g. on every prompt)
    rnd = random.Random()
    # pet pairs used to be pinned to a 2h-of-day block, which read as "stuck on
    # the same animal" for hours at a time; pick freely every render instead
    a, b = rnd.choice(PETS)
    a2, b2 = rnd.choice(PETS)
    if EXTRA_PETS and rnd.random() < 0.3:
        b = rnd.choice(EXTRA_PETS)
    if EXTRA_PETS and rnd.random() < 0.3:
        b2 = rnd.choice(EXTRA_PETS)
    cells = [(" ", C["s0"])] * W
    cells[0] = (G.get("sun", "\U000f0599"), C["yellow"])
    for i, ch in enumerate(FOLIAGE_L):
        cells[min(W - 1, 2 + i * 2)] = (ch, C["green"])
    for i, ch in enumerate(FOLIAGE_R):
        cells[max(0, W - 2 - i * 2)] = (ch, C["green"])
    fed = feed_active()
    grp1 = _pet_group(rnd, a, b, fed)
    grp2 = _pet_group(rnd, a2, b2, fed)

    def place(grp, lo, hi, secs):
        span = max(1, hi - lo - len(grp))
        pos = (time.time() % secs) / secs  # sweeps back and forth
        frac = pos if pos < 0.5 else 1 - pos
        start = lo + int(frac * 2 * span)
        for i, cell in enumerate(grp):
            if start + i < hi:
                cells[start + i] = cell

    mid = W // 2
    place(grp1, 5, mid - 1, 20)
    place(grp2, mid + 1, W - 4, 26)  # different period so the two groups don't sync up
    r, g, b_ = _rgb(C["s0"])
    body = (
        f"\x1b[48;2;{r};{g};{b_}m"
        + "".join(
            f"\x1b[38;2;%d;%d;%dm%s" % (*_rgb(col), ch) if ch != " " else " "
            for ch, col in cells
        )
        + RST
    )
    return S(body, "".join(ch for ch, _ in cells), 7)


def main():
    try:
        d = json.load(sys.stdin)
    except Exception:
        d = {}
    cols = max(
        40, int(os.environ.get("COLUMNS") or 100) - 5
    )  # -1 extra vs before: habitat row was clipping with "..."
    ws = d.get("workspace") or {}
    cwd = ws.get("current_dir") or d.get("cwd") or os.getcwd()
    cw = d.get("context_window") or {}
    pct = cw.get("used_percentage")
    pct = 0.0 if pct is None else float(pct)
    cost = (d.get("cost") or {}).get("total_cost_usd") or 0.0

    # ---- line 1 left: model, dir, branch, pr ----
    lt = []
    name = ((d.get("model") or {}).get("display_name") or "claude").lower()
    big = "1m" in name
    a, p = (
        G["model"] + " " + name.split("(")[0].strip(),
        G["model"] + " " + name.split("(")[0].strip(),
    )
    a = fg(C["mauve"], a, bold=True)
    if big:
        a += fg(C["ov"], " 1m")
        p += " 1m"
    eff = ((d.get("effort") or {}).get("level") or "").lower()
    if eff:
        a += fg(C["lav"], " " + eff)
        p += " " + eff
    if d.get("fast_mode"):
        a += fg(C["yellow"], " " + G["bolt"])
        p += " " + G["bolt"]
    lt.append(S(a, p, 3))

    repo = ws.get("repo")
    repo_url = (
        f"https://{repo['host']}/{repo['owner']}/{repo['name']}" if repo else None
    )
    dn = (Path(cwd).name or "/").lower()
    lt.append(
        S(
            link(repo_url, fg(C["blue"], G["dir"] + " " + dn, bold=True)),
            G["dir"] + " " + dn,
            4,
        )
    )

    g = git(cwd)
    if g:
        br = g["branch"].lower()
        if len(br) > 28:
            br = br[:27] + "…"
        clean = not (g["dirty"] or g["staged"] or g["conflict"] or g["untracked"])
        bc = C["green"] if clean else C["red"] if g["conflict"] else C["yellow"]
        a, p = fg(bc, G["branch"] + " " + br), G["branch"] + " " + br
        for n, ic, col in (
            (g["conflict"], G["warn"], C["red"]),
            (g["staged"], G["plus"], C["green"]),
            (g["dirty"], G["pencil"], C["yellow"]),
            (g["ahead"], G["up"], C["teal"]),
            (g["behind"], G["down"], C["lav"]),
        ):
            if n:
                a += fg(col, f" {ic} {n}")
                p += f" {ic} {n}"
        lt.append(S(link(branch_url(repo, g), a), p, 1))
        wt = (d.get("worktree") or {}).get("name") or ws.get("git_worktree")
        if wt:
            lt.append(S(fg(C["lav"], "↳ " + wt.lower()), "↳ " + wt.lower(), 6))

    pr = d.get("pr")
    if pr:
        col = {
            "approved": C["green"],
            "changes_requested": C["red"],
            "draft": C["ov"],
        }.get(pr.get("review_state"), C["sky"])
        lt.append(
            S(
                link(pr.get("url"), fg(col, f"{G['pr']} #{pr['number']}", bold=True)),
                f"{G['pr']} #{pr['number']}",
                5,
            )
        )

    # ---- line 1 right: ctx | session $ | period total ----
    n = 6
    filled = int(round(pct / 100 * n))
    bar = "".join(
        fg(grad(i / (n - 1)), "▓") if i < filled else fg(C["s1"], "░") for i in range(n)
    )
    rt = [
        S(
            fg(C["ov"], G["ctx"] + " ctx ")
            + bar
            + fg(grad(pct / 100), f" {pct:.0f}%", bold=True),
            f"{G['ctx']} ctx {'▓' * n} {pct:.0f}%",
            1,
        ),
        sep(),
        S(
            fg(C["ov"], "session ") + fg(cost_color(cost), money(cost), bold=True),
            f"session {money(cost)}",
            1,
        ),
        sep(),
    ]
    cap = f"${BUDGET:,.0f}"
    sl = ((d.get("rate_limits") or {}).get("spend_limit") or {}).get("used_percentage")
    if sl is None:
        used, pctlbl = period_spend(), ""
    else:
        used, pctlbl = BUDGET * float(sl) / 100, f" ({float(sl):.0f}%)"
    frac = used / BUDGET if BUDGET else 0
    umoney = f"${used:,.0f}"
    rt.append(
        S(
            fg(C["ov"], G["vault"] + " mo ")
            + fg(grad(frac), umoney, bold=True)
            + fg(C["ov"], "/" + cap + pctlbl),
            f"{G['vault']} mo {umoney}/{cap}{pctlbl}",
            2,
        )
    )

    # ---- line 2 left: vim, rate limits ----
    lb = []
    vm = ((d.get("vim") or {}).get("mode") or "").lower()
    if vm:
        col = {"normal": C["blue"], "insert": C["green"]}.get(vm, C["peach"])
        lb.append(S(fg(col, f"{G['vim']} {vm}", bold=True), f"{G['vim']} {vm}", 1))
    rl = d.get("rate_limits") or {}
    rb = [
        (lbl, float((rl.get(k) or {}).get("used_percentage")))
        for k, lbl in (("five_hour", "5h"), ("seven_day", "7d"))
        if (rl.get(k) or {}).get("used_percentage") is not None
    ]
    if rb:
        a, p = "", ""
        for i, (lbl, v) in enumerate(rb):
            a += (
                ("" if i == 0 else fg(C["s2"], " · "))
                + fg(C["ov"], lbl + " ")
                + fg(grad(v / 100), f"{v:.0f}%")
            )
            p += ("" if i == 0 else " · ") + f"{lbl} {v:.0f}%"
        lb.append(S(a, p, 4))

    print(row(lt, rt, cols))
    print(row(lb, [], cols))
    print(habitat(cols).ansi)


if __name__ == "__main__":
    main()
