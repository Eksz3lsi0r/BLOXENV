-- 🎨 100 BODEN-ANIMATIONS MUSTER - Ultimate Pattern Library! ⚡
-- Wähle aus 100+ verschiedenen Patterns für dein FloorSegment System!

local FloorPatterns = {}

FloorPatterns.PatternLibrary = {
    
    -- 🌟 NATUR & ELEMENTE (1-20)
    {
        id = 1,
        name = "Ocean Waves",
        description = "Sanfte Meereswellen über das gesamte Grid",
        category = "nature",
        colors = {Color3.fromRGB(0, 119, 190), Color3.fromRGB(0, 180, 216), Color3.fromRGB(144, 224, 239)},
        pattern = "wave",
        speed = "slow",
        duration = 8
    },
    {
        id = 2,
        name = "Forest Fire",
        description = "Sich ausbreitendes Feuer mit Funken",
        category = "nature",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 200, 0)},
        pattern = "spreading",
        speed = "medium",
        duration = 10
    },
    {
        id = 3,
        name = "Earthquake Cracks",
        description = "Risse die sich durch den Boden ziehen",
        category = "nature",
        colors = {Color3.fromRGB(139, 69, 19), Color3.fromRGB(101, 67, 33), Color3.fromRGB(160, 82, 45)},
        pattern = "linear",
        speed = "fast",
        duration = 6
    },
    {
        id = 4,
        name = "Aurora Borealis",
        description = "Nordlichter tanzen über den Boden",
        category = "nature",
        colors = {Color3.fromRGB(0, 255, 127), Color3.fromRGB(138, 43, 226), Color3.fromRGB(255, 20, 147)},
        pattern = "flowing",
        speed = "slow",
        duration = 15
    },
    {
        id = 5,
        name = "Snowfall",
        description = "Sanft fallender Schnee mit Schneeflocken",
        category = "nature",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(240, 248, 255), Color3.fromRGB(230, 230, 250)},
        pattern = "falling",
        speed = "slow",
        duration = 12
    },
    {
        id = 6,
        name = "Lightning Storm",
        description = "Zufällige Blitzschläge überall",
        category = "nature",
        colors = {Color3.fromRGB(255, 255, 100), Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 255)},
        pattern = "random",
        speed = "ultra_fast",
        duration = 5
    },
    {
        id = 7,
        name = "Cherry Blossom Rain",
        description = "Rosa Kirschblüten fallen vom Himmel",
        category = "nature",
        colors = {Color3.fromRGB(255, 182, 193), Color3.fromRGB(255, 105, 180), Color3.fromRGB(255, 20, 147)},
        pattern = "falling",
        speed = "slow",
        duration = 20
    },
    {
        id = 8,
        name = "Volcanic Eruption",
        description = "Lava sprudelt aus dem Boden",
        category = "nature",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 69, 0), Color3.fromRGB(220, 20, 60)},
        pattern = "eruption",
        speed = "medium",
        duration = 12
    },
    {
        id = 9,
        name = "Tornado Spiral",
        description = "Wirbelnder Tornado mit Debris",
        category = "nature",
        colors = {Color3.fromRGB(169, 169, 169), Color3.fromRGB(105, 105, 105), Color3.fromRGB(139, 69, 19)},
        pattern = "spiral",
        speed = "fast",
        duration = 8
    },
    {
        id = 10,
        name = "Desert Sandstorm",
        description = "Sandsturm fegt über das Feld",
        category = "nature",
        colors = {Color3.fromRGB(194, 178, 128), Color3.fromRGB(160, 82, 45), Color3.fromRGB(210, 180, 140)},
        pattern = "sweeping",
        speed = "medium",
        duration = 10
    },
    {
        id = 11,
        name = "Ice Crystals",
        description = "Eiskristalle wachsen und schmelzen",
        category = "nature",
        colors = {Color3.fromRGB(173, 216, 230), Color3.fromRGB(135, 206, 250), Color3.fromRGB(100, 149, 237)},
        pattern = "growing",
        speed = "medium",
        duration = 8
    },
    {
        id = 12,
        name = "Jungle Vines",
        description = "Dschungel-Ranken wachsen überall",
        category = "nature",
        colors = {Color3.fromRGB(34, 139, 34), Color3.fromRGB(50, 205, 50), Color3.fromRGB(0, 128, 0)},
        pattern = "organic",
        speed = "slow",
        duration = 15
    },
    {
        id = 13,
        name = "Solar Flare",
        description = "Sonnen-Eruptionen in gold und orange",
        category = "nature",
        colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 69, 0)},
        pattern = "radial",
        speed = "fast",
        duration = 6
    },
    {
        id = 14,
        name = "Meteor Shower",
        description = "Meteoriten schlagen ein",
        category = "nature",
        colors = {Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 255, 255)},
        pattern = "impacts",
        speed = "medium",
        duration = 12
    },
    {
        id = 15,
        name = "Coral Reef",
        description = "Bunte Korallen wachsen",
        category = "nature",
        colors = {Color3.fromRGB(255, 127, 80), Color3.fromRGB(255, 20, 147), Color3.fromRGB(0, 255, 255)},
        pattern = "growing",
        speed = "slow",
        duration = 18
    },
    {
        id = 16,
        name = "Autumn Leaves",
        description = "Herbstblätter fallen und wirbeln",
        category = "nature",
        colors = {Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 215, 0)},
        pattern = "swirling",
        speed = "medium",
        duration = 14
    },
    {
        id = 17,
        name = "Galaxy Spiral",
        description = "Spiralgalaxie mit Sternen",
        category = "nature",
        colors = {Color3.fromRGB(25, 25, 112), Color3.fromRGB(72, 61, 139), Color3.fromRGB(255, 255, 255)},
        pattern = "spiral",
        speed = "slow",
        duration = 20
    },
    {
        id = 18,
        name = "Quicksand",
        description = "Treibsand mit wirbelnden Bewegungen",
        category = "nature",
        colors = {Color3.fromRGB(210, 180, 140), Color3.fromRGB(160, 82, 45), Color3.fromRGB(139, 69, 19)},
        pattern = "swirling",
        speed = "medium",
        duration = 10
    },
    {
        id = 19,
        name = "Rainbow Rain",
        description = "Regenbogen-Tropfen fallen vom Himmel",
        category = "nature",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(75, 0, 130), Color3.fromRGB(148, 0, 211)},
        pattern = "falling",
        speed = "medium",
        duration = 16
    },
    {
        id = 20,
        name = "Crystal Cave",
        description = "Kristalle wachsen aus dem Boden",
        category = "nature",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(173, 216, 230), Color3.fromRGB(147, 112, 219)},
        pattern = "growing",
        speed = "slow",
        duration = 12
    },

    -- 🎆 MAGIC & FANTASY (21-40)
    {
        id = 21,
        name = "Magic Circle",
        description = "Magische Kreise erscheinen und verschwinden",
        category = "magic",
        colors = {Color3.fromRGB(138, 43, 226), Color3.fromRGB(75, 0, 130), Color3.fromRGB(255, 20, 147)},
        pattern = "circular",
        speed = "medium",
        duration = 10
    },
    {
        id = 22,
        name = "Spell Runes",
        description = "Magische Runen leuchten auf",
        category = "magic",
        colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 255)},
        pattern = "symbols",
        speed = "slow",
        duration = 15
    },
    {
        id = 23,
        name = "Portal Network",
        description = "Portale öffnen sich überall",
        category = "magic",
        colors = {Color3.fromRGB(138, 43, 226), Color3.fromRGB(186, 85, 211), Color3.fromRGB(255, 0, 255)},
        pattern = "portals",
        speed = "medium",
        duration = 12
    },
    {
        id = 24,
        name = "Fairy Dust",
        description = "Glitzernder Feenstaub schwebt",
        category = "magic",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 20, 147), Color3.fromRGB(0, 255, 255)},
        pattern = "floating",
        speed = "slow",
        duration = 18
    },
    {
        id = 25,
        name = "Dragon Fire",
        description = "Drachenfeuer brennt über den Boden",
        category = "magic",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 140, 0)},
        pattern = "breathing",
        speed = "fast",
        duration = 8
    },
    {
        id = 26,
        name = "Teleportation Grid",
        description = "Teleportations-Gitter aktiviert sich",
        category = "magic",
        colors = {Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(138, 43, 226)},
        pattern = "grid",
        speed = "fast",
        duration = 6
    },
    {
        id = 27,
        name = "Mana Overflow",
        description = "Mana fließt wie Wasser",
        category = "magic",
        colors = {Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 255)},
        pattern = "flowing",
        speed = "medium",
        duration = 14
    },
    {
        id = 28,
        name = "Enchanted Forest",
        description = "Verzauberte Pflanzen wachsen",
        category = "magic",
        colors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 20, 147), Color3.fromRGB(255, 215, 0)},
        pattern = "organic",
        speed = "slow",
        duration = 20
    },
    {
        id = 29,
        name = "Time Distortion",
        description = "Zeit verzerrt sich in Wellen",
        category = "magic",
        colors = {Color3.fromRGB(75, 0, 130), Color3.fromRGB(138, 43, 226), Color3.fromRGB(255, 255, 255)},
        pattern = "distortion",
        speed = "medium",
        duration = 10
    },
    {
        id = 30,
        name = "Phoenix Rebirth",
        description = "Phoenix erhebt sich aus der Asche",
        category = "magic",
        colors = {Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 215, 0)},
        pattern = "rising",
        speed = "medium",
        duration = 12
    },
    {
        id = 31,
        name = "Starfall Magic",
        description = "Magische Sterne fallen vom Himmel",
        category = "magic",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 215, 0), Color3.fromRGB(0, 255, 255)},
        pattern = "falling",
        speed = "medium",
        duration = 16
    },
    {
        id = 32,
        name = "Alchemy Transmutation",
        description = "Alchemie-Kreise transmutieren",
        category = "magic",
        colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 0, 0), Color3.fromRGB(138, 43, 226)},
        pattern = "circular",
        speed = "fast",
        duration = 8
    },
    {
        id = 33,
        name = "Shadow Realm",
        description = "Schatten kriechen über den Boden",
        category = "magic",
        colors = {Color3.fromRGB(25, 25, 25), Color3.fromRGB(75, 0, 130), Color3.fromRGB(139, 0, 139)},
        pattern = "creeping",
        speed = "slow",
        duration = 15
    },
    {
        id = 34,
        name = "Healing Aura",
        description = "Heilende grüne Aura pulsiert",
        category = "magic",
        colors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(144, 238, 144), Color3.fromRGB(255, 255, 255)},
        pattern = "pulsing",
        speed = "slow",
        duration = 18
    },
    {
        id = 35,
        name = "Elemental Fusion",
        description = "Alle Elemente verschmelzen",
        category = "magic",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0)},
        pattern = "fusion",
        speed = "medium",
        duration = 14
    },
    {
        id = 36,
        name = "Mystic Constellation",
        description = "Sternbilder formen sich",
        category = "magic",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(138, 43, 226)},
        pattern = "constellation",
        speed = "slow",
        duration = 20
    },
    {
        id = 37,
        name = "Spirit Wisps",
        description = "Geister-Irrlichter tanzen",
        category = "magic",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 20, 147)},
        pattern = "dancing",
        speed = "medium",
        duration = 12
    },
    {
        id = 38,
        name = "Demon Summoning",
        description = "Dämonische Beschwörungskreise",
        category = "magic",
        colors = {Color3.fromRGB(128, 0, 0), Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 69, 0)},
        pattern = "summoning",
        speed = "fast",
        duration = 10
    },
    {
        id = 39,
        name = "Astral Projection",
        description = "Astrale Energien fließen",
        category = "magic",
        colors = {Color3.fromRGB(138, 43, 226), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 255)},
        pattern = "flowing",
        speed = "slow",
        duration = 16
    },
    {
        id = 40,
        name = "Arcane Explosion",
        description = "Arkane Energie explodiert",
        category = "magic",
        colors = {Color3.fromRGB(138, 43, 226), Color3.fromRGB(255, 20, 147), Color3.fromRGB(255, 255, 255)},
        pattern = "explosion",
        speed = "fast",
        duration = 6
    },

    -- 🎵 MUSIK & RHYTHMUS (41-60)
    {
        id = 41,
        name = "Bass Drop",
        description = "Bass-Frequenzen pulsieren vom Zentrum",
        category = "music",
        colors = {Color3.fromRGB(255, 0, 100), Color3.fromRGB(200, 0, 150), Color3.fromRGB(150, 0, 200)},
        pattern = "bass",
        speed = "sync_bpm",
        duration = 16
    },
    {
        id = 42,
        name = "Equalizer Bars",
        description = "Audio-Equalizer Balken",
        category = "music",
        colors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 0)},
        pattern = "bars",
        speed = "sync_bpm",
        duration = 20
    },
    {
        id = 43,
        name = "Sound Waves",
        description = "Schallwellen breiten sich aus",
        category = "music",
        colors = {Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 150, 255), Color3.fromRGB(0, 100, 255)},
        pattern = "wave",
        speed = "sync_bpm",
        duration = 12
    },
    {
        id = 44,
        name = "Disco Floor",
        description = "Klassischer Disco-Boden",
        category = "music",
        colors = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "disco",
        speed = "sync_bpm",
        duration = 30
    },
    {
        id = 45,
        name = "Strobe Lights",
        description = "Stroboskop-Effekt",
        category = "music",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)},
        pattern = "strobe",
        speed = "ultra_fast",
        duration = 10
    },
    {
        id = 46,
        name = "Spectrum Analyzer",
        description = "Frequenz-Spektrum Anzeige",
        category = "music",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255)},
        pattern = "spectrum",
        speed = "sync_bpm",
        duration = 25
    },
    {
        id = 47,
        name = "Beat Pulse",
        description = "Pulsiert mit jedem Beat",
        category = "music",
        colors = {Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 150, 150), Color3.fromRGB(255, 200, 200)},
        pattern = "pulse",
        speed = "sync_bpm",
        duration = 20
    },
    {
        id = 48,
        name = "Rhythm Grid",
        description = "Rhythmisches Gitter-Muster",
        category = "music",
        colors = {Color3.fromRGB(100, 255, 100), Color3.fromRGB(150, 255, 150), Color3.fromRGB(200, 255, 200)},
        pattern = "grid",
        speed = "sync_bpm",
        duration = 18
    },
    {
        id = 49,
        name = "Waveform",
        description = "Audio-Wellenform Darstellung",
        category = "music",
        colors = {Color3.fromRGB(0, 255, 128), Color3.fromRGB(0, 200, 100), Color3.fromRGB(0, 150, 75)},
        pattern = "waveform",
        speed = "sync_bpm",
        duration = 15
    },
    {
        id = 50,
        name = "DJ Turntable",
        description = "Plattenteller-Rotation",
        category = "music",
        colors = {Color3.fromRGB(50, 50, 50), Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255)},
        pattern = "rotating",
        speed = "sync_bpm",
        duration = 22
    },
    {
        id = 51,
        name = "Laser Show",
        description = "Konzert-Laser Strahlen",
        category = "music",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255)},
        pattern = "laser",
        speed = "fast",
        duration = 12
    },
    {
        id = 52,
        name = "Concert Stage",
        description = "Bühnen-Beleuchtung",
        category = "music",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 20, 147)},
        pattern = "stage",
        speed = "sync_bpm",
        duration = 28
    },
    {
        id = 53,
        name = "Electronic Synth",
        description = "Synthesizer-Visualisierung",
        category = "music",
        colors = {Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "synth",
        speed = "sync_bpm",
        duration = 16
    },
    {
        id = 54,
        name = "Drum Machine",
        description = "Drum-Pattern Visualisierung",
        category = "music",
        colors = {Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 150, 50), Color3.fromRGB(255, 200, 100)},
        pattern = "drums",
        speed = "sync_bpm",
        duration = 20
    },
    {
        id = 55,
        name = "Club Atmosphere",
        description = "Nachtclub-Atmosphäre",
        category = "music",
        colors = {Color3.fromRGB(138, 43, 226), Color3.fromRGB(255, 20, 147), Color3.fromRGB(0, 255, 255)},
        pattern = "club",
        speed = "sync_bpm",
        duration = 35
    },
    {
        id = 56,
        name = "Piano Keys",
        description = "Klaviertasten leuchten auf",
        category = "music",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 215, 0)},
        pattern = "keys",
        speed = "sync_bpm",
        duration = 18
    },
    {
        id = 57,
        name = "Guitar Strings",
        description = "Gitarren-Saiten schwingen",
        category = "music",
        colors = {Color3.fromRGB(160, 82, 45), Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 140, 0)},
        pattern = "strings",
        speed = "sync_bpm",
        duration = 14
    },
    {
        id = 58,
        name = "Orchestra Waves",
        description = "Orchester-Wellenformen",
        category = "music",
        colors = {Color3.fromRGB(128, 0, 128), Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255)},
        pattern = "orchestra",
        speed = "sync_bpm",
        duration = 25
    },
    {
        id = 59,
        name = "Rave Madness",
        description = "Verrückte Rave-Lichter",
        category = "music",
        colors = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 0)},
        pattern = "rave",
        speed = "ultra_fast",
        duration = 15
    },
    {
        id = 60,
        name = "Audio Reactive",
        description = "Reagiert auf alle Audio-Frequenzen",
        category = "music",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(75, 0, 130), Color3.fromRGB(148, 0, 211)},
        pattern = "reactive",
        speed = "sync_bpm",
        duration = 30
    },

    -- 🎮 GAMING & DIGITAL (61-80)
    {
        id = 61,
        name = "Pixel Art",
        description = "8-Bit Pixel-Kunst",
        category = "gaming",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "pixel",
        speed = "medium",
        duration = 12
    },
    {
        id = 62,
        name = "Matrix Code",
        description = "Matrix-ähnlicher Code-Regen",
        category = "gaming",
        colors = {Color3.fromRGB(0, 255, 65), Color3.fromRGB(0, 200, 50), Color3.fromRGB(0, 150, 35)},
        pattern = "matrix",
        speed = "medium",
        duration = 20
    },
    {
        id = 63,
        name = "Glitch Effect",
        description = "Digital Glitch Störungen",
        category = "gaming",
        colors = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "glitch",
        speed = "fast",
        duration = 8
    },
    {
        id = 64,
        name = "Neon Grid",
        description = "Neon-Gitter wie in Tron",
        category = "gaming",
        colors = {Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 20, 147), Color3.fromRGB(255, 255, 255)},
        pattern = "grid",
        speed = "medium",
        duration = 15
    },
    {
        id = 65,
        name = "Binary Rain",
        description = "Binär-Code fällt herunter",
        category = "gaming",
        colors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 200, 0)},
        pattern = "falling",
        speed = "medium",
        duration = 18
    },
    {
        id = 66,
        name = "Hologram",
        description = "Holographische Projektion",
        category = "gaming",
        colors = {Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(138, 43, 226)},
        pattern = "hologram",
        speed = "slow",
        duration = 14
    },
    {
        id = 67,
        name = "Circuit Board",
        description = "Elektronische Schaltkreise",
        category = "gaming",
        colors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255)},
        pattern = "circuit",
        speed = "medium",
        duration = 16
    },
    {
        id = 68,
        name = "Loading Bar",
        description = "Lade-Balken Animation",
        category = "gaming",
        colors = {Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 0)},
        pattern = "loading",
        speed = "slow",
        duration = 10
    },
    {
        id = 69,
        name = "Power Up",
        description = "Power-Up Sammeln Effekt",
        category = "gaming",
        colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 140, 0)},
        pattern = "powerup",
        speed = "fast",
        duration = 6
    },
    {
        id = 70,
        name = "Game Over",
        description = "Game Over Bildschirm",
        category = "gaming",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(128, 0, 0), Color3.fromRGB(255, 255, 255)},
        pattern = "gameover",
        speed = "slow",
        duration = 8
    },
    {
        id = 71,
        name = "Level Complete",
        description = "Level-Abschluss Celebration",
        category = "gaming",
        colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 0)},
        pattern = "celebration",
        speed = "medium",
        duration = 12
    },
    {
        id = 72,
        name = "Health Bar",
        description = "Gesundheits-Balken Anzeige",
        category = "gaming",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0)},
        pattern = "healthbar",
        speed = "medium",
        duration = 10
    },
    {
        id = 73,
        name = "Mana Flow",
        description = "Mana-Energie fließt",
        category = "gaming",
        colors = {Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(138, 43, 226)},
        pattern = "flowing",
        speed = "medium",
        duration = 14
    },
    {
        id = 74,
        name = "Boss Battle",
        description = "Boss-Kampf Atmosphäre",
        category = "gaming",
        colors = {Color3.fromRGB(128, 0, 0), Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 69, 0)},
        pattern = "intense",
        speed = "fast",
        duration = 20
    },
    {
        id = 75,
        name = "Retro Arcade",
        description = "Retro Arcade-Spiel Stil",
        category = "gaming",
        colors = {Color3.fromRGB(255, 20, 147), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "retro",
        speed = "medium",
        duration = 16
    },
    {
        id = 76,
        name = "Speedrun Timer",
        description = "Speedrun Timer-Countdown",
        category = "gaming",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0)},
        pattern = "timer",
        speed = "fast",
        duration = 30
    },
    {
        id = 77,
        name = "Achievement Unlock",
        description = "Achievement freigeschaltet",
        category = "gaming",
        colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 140, 0)},
        pattern = "achievement",
        speed = "medium",
        duration = 8
    },
    {
        id = 78,
        name = "Combo Multiplier",
        description = "Combo-Multiplikator steigt",
        category = "gaming",
        colors = {Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 150, 0), Color3.fromRGB(255, 200, 0)},
        pattern = "combo",
        speed = "fast",
        duration = 10
    },
    {
        id = 79,
        name = "Lag Spike",
        description = "Lag-Spike Simulation",
        category = "gaming",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255)},
        pattern = "lag",
        speed = "glitchy",
        duration = 5
    },
    {
        id = 80,
        name = "Easter Egg",
        description = "Verstecktes Easter Egg",
        category = "gaming",
        colors = {Color3.fromRGB(255, 20, 147), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 255, 255)},
        pattern = "secret",
        speed = "slow",
        duration = 12
    },

    -- 🎨 ABSTRACT & ART (81-100)
    {
        id = 81,
        name = "Mondrian Blocks",
        description = "Mondrian-Stil Kunst-Blöcke",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 255)},
        pattern = "mondrian",
        speed = "slow",
        duration = 20
    },
    {
        id = 82,
        name = "Pollock Splatter",
        description = "Jackson Pollock Farbspritzer",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "splatter",
        speed = "medium",
        duration = 15
    },
    {
        id = 83,
        name = "Van Gogh Swirls",
        description = "Van Gogh-artige Wirbel",
        category = "art",
        colors = {Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 140, 0)},
        pattern = "swirls",
        speed = "slow",
        duration = 18
    },
    {
        id = 84,
        name = "Picasso Cubism",
        description = "Kubistische Formen",
        category = "art",
        colors = {Color3.fromRGB(139, 69, 19), Color3.fromRGB(255, 215, 0), Color3.fromRGB(128, 128, 128)},
        pattern = "cubism",
        speed = "medium",
        duration = 16
    },
    {
        id = 85,
        name = "Kaleidoscope",
        description = "Kaleidoskop-Muster",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "kaleidoscope",
        speed = "medium",
        duration = 14
    },
    {
        id = 86,
        name = "Fractal Mandelbrot",
        description = "Mandelbrot Fraktal",
        category = "art",
        colors = {Color3.fromRGB(128, 0, 128), Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 255, 255)},
        pattern = "fractal",
        speed = "slow",
        duration = 25
    },
    {
        id = 87,
        name = "Optical Illusion",
        description = "Optische Täuschung",
        category = "art",
        colors = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255)},
        pattern = "illusion",
        speed = "medium",
        duration = 12
    },
    {
        id = 88,
        name = "Color Gradient",
        description = "Sanfte Farbverläufe",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255)},
        pattern = "gradient",
        speed = "slow",
        duration = 20
    },
    {
        id = 89,
        name = "Minimalist Lines",
        description = "Minimalistische Linien",
        category = "art",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color3.fromRGB(128, 128, 128)},
        pattern = "minimal",
        speed = "slow",
        duration = 15
    },
    {
        id = 90,
        name = "Pop Art Dots",
        description = "Pop-Art Punkte wie Roy Lichtenstein",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 0, 255)},
        pattern = "dots",
        speed = "medium",
        duration = 12
    },
    {
        id = 91,
        name = "Watercolor Bleed",
        description = "Aquarell-Farben verlaufen",
        category = "art",
        colors = {Color3.fromRGB(255, 182, 193), Color3.fromRGB(173, 216, 230), Color3.fromRGB(255, 255, 224)},
        pattern = "watercolor",
        speed = "slow",
        duration = 18
    },
    {
        id = 92,
        name = "Stained Glass",
        description = "Buntglas-Fenster Muster",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "stainedglass",
        speed = "slow",
        duration = 22
    },
    {
        id = 93,
        name = "Ink Blot",
        description = "Tinten-Klecks Rorschach Test",
        category = "art",
        colors = {Color3.fromRGB(0, 0, 0), Color3.fromRGB(75, 0, 130), Color3.fromRGB(128, 0, 128)},
        pattern = "inkblot",
        speed = "medium",
        duration = 10
    },
    {
        id = 94,
        name = "Mosaic Tiles",
        description = "Mosaik-Fliesen Muster",
        category = "art",
        colors = {Color3.fromRGB(255, 215, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 20, 147)},
        pattern = "mosaic",
        speed = "medium",
        duration = 16
    },
    {
        id = 95,
        name = "Graffiti Style",
        description = "Street-Art Graffiti",
        category = "art",
        colors = {Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 20, 147), Color3.fromRGB(0, 255, 127)},
        pattern = "graffiti",
        speed = "fast",
        duration = 14
    },
    {
        id = 96,
        name = "Tie Dye",
        description = "Batik Tie-Dye Muster",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "tiedye",
        speed = "slow",
        duration = 20
    },
    {
        id = 97,
        name = "Digital Noise",
        description = "Digitales Rauschen",
        category = "art",
        colors = {Color3.fromRGB(128, 128, 128), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)},
        pattern = "noise",
        speed = "fast",
        duration = 8
    },
    {
        id = 98,
        name = "Plasma Flow",
        description = "Plasma-Energie fließt",
        category = "art",
        colors = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 0)},
        pattern = "plasma",
        speed = "medium",
        duration = 16
    },
    {
        id = 99,
        name = "Marble Texture",
        description = "Marmor-Textur Bewegung",
        category = "art",
        colors = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(169, 169, 169), Color3.fromRGB(105, 105, 105)},
        pattern = "marble",
        speed = "slow",
        duration = 18
    },
    {
        id = 100,
        name = "Infinity Loop",
        description = "Unendlichkeits-Schleife",
        category = "art",
        colors = {Color3.fromRGB(138, 43, 226), Color3.fromRGB(255, 20, 147), Color3.fromRGB(0, 255, 255)},
        pattern = "infinity",
        speed = "medium",
        duration = 24
    }
}

