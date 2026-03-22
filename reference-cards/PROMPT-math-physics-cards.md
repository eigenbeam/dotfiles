# Reference Card Creation Prompt

I want you to create LaTeX reference cards (cheat sheets) for various topics in mathematics and physics. Each card should be a printable two-sided US Letter landscape PDF — a front page and a back page.

## LaTeX Template

Use this exact preamble and structure for every card:

```latex
% [Topic] Reference Card
\documentclass[9pt]{extarticle}
\usepackage[landscape,paperwidth=11in,paperheight=8.5in,
            margin=0.4in]{geometry}
\usepackage{tabularx}
\usepackage{multicol}
\usepackage{needspace}
\usepackage[T1]{fontenc}
\usepackage{microtype}
\usepackage{helvet}
\usepackage[scaled=0.82]{beramono}
\usepackage{amsmath,amssymb}
\renewcommand{\familydefault}{\sfdefault}
\newcolumntype{Y}{>{\raggedright\arraybackslash}X}

\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\columnsep}{0.3in}

\newcommand{\cardtitle}[1]{%
  {\Large\bfseries #1}\par\vspace{1pt}%
  \rule{\linewidth}{0.4pt}\par\vspace{4pt}%
}
\newcommand{\sect}[1]{\needspace{4\baselineskip}\vspace{6pt}{\footnotesize\bfseries\scshape #1}\par\vspace{2pt}}

\begin{document}\small

\cardtitle{Topic Name}

\begin{multicols}{3}
% ... sections ...
\end{multicols}

\newpage

\cardtitle{Topic Name --- Subtitle for Back Page}

\begin{multicols}{3}
% ... more sections ...
\end{multicols}

\end{document}
```

Note: Add `\usepackage{amsmath,amssymb}` (and `\usepackage{physics}` if needed) since these are math/physics cards. The programming cards used `beramono` for monospace code — for math cards, the focus is on equations and symbols instead.

## Conventions

1. **Page 1 (front):** Core definitions, fundamental equations, key theorems, and essential identities for the topic.
2. **Page 2 (back):** Advanced material, applications, worked-out formula derivations, special cases, or computational techniques.
3. **Layout:** 3-column `multicols` layout. Use `\sect{Section Name}` for section headers.
4. **Section content:** Use `tabularx` with two columns (symbol/equation on the left, description on the right) for lists of formulas. Use display math (`\[ ... \]` or `align*`) for important standalone equations.
5. **`\needspace`:** Already built into the `\sect` command to prevent orphaned section headers at column breaks.
6. **Density:** Pack it dense — these are reference cards, not textbooks. Favor concise notation and short descriptions.
7. **Both pages must fit on one page each.** Build with `pdflatex` and verify "Output written on ... (2 pages, ...)".
8. **File naming:** `{topic}-card.tex`, e.g., `linear-algebra-card.tex`, `electromagnetism-card.tex`.
9. **No footers, no page numbers.** The `\pagestyle{empty}` handles this.
10. **Clean up:** Remove `.aux` and `.log` files after building.

## Section Pattern for Math/Physics

For a math topic, sections might look like:

```latex
\sect{Key Definitions}
\begin{tabularx}{\linewidth}{@{}l@{\enspace}Y@{}}
$\det(A)$           & Determinant of $A$ \\
$\operatorname{tr}(A)$ & Trace of $A$ \\
$A^{-1}$            & Inverse (if $\det A \neq 0$) \\
\end{tabularx}

\sect{Fundamental Theorem}
If $A$ is symmetric, then all eigenvalues are real and eigenvectors form an orthonormal basis.
\[ A = Q \Lambda Q^T \]
```

For a physics topic:

```latex
\sect{Maxwell's Equations (Differential)}
\begin{tabularx}{\linewidth}{@{}l@{\enspace}Y@{}}
$\nabla \cdot \mathbf{E} = \rho/\varepsilon_0$  & Gauss's law \\
$\nabla \cdot \mathbf{B} = 0$                     & No magnetic monopoles \\
$\nabla \times \mathbf{E} = -\partial_t \mathbf{B}$ & Faraday's law \\
$\nabla \times \mathbf{B} = \mu_0 \mathbf{J} + \mu_0\varepsilon_0 \partial_t \mathbf{E}$ & Ampère--Maxwell \\
\end{tabularx}
```

## Example Topic Suggestions

Mathematics:
- Linear Algebra
- Real Analysis
- Complex Analysis
- Probability & Statistics
- Differential Equations (ODE & PDE)
- Abstract Algebra (Groups, Rings, Fields)
- Topology
- Differential Geometry
- Number Theory
- Combinatorics & Graph Theory
- Numerical Methods
- Category Theory

Physics:
- Classical Mechanics (Lagrangian & Hamiltonian)
- Electromagnetism
- Quantum Mechanics
- Statistical Mechanics & Thermodynamics
- Special & General Relativity
- Fluid Dynamics
- Optics
- Solid State Physics

## How to Ask for Cards

Just tell me which topic(s) you want and I'll produce the `.tex` file(s). For example:

> "Create a reference card for Linear Algebra"
> "Create cards for Electromagnetism and Quantum Mechanics"

I'll output the complete `.tex` file for each, ready to build with `pdflatex`.
