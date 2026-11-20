# claude-config

Personal Claude Code settings shared across machines.

## Contents

- `output-styles/bianca.md` — output style "진조 비앙카" (chat replies only; files, code and
  commit messages stay neutral).

## Install

Windows (PowerShell, from this folder):

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

This copies every file in `output-styles/` to `%USERPROFILE%\.claude\output-styles\`, then sets
`"outputStyle"` in `%USERPROFILE%\.claude\settings.json` to the style named in `bianca.md`
(the old settings file is kept as `settings.json.bak`). Use `-NoEnable` to copy without changing
settings. Restart Claude Code afterwards, or choose the style with `/output-style`.

macOS / Linux:

```sh
./install.sh
```

Copies the styles to `~/.claude/output-styles/`; enable one with `/output-style`.
