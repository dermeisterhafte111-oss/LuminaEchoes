# Lumina Echoes (Godot Engine 4)

Ein 20-minütiges 3D Narrative-Game mit einzigartigem Stylized Cel-Shading Look, 2 Kernmechaniken und automatisierter CI/CD-Build-Pipeline.

## 🌟 Visuals & Style ("Anti-AI Look")
* **Toon / Cel-Shader**: Custom 3D Spatial Shader mit 3-Stufen Lichtquantisierung, Specular-Highlights und Rim-Lighting.
* **Stylized Depth Fog**: Post-Processing Shader auf Basis von Depth- & Screen-Buffer für eine malerische Graphic-Novel-Atmosphäre.

## 🎮 Gameplay & Mechaniken
1. **Chrono-Spektrum-Laterne (`Taste F`)**: Schaltet dynamisch zwischen zwei Zeitstufen (Spektrum A: Gegenwart / Void & Spektrum B: Echo / Blütezeit) um. Objekte und Plattformen verändern Sichtbarkeit und Kollisionslayer.
2. **Resonanz-Fokus (Perspektiv-Rätsel)**: Ausrichtung der First-Person-Kamera auf Fluchtpunkte, um verschmolzene Relikte freizuschalten und Pfade zu reparieren.

## 🛠 Project Structure
```
Advunture/
├── project.godot
├── export_presets.cfg
├── .github/workflows/build.yml
├── assets/
│   └── shaders/
│       ├── cel_shader.gdshader
│       └── post_process_fog.gdshader
├── scenes/
│   ├── player/ (CharacterBody3D, Raycast, Input)
│   ├── mechanics/ (SpectrumLantern, PhaseObject, PerspectivePuzzle)
│   ├── narrative/ (DialogueManager, DialogueBox, NarrativeTrigger)
│   └── levels/ (MainLevel)
```

## 🚀 GitHub Actions CI/CD Pipeline
Bei jedem Push auf `main` oder Tagging (`v*`) baut die GitHub Action `.github/workflows/build.yml` automatisch das Godot 4 Projekt als Windows `.exe`, packt es als Zip-Datei und stellt es in den **GitHub Releases** zum Download bereit.
