# Roblox Luau Workspace

Optimiert für Roblox Studio, Rojo, Luau, VS Code und GitHub Copilot.

## Features

- Luau/Lua Unterstützung mit LSP und Syntax-Highlighting
- Rojo-Projektstruktur für Synchronisation mit Roblox Studio
- Formatierung und Tabgröße wie in settings.json
- Empfohlene Extensions: Roblox LSP, Luau, Luau Language Server, Roblox Lua/Luau Highlighting

## Schnellstart

1. Stelle sicher, dass Rojo installiert ist ([Rojo Releases](https://github.com/rojo-rbx/rojo/releases)).
2. Starte Rojo im Workspace-Ordner:
   ```sh
   rojo serve
   ```
3. Öffne Roblox Studio und verbinde dich mit Rojo (Rojo Plugin erforderlich).
4. Bearbeite Code in VS Code, Änderungen werden synchronisiert.

## Hinweise

- Die Datei `rojo.json` steuert die Zuordnung der Quellordner zu Roblox-Services.
- Passe die Struktur bei Bedarf an dein Spiel an.
- Für Copilot: Deine bisherigen Einstellungen bleiben erhalten, die Umgebung ist für Roblox optimiert.

---

Empfohlene Extensions für VS Code:

```vscode-extensions
nightrains.robloxlsp,undermywheel.roblox-lua,johnnymorganz.luau-lsp,dekkonot.vscode-luau
```

## Project Structure

```
roblox-luau-workspace
├── src
│   ├── main.server.lua        # Main entry point for server-side scripts
│   ├── main.client.lua        # Main entry point for client-side scripts
│   └── modules
│       └── example.module.lua  # Example module for shared functionality
├── .vscode
│   ├── settings.json          # Workspace-specific settings for the editor
│   ├── extensions.json        # Recommended extensions for the workspace
│   └── launch.json            # Debugging configuration for the workspace
├── README.md                  # Documentation for the project
└── .gitignore                 # Files and directories to be ignored by Git
```

## Setup Instructions

1. Clone the repository to your local machine.
2. Open the project in your preferred code editor.
3. Install the recommended extensions listed in `.vscode/extensions.json`.
4. Configure your editor settings as needed in `.vscode/settings.json`.

## Usage Guidelines

- Use `main.server.lua` for server-side logic and event handling.
- Use `main.client.lua` for client-side logic and user interface interactions.
- The `example.module.lua` can be required in both server and client scripts to share functionality.

## Nützliche Ressourcen & Tools

### Offizielle Dokumentation
- Roblox Developer Hub: https://create.roblox.com/docs/
- Luau Language Reference: https://luau-lang.org/
- Rojo Projekt-Schema: https://github.com/rojo-rbx/rojo

### Community & Tutorials
- Roblox Developer Forum: https://devforum.roblox.com/
- Anleitungen und Beispiele: https://github.com/CloneTrooper1019/Roblox-Client-Tracker-Documentation
- YouTube-Kanäle (z. B. AlvinBlox, TheDevKing)

### Frameworks & Bibliotheken
- Roact (UI-Komponenten): https://github.com/Roblox/roact
- Rodux (State-Management): https://github.com/Roblox/rodux
- Knit (Service-Architektur): https://github.com/Anaminus/knit
- Janitor (Ressourcen-Management): https://github.com/Obviat/Janitor

### Testing & Debugging
- TestEZ (Unit-Tests): https://github.com/Roblox/testez
- Luau-Profiler: https://create.roblox.com/docs/reference/luau/profiler
- Roblox-CLI Debugger: https://github.com/rojo-rbx/rojo#debugging

### Toolchain & Automatisierung
- Rojo CLI: Automatisierte Synchronisation mit Studio
- Roblox-TS: Typsicheres TypeScript → Luau (optional)
- Git LFS für große Asset-Dateien
- GitHub Actions: Automatisierte Deployments via roblox-cli

### Code-Generierung mit Copilot
- Prompts vorbereiten: Beschreibe Funktion, Datenstrukturen und gewünschtes Ergebnis
- Inline-Snippets: Ausnutzung der Inline-Suggestions für Boilerplate
- Test-getriebene Entwicklung: Schreibe zuerst Testfälle mit TestEZ, dann generiere Implementierung

*Diese Liste ist nicht abschließend – regelmäßiges Stöbern in der Community und offizielle Changelogs hält dich auf dem neuesten Stand.*

## Contributing

Feel free to submit issues or pull requests to improve the project.
