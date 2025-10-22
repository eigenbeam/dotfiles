# Eglot & DAP Mode Cheatsheet

Quick reference for essential Eglot (LSP) and DAP (debugging) features.

---

## Prerequisites

### Install Language Servers

```bash
# Python
pip install python-lsp-server[all]
pip install debugpy  # For debugging

# JavaScript/TypeScript
npm install -g typescript-language-server typescript

# HTML/CSS/JSON
npm install -g vscode-langservers-extracted

# Bash
npm install -g bash-language-server

# C/C++
brew install llvm  # Includes clangd

# Java
# Eclipse JDT Language Server downloads automatically on first use
```

---

## Eglot (LSP Client)

### Automatic Activation

Eglot starts automatically when you open supported files:
- Python: `.py` files
- JavaScript: `.js` files
- TypeScript: `.ts` files
- Java: `.java` files
- C/C++: `.c`, `.cpp`, `.h` files
- Bash: `.sh` files

### Essential Commands

| Keybinding | Command | Description |
|------------|---------|-------------|
| **Navigation** | | |
| `M-.` | `xref-find-definitions` | Go to definition |
| `M-,` | `xref-pop-marker-stack` | Go back |
| `M-?` | `xref-find-references` | Find all references |
| `C-M-i` | `completion-at-point` | Manual completion |
| **Editing** | | |
| `C-c l r` | `eglot-rename` | Rename symbol |
| `C-c l a` | `eglot-code-actions` | Code actions (fixes, refactors) |
| `C-c l f` | `eglot-format` | Format buffer/region |
| **Documentation** | | |
| `C-c l d` | `eldoc` | Show documentation at point |
| `C-c l h` | `eldoc-doc-buffer` | Show doc in separate buffer |
| **Server Management** | | |
| `M-x eglot` | Start eglot manually | |
| `M-x eglot-shutdown` | Stop language server | |
| `M-x eglot-reconnect` | Restart language server | |

### How Completion Works

**Automatic:**
- Type code, completion popup appears automatically
- `C-n`/`C-p` to navigate suggestions
- `RET` to accept

**Manual:**
- Press `C-M-i` or `<C-tab>` to trigger completion

### Code Actions (Quick Fixes)

Place cursor on error/warning and press `C-c l a`:
- Import missing modules
- Add type annotations
- Implement interface methods
- Fix common errors

**Example:**
```python
# Cursor on undefined 'os'
import sys
os.path.exists("/tmp")  # Error: 'os' not imported
```
Press `C-c l a` → Select "Import 'os'"

### Renaming Variables/Functions

1. Place cursor on symbol
2. Press `C-c l r`
3. Type new name
4. Press `RET`
5. All references updated across project

---

## DAP Mode (Debugging)

### Setup Checklist

**Python:**
```bash
pip install debugpy
```

**JavaScript/Node.js:**
```bash
npm install -g node-debug2
```

**C/C++:**
```bash
brew install llvm  # LLDB included
```

**Java:**
- Debugging configured automatically with Eclipse JDT

### Essential Debugging Workflow

#### 1. Set Breakpoints

| Keybinding | Command | Description |
|------------|---------|-------------|
| `C-c d b` | `dap-breakpoint-toggle` | Set/remove breakpoint at line |
| `C-c d B` | `dap-breakpoint-delete-all` | Clear all breakpoints |

**Visual indicator:** Red dot appears in left fringe

#### 2. Start Debugging

| Keybinding | Command | Description |
|------------|---------|-------------|
| `C-c d d` | `dap-debug` | Start debugging (choose template) |
| `C-c d l` | `dap-debug-last` | Re-run last debug session |
| `C-c d r` | `dap-debug-recent` | Choose from recent sessions |

**First time:** Select debug template (e.g., "Python :: Run file (buffer)")

#### 3. Control Execution

| Keybinding | Command | Description |
|------------|---------|-------------|
| `C-c d c` | `dap-continue` | Continue (run until next breakpoint) |
| `C-c d n` | `dap-next` | Step over (next line) |
| `C-c d i` | `dap-step-in` | Step into function |
| `C-c d o` | `dap-step-out` | Step out of function |

#### 4. Inspect Variables

| Keybinding | Command | Description |
|------------|---------|-------------|
| **Hover** | Move mouse over variable | See value in tooltip |
| `C-c d u l` | `dap-ui-locals` | Show local variables panel |
| `C-c d u s` | `dap-ui-sessions` | Show active debug sessions |
| `C-c d u b` | `dap-ui-breakpoints` | Show all breakpoints |
| `C-c d u r` | `dap-ui-repl` | Interactive REPL in debug context |

### Debug UI Panels

When debugging, these panels are available:

**Locals Panel** (`C-c d u l`):
- Shows all variables in current scope
- Updates as you step through code
- Expand nested objects

**Sessions Panel** (`C-c d u s`):
- Shows call stack
- Click to jump to different stack frames

**Breakpoints Panel** (`C-c d u b`):
- List all breakpoints
- Enable/disable specific breakpoints
- Jump to breakpoint location

**REPL Panel** (`C-c d u r`):
- Evaluate expressions in debug context
- Inspect complex objects
- Test code snippets

### Complete Debug Example (Python)

```python
# example.py
def calculate(x, y):
    result = x + y  # Set breakpoint here (C-c d b)
    return result * 2

def main():
    total = calculate(5, 3)  # Set breakpoint here too
    print(f"Result: {total}")

if __name__ == "__main__":
    main()
```

