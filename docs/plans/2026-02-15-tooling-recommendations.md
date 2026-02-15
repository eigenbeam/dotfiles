# Tooling Recommendations

Comprehensive tooling audit based on current dotfiles setup (Feb 2026).

Guiding principle: terminal-native by default, GUI when genuinely better
(geospatial viz, data notebooks with plots, Mathematica interactive work,
3D scientific visualization).

---

## 1. Nvim LSP & Language Support

### New LSP Servers

| Server | Language | Install |
|--------|----------|---------|
| typescript-language-server | JS/TS | `npm i -g typescript-language-server typescript` |
| terraform-ls | Terraform/HCL | `brew install hashicorp/tap/terraform-ls` |
| yaml-language-server | YAML | `brew install yaml-language-server` |
| dockerfile-language-server-nodejs | Dockerfile | `npm i -g dockerfile-language-server-nodejs` |
| taplo | TOML | `brew install taplo` |
| lsp-wl | Wolfram Language | Build from source: github.com/kenkangxgwe/lsp-wl |

Java: Use **nvim-jdtls** plugin (not raw lspconfig). Install jdtls via Mason or
manually from eclipse.org/jdtls.

Julia: Install **LanguageServer.jl** from Julia package manager
(`using Pkg; Pkg.add("LanguageServer")`). Configure in lspconfig as `julials`.

### New Nvim Plugins

| Plugin | Purpose |
|--------|---------|
| nvim-jdtls (mfussenegger) | Java development: classpath, build tools, debugging |
| nvim-lint (mfussenegger) | Async linting: ruff, eslint, tflint, shellcheck |
| nvim-dap + nvim-dap-ui | Debug Adapter Protocol: step-through debugging |
| quarto-nvim + otter.nvim | Quarto editing with LSP inside embedded code blocks |
| vim-mathematica or treesitter-wolfram | Wolfram Language syntax highlighting |

### Conform.nvim Formatters

| Formatter | Languages | Install |
|-----------|-----------|---------|
| ruff | Python | `uv tool install ruff` |
| prettier | JS/TS, JSON, YAML, Markdown | `npm i -g prettier` |
| terraform_fmt | Terraform | ships with `terraform` CLI |

### Treesitter Parsers to Add

java, javascript, typescript, tsx, terraform, hcl, julia, json, toml,
dockerfile, css, sql

---

## 2. Python Tooling

### Essential

| Tool | Purpose | Install |
|------|---------|---------|
| ruff | Lint + format (replaces black, isort, flake8) | `uv tool install ruff` |
| ipython | Better REPL | `uv tool install ipython` |
| polars | Fast DataFrames (5-50x faster than pandas) | project dependency |
| DuckDB | SQL on parquet/CSV/JSON, no server | `brew install duckdb` |

### Scientific / Computational

| Library | Purpose |
|---------|---------|
| sympy | Symbolic math (CAS) in Python |
| scipy | Numerical methods, optimization, ODEs, linear algebra |
| numpy | Array computing |
| jax | Autodiff + GPU-accelerated numpy. Differentiable simulation. |
| matplotlib | Standard plotting |
| manim | Mathematical animation (3Blue1Brown). Blog-quality. |
| pint | Physical unit handling |
| uncertainties | Error propagation |

### Geospatial / Remote Sensing

| Library | Purpose |
|---------|---------|
| earthaccess | NASA Earthdata auth + search + download. Handles NSIDC DAAC. |
| icepyx | ICESat-2 specific: query, subset, download ATL products |
| xarray + rioxarray | N-dimensional arrays with CRS-aware I/O. Standard for rasters. |
| h5py | HDF5 reading (ICESat-2 ATL products are HDF5) |
| h5coro | Cloud-optimized HDF5 access (for S3-hosted data) |
| geopandas | Geospatial DataFrames. Point/line/polygon + spatial joins. |
| rasterio | Raster I/O (GeoTIFF etc). Built on GDAL. |
| lonboard | Fast geospatial viz (deck.gl). Handles millions of points. |
| leafmap | Interactive maps in notebooks/Quarto |
| datashader | Render billions of points. Good for ICESat-2 ground tracks. |

---

## 3. Julia

| Tool / Package | Purpose | Install |
|----------------|---------|---------|
| juliaup | Julia version manager | `brew install juliaup` |
| Revise.jl | Hot-reload code without restarting REPL | Pkg.add |
| OhMyREPL.jl | Syntax highlighting + bracket matching in REPL | Pkg.add |
| Pluto.jl | Reactive notebooks (browser, genuinely better) | Pkg.add |
| DifferentialEquations.jl | Best-in-class ODE/PDE/SDE solver | Pkg.add |
| Makie.jl (or CairoMakie/GLMakie) | Publication-quality plotting, GPU-accelerated | Pkg.add |
| Symbolics.jl + ModelingToolkit.jl | Symbolic-numeric modeling | Pkg.add |
| Unitful.jl | Physical units | Pkg.add |
| Measurements.jl | Error propagation | Pkg.add |

---

## 4. Mathematica & Octave

### Mathematica

Split workflow:
- **Nvim** for editing `.wl`/`.wls` scripts: lsp-wl for completion/diagnostics,
  wolframscript CLI for execution
- **Mathematica GUI** for interactive exploration: Manipulate, 3D plots, typeset
  output (genuinely better)

