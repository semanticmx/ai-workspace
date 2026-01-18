# Visuals Directory

Visual assets, design files, and graphical documentation for projects.

## Structure

- **screenshots/** - Application screenshots, UI captures, error states
- **diagrams/** - Technical diagrams, flowcharts, architecture diagrams
- **wireframes/** - UI wireframes, mockups, prototypes
- **design-systems/** - Design tokens, component libraries, style guides

## File Organization

### Screenshots
Organize by project and date:
```
screenshots/
├── project-name/
│   ├── 2024-01-17-homepage.png
│   ├── 2024-01-17-dashboard.png
│   └── bugs/
│       └── 2024-01-17-error-state.png
```

### Diagrams
Organize by type:
```
diagrams/
├── architecture/
│   ├── system-overview.png
│   └── microservices-layout.svg
├── user-flows/
│   ├── onboarding-flow.png
│   └── checkout-process.png
└── database/
    └── schema-diagram.png
```

### Wireframes
Organize by project phase:
```
wireframes/
├── project-name/
│   ├── low-fidelity/
│   ├── high-fidelity/
│   └── final/
```

### Design Systems
Component organization:
```
design-systems/
├── colors.json
├── typography.md
├── components/
│   ├── buttons.fig
│   └── forms.fig
└── patterns/
```

## Figma Integration

### Storing Figma Files
1. **Export Options:**
   - `.fig` files for local backups
   - `.svg` for vector graphics
   - `.png` for raster previews

2. **Figma Links Reference:**
Create a `figma-links.md` file:
```markdown
# Figma Project Links

## Main Design File
https://www.figma.com/file/xxxxx/project-name

## Component Library
https://www.figma.com/file/xxxxx/components

## Prototypes
- [User Flow 1](https://www.figma.com/proto/xxxxx)
- [User Flow 2](https://www.figma.com/proto/xxxxx)
```

## Visual Code Documentation

### Code-to-Visual Mapping
Create visual references for code:

```markdown
# Component: Button

## Visual Reference
![Button States](./screenshots/components/button-states.png)

## Code Location
`src/components/Button.tsx`

## Design Token Mapping
- Primary Color: `var(--color-primary)` → #007AFF
- Border Radius: `var(--radius-md)` → 8px
```

## Best Practices

1. **Naming Convention:**
   - Use descriptive names: `checkout-flow-step-2.png`
   - Include dates for versions: `2024-01-17-v2-dashboard.png`
   - Use kebab-case for consistency

2. **File Formats:**
   - Screenshots: PNG for quality, JPG for size
   - Diagrams: SVG for scalability, PNG for compatibility
   - Wireframes: PDF for sharing, PNG for embedding

3. **Version Control:**
   - Use Git LFS for large binary files
   - Keep source files (Figma, Sketch) separate from exports
   - Document export settings in README

4. **Cross-Referencing:**
   - Link visuals in code comments
   - Reference visuals in documentation
   - Map designs to implementation

## Tools Integration

### Recommended Tools
- **Screenshots:** CleanShot, Snagit, Built-in OS tools
- **Diagrams:** draw.io, Mermaid, PlantUML, Excalidraw
- **Wireframes:** Figma, Sketch, Balsamiq
- **Image Optimization:** ImageOptim, TinyPNG

### Automation Scripts
Store in `workflows/scripts/`:
- `optimize-images.sh` - Batch optimize images
- `export-figma.js` - Automated Figma exports
- `generate-thumbnails.sh` - Create preview thumbnails