**Steps:**
1. Open `example.py`
2. Place cursor on `result = x + y` line
3. Press `C-c d b` (red dot appears)
4. Press `C-c d d` → Select "Python :: Run file (buffer)"
5. Program stops at breakpoint
6. Press `C-c d u l` to see locals (x=5, y=3)
7. Hover over `result` to see it's undefined yet
8. Press `C-c d n` to execute line
9. Hover over `result` to see it's now 8
10. Press `C-c d c` to continue to next breakpoint
11. Press `C-c d c` again to finish execution

### Java-Specific Debugging

| Keybinding | Command | Description |
|------------|---------|-------------|
| `C-c d t m` | `dap-java-run-test-method` | Run JUnit test method under cursor |
| `C-c d t c` | `dap-java-run-test-class` | Run all tests in current class |

**Usage:**
1. Place cursor inside test method
2. Press `C-c d t m`
3. Test runs with debugging enabled
4. Stops at breakpoints in test or code

---

## Common Workflows

### 1. Exploring Unknown Code

```
1. Open file → Eglot starts automatically
2. M-. on function/class → Jump to definition
3. Read code
4. M-, → Return to where you were
5. M-? on symbol → See all usages
```

### 2. Fixing a Bug

```
1. Navigate to buggy function (M-.)
2. Set breakpoint (C-c d b)
3. Start debugging (C-c d d)
4. Step through (C-c d n)
5. Inspect variables (hover or C-c d u l)
6. Find bug
7. Stop debugging
8. Fix code
9. C-c l f to format
```

### 3. Refactoring

```
1. Place cursor on function/variable name
2. C-c l r → Rename across project
3. C-c l a → See available refactorings
4. Select refactoring (e.g., "Extract method")
```

### 4. Understanding Function Signature

```
1. Place cursor on function call
2. C-c l d → See signature and documentation
3. Or C-c l h → Open full documentation in buffer
```

---

## Troubleshooting

### Eglot won't start

**Check if language server is installed:**
```elisp
M-x eglot
```
Error message will tell you which server is missing.

**Manual installation:**
```bash
# Python
pip install python-lsp-server[all]

# JavaScript
npm install -g typescript-language-server typescript

# Java (auto-installs, but slow first time - be patient!)
```

**Restart server:**
```
M-x eglot-shutdown
M-x eglot
```

### Debugging won't start

**Check debugger installation:**
```bash
# Python
pip list | grep debugpy

# Node.js
npm list -g | grep node-debug2
```

**Check debug template exists:**
```
C-c d d → Should show debug templates
```

If no templates appear, debugger isn't configured for that language.

### Completion not working

1. Check eglot is running: Mode line shows "eglot"
2. Try manual completion: `C-M-i`
3. Check company/corfu is installed: `M-x company-mode`

### Performance issues

**Eglot using too much CPU:**
```elisp
M-x eglot-shutdown  ; Stop server
M-x eglot-reconnect  ; Restart fresh
```

**Large Java projects slow:**
- First startup is slow (indexes project)
- Subsequent opens are fast
- Consider increasing JVM heap in eglot config if needed

---

## Quick Reference Card

### Most Used Commands

| Task | Keybinding |
|------|------------|
| **Go to definition** | `M-.` |
| **Go back** | `M-,` |
| **Find references** | `M-?` |
| **Rename** | `C-c l r` |
| **Code actions/fixes** | `C-c l a` |
| **Format code** | `C-c l f` |
| **Set breakpoint** | `C-c d b` |
| **Start debugging** | `C-c d d` |
| **Step over** | `C-c d n` |
| **Continue** | `C-c d c` |
| **Show variables** | `C-c d u l` |

### Less Common But Useful

| Task | Command |
|------|---------|
| **Restart language server** | `M-x eglot-reconnect` |
| **Show hover info** | `C-c l d` |
| **Evaluation in debug REPL** | `C-c d u r` |
| **Jump to error** | `M-g n` (next-error) |

---

## Tips & Tricks

### Eglot

1. **Completion shows up automatically** - no need to trigger manually
2. **Error checking is instant** - squiggly lines show errors as you type
3. **Documentation on hover** - eldoc shows info in minibuffer automatically
4. **Format on save** - Add to your config: `(add-hook 'before-save-hook 'eglot-format-buffer)`
5. **Project-aware** - Eglot knows your project boundaries (uses projectile/project.el)

### DAP Mode

1. **Breakpoints persist** - Set breakpoints before starting debug session
2. **Conditional breakpoints** - `M-x dap-breakpoint-condition`
3. **Mouse clicks** - Click in fringe to toggle breakpoints
4. **Expression evaluation** - Use REPL panel to test code during debugging
5. **Multiple sessions** - Can debug multiple programs simultaneously

---

## Next Steps

### Learning Resources

- **Eglot Manual**: `M-x info-display-manual RET eglot`
- **DAP Mode GitHub**: https://github.com/emacs-lsp/dap-mode
- **Practice**: Debug the example.py above to get comfortable

### Advanced Features

Once comfortable with basics, explore:
- `M-x eglot-code-action-organize-imports` - Clean up imports
- `M-x dap-breakpoint-condition` - Conditional breakpoints
- `M-x dap-ui-expressions` - Watch expressions
- `M-x eglot-find-implementation` - Find interface implementations

---

*Generated for Emacs configuration - 2025*