wolframscript usage from terminal:
```
wolframscript -f script.wl          Run a script
wolframscript -code '2+2'           One-liner
wolframscript -api url -arg x=5     Call deployed API
```

### Octave

Works well in terminal (`octave --no-gui`). No strong LSP. Use in tmux alongside
nvim. Treesitter grammar available (matlab/octave).

---

## 5. Remote Dev (SSH to EC2)

### SSH Config Additions

```
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host ec2-*
    User ec2-user
    IdentityFile ~/.ssh/your-key.pem
    # Add ProxyJump for bastion if needed
```

Create socket dir: `mkdir -p ~/.ssh/sockets`

### Tools

| Tool | Purpose | Install |
|------|---------|---------|
| mosh | Mobile shell. Survives WiFi/IP changes. | `brew install mosh` (+ remote) |
| AWS SSM Session Manager | Shell access via IAM, no port 22 | `brew install --cask session-manager-plugin` |
| autossh | Persistent auto-reconnecting tunnels | `brew install autossh` |
| sshuttle | VPN-over-SSH for private subnets | `brew install sshuttle` |

### Portable Dotfiles

Add a bootstrap script that works on fresh EC2 instances:
install nvim, clone dotfiles, stow essentials. Keep it lightweight
(skip GUI tools, Homebrew casks, fonts).

---

## 6. Data Exploration & Visualization

### Terminal-Native

| Tool | Purpose | Install |
|------|---------|---------|
| visidata | TUI spreadsheet: CSV/JSON/parquet/HDF5. Sort, filter, plot. | `brew install visidata` |
| DuckDB CLI | SQL REPL for analytics on files | `brew install duckdb` |
| plotext | Terminal plotting (scatter, bar, hist) | pip/uv |

### Browser-Based (genuinely better for viz)

| Tool | Purpose | Install |
|------|---------|---------|
| marimo | Reactive Python notebooks. Pure .py files (git-friendly). | `uv tool install marimo` |
| Pluto.jl | Reactive Julia notebooks | Julia Pkg.add |
| Quarto | Render notebooks to blog/papers/slides | `brew install --cask quarto` |

### GUI (genuinely better)

| Tool | Purpose | Install |
|------|---------|---------|
| QGIS | Geospatial exploration. Raster/vector/point layers on maps. | `brew install --cask qgis` |
| Paraview | 3D scientific visualization (volume rendering, field viz) | `brew install --cask paraview` |

---

## 7. Infrastructure / DevOps

| Tool | Purpose | Install |
|------|---------|---------|
| lazydocker | Docker TUI (containers, images, volumes, logs) | `brew install lazydocker` |
| dive | Explore Docker image layers, find bloat | `brew install dive` |
| aws-vault | Secure AWS creds in macOS keychain | `brew install aws-vault` |
| granted | Fast AWS role switching (`assume role-name`) | `brew install common-fate/granted/granted` |
| tflint | Terraform linter (catches what validate misses) | `brew install tflint` |
| infracost | Cost estimates for Terraform plans | `brew install infracost` |

---

## 8. Quarto Blog

Use quarto-nvim + otter.nvim for editing in nvim with LSP inside code blocks.

Workflow: write `.qmd` files in nvim, render with `quarto render`, preview with
`quarto preview`, publish with `quarto publish`.

For computational posts: write in marimo (Python) or Pluto (Julia), export to
Quarto format. Or use Quarto's native code execution.

---

## 9. General CLI Tools

| Tool | Purpose | Install |
|------|---------|---------|
| hyperfine | Benchmark commands (statistically rigorous) | `brew install hyperfine` |
| dust | Disk usage TUI (du replacement, treemap) | `brew install dust` |
| procs | ps replacement (colored, searchable, tree) | `brew install procs` |
| tokei | Count lines of code by language | `brew install tokei` |
| age | File encryption (simpler than GPG) | `brew install age` |
| just | Command runner (better make for project tasks) | `brew install just` |

---

## 10. Other Physics & Math

| Tool | Purpose | Install |
|------|---------|---------|
| Typst | Modern LaTeX alternative. 10-100x faster compilation. | `brew install typst` |
| GDAL | Geospatial data abstraction library. Foundation for rasterio etc. | `brew install gdal` |
| gnuplot | Classic terminal-friendly plotting | `brew install gnuplot` |

Mathematica, Octave, and TeX Live already installed.

---

## Priority Summary

**Immediate (high impact, low effort):**
- ruff, ipython, DuckDB, visidata
- LSPs: typescript-language-server, terraform-ls, yaml-language-server
- Treesitter parsers for missing languages
- SSH config hardening
- mosh

**Next (high impact, some setup):**
- nvim-lint, nvim-dap, nvim-jdtls, quarto-nvim
- conform.nvim: add ruff, prettier, terraform_fmt
- lazydocker, aws-vault, tflint
- QGIS, marimo
- juliaup + key Julia packages

**When needed:**
- earthaccess, icepyx, xarray (when doing geospatial work)
- JAX (when doing differentiable computation)
- DifferentialEquations.jl (when solving ODEs in Julia)
- Paraview (when doing 3D visualization)
- lsp-wl (when editing Wolfram Language in nvim)
- Typst (when writing papers/notes and wanting faster iteration than LaTeX)