-- 🎯 Pattern-Kategorien für einfache Suche
FloorPatterns.Categories = {
    nature = "🌿 Natur & Elemente (1-20)",
    magic = "🎆 Magic & Fantasy (21-40)", 
    music = "🎵 Musik & Rhythmus (41-60)",
    gaming = "🎮 Gaming & Digital (61-80)",
    art = "🎨 Abstract & Art (81-100)"
}

-- 🔍 Pattern nach ID finden
function FloorPatterns:GetPattern(id)
    for _, pattern in ipairs(self.PatternLibrary) do
        if pattern.id == id then
            return pattern
        end
    end
    return nil
end

-- 🔍 Patterns nach Kategorie filtern
function FloorPatterns:GetByCategory(category)
    local result = {}
    for _, pattern in ipairs(self.PatternLibrary) do
        if pattern.category == category then
            table.insert(result, pattern)
        end
    end
    return result
end

-- 🎲 Zufälliges Pattern
function FloorPatterns:GetRandomPattern(category)
    if category then
        local categoryPatterns = self:GetByCategory(category)
        return categoryPatterns[math.random(1, #categoryPatterns)]
    else
        return self.PatternLibrary[math.random(1, #self.PatternLibrary)]
    end
end

-- 📋 Alle Pattern-Namen auflisten
function FloorPatterns:ListAllPatterns()
    print("🎨 100 FLOOR ANIMATION PATTERNS:")
    print("=" .. string.rep("=", 50))
    
    for category, description in pairs(self.Categories) do
        print("\n" .. description)
        local patterns = self:GetByCategory(category)
        
        for _, pattern in ipairs(patterns) do
            print(string.format("  %02d. %s - %s", pattern.id, pattern.name, pattern.description))
        end
    end
    
    print("\n" .. "=" .. string.rep("=", 50))
    print("🎯 Verwende FloorPatterns:GetPattern(ID) um ein Pattern zu laden!")
end

-- 🎯 Pattern-Suche nach Name
function FloorPatterns:SearchPattern(searchTerm)
    local results = {}
    searchTerm = searchTerm:lower()
    
    for _, pattern in ipairs(self.PatternLibrary) do
        if pattern.name:lower():find(searchTerm) or pattern.description:lower():find(searchTerm) then
            table.insert(results, pattern)
        end
    end
    
    return results
end

return FloorPatterns
