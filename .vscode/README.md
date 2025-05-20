# VS Code Einstellungen für Roblox Luau Entwicklung

Diese Datei erklärt die optimierten VS Code-Einstellungen für die Roblox-Spieleentwicklung mit Luau, Rojo und GitHub Copilot.

## Installierte Erweiterungen

Die folgenden Erweiterungen sind für dieses Projekt konfiguriert:

1. **Luau Language Server** (`johnnymorganz.luau-lsp`)
   - Vollständiger Luau-Sprachserver mit Type-Checking
   - IntelliSense und Autovervollständigung für Roblox API
   - Diagnostik und Fehlerprüfung

2. **Rojo VS Code** (`evaera.vscode-rojo`)
   - Integration mit Rojo für Synchronisation mit Roblox Studio
   - Projekt-Explorer für Rojo-Projekte
   - Verbindungssteuerung direkt aus VS Code

3. **Luau Syntax Highlighting** (`dekkonot.vscode-luau`)
   - Optimierte Syntaxhervorhebung für Luau
   - Unterstützung für Luau-spezifische Syntax

4. **Roblox LSP** (`nightrains.robloxlsp`)
   - Alternative Luau-Sprachunterstützung
   - Zusätzliche Diagnose-Tools

5. **GitHub Copilot** (`github.copilot`)
   - KI-gestützte Code-Vervollständigung
   - Optimiert für Luau und Roblox-Entwicklung

6. **GitHub Copilot Chat** (`github.copilot-chat`)
   - Kontextbezogene Unterstützung für Roblox-Entwicklung
   - Code-Erklärungen und Hilfe bei der Fehlerbehebung

## Code-Snippets

In `.vscode/luau.code-snippets` sind vorgefertigte Vorlagen für gängige Luau-Strukturen definiert:

- `module`: Grundgerüst für ein neues Modul
- `service`: Template für einen Knit-Service
- `component`: Template für eine Roact-Komponente
- `testez`: TestEZ-Testvorlage
- `type`: Luau-Typdefinition
- `connect`: Event-Verbindungsmuster
- `remoteevent`: Remote-Event-Setup

## Formatierung & Linting

Die Einstellungen sind auf diese Formatierungsregeln optimiert:

- 4 Leerzeichen pro Einrückung (kein Tab)
- Zeilenlänge maximal 100 Zeichen
- Doppelte Anführungszeichen für Strings
- Keine Semikolons
- Automatische Formatierung beim Speichern

Verwende `.luaurc` für benutzerdefinierte Linting-Regeln.

## Typensicherheit

Das Projekt ist für strikte Typprüfung mit `--!strict` konfiguriert. Vorteile:

- Frühzeitige Fehlererkennung
- Bessere Autovervollständigung
- Erhöhte Code-Robustheit
- Verbesserte Dokumentation durch Typen

## Rojo-Konfiguration

Die `rojo.json`-Datei definiert, wie deine lokalen Dateien auf die Roblox-Datahierarchie abgebildet werden:

- `/src/modules/` → `ReplicatedStorage.modules`
- `/src/main.server.lua` → `ServerScriptService.main.server`
- `/src/main.client.lua` → `StarterPlayer.StarterPlayerScripts.main.client`

## GitHub Copilot-Optimierung

Copilot ist für Roblox-Entwicklung optimiert mit:

- Niedrige Temperatur (0.4) für fokussierte Code-Vorschläge
- 5 Inline-Vorschläge gleichzeitig
- Verzögerung auf 0 gestellt für schnellere Vorschläge
- Aktiviert nur für Lua/Luau-Dateien

## Performance-Verbesserungen

- Semantische Hervorhebung deaktiviert (spart CPU)
- Ausgeschlossene Ordner vom Watching (`build`, `.roblox`)
- Optimierte Quick Suggestions für schnellere Autovervollständigung

## Debugging

Die Launch-Konfigurationen ermöglichen Debugging von:

- Server-Scripts
- Client-Scripts
- Erweiterungsentwicklung

## Projektstruktur

- `/src/`: Quellcode
  - `/modules/`: Gemeinsam genutzte Module
  - `main.server.lua`: Server-Einstiegspunkt
  - `main.client.lua`: Client-Einstiegspunkt
- `/tests/`: TestEZ-Tests
- `/.vscode/`: VS Code-Konfiguration
- `/.github/`: CI/CD-Workflows

## Nützliche Tastenkombinationen

- **F5**: Debugging starten
- **Strg+Shift+B**: Task ausführen (z.B. Rojo starten)
- **Strg+Space**: Code-Vervollständigung
- **Alt+Shift+F**: Datei formatieren
- **F8**: Zum nächsten Problem springen

## Hilfreiche Befehle für das Terminal

```zsh
# Rojo starten
rojo serve

# Typenprüfung für das gesamte Projekt durchführen
luau-lsp analyze --sourcemap=sourcemap.json ./src

# TestEZ-Tests ausführen
run-in-roblox --place game.rbxlx --script tests/TestRunner.server.lua
```

## Support

Bei Problemen mit der Konfiguration:

1. Überprüfe, ob alle Erweiterungen installiert sind
2. Stelle sicher, dass Rojo korrekt installiert ist
3. Bestätige, dass die Pfade in `rojo.json` korrekt sind
4. Überprüfe die Formatierungseinstellungen in `.luaurc`
