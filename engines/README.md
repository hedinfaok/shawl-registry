# Shawl Engine Configurations

This directory contains engine configuration files for various scripting languages and runtimes.

## Available Engines

- **bash** - Bash shell scripts
- **python3** - Python 3 scripts
- **node** - Node.js scripts
- **ruby** - Ruby scripts
- **deno** - Deno runtime (TypeScript/JavaScript)
- **java** - Java (compiled with `javac`, run with `java`)

## File Types

- **`.toml`** - Engine configuration defining how to execute scripts in each mode
- **`.tpl`** - Template file used by `shawl init` to create new scripts

## Installation

Copy the engine files you need to your `~/.shawl.d/` directory:

```bash
cp engines/*.toml ~/.shawl.d/
cp engines/*.tpl ~/.shawl.d/
```

Or copy to a local project directory:

```bash
mkdir -p .shawl.d
cp engines/*.toml .shawl.d/
cp engines/*.tpl .shawl.d/
```

## Usage

### Create a new script from template

```bash
shawl init --engine node myscript > myscript.js
shawl init --engine ruby myscript > myscript.rb
shawl init --engine deno myscript > myscript.ts
shawl init --engine java myscript > myscript.java
```

### Execute scripts in different modes

```bash
# Druid mode - source and call function
shawl druid myscript.js myfunction arg1 arg2
shawl --engine ruby druid myscript.rb myfunction

# Exec mode - direct execution
shawl exec myscript.js
shawl --engine node exec myscript.js

# Pipe mode - stream through stdin
shawl pipe myscript.rb

# Shell mode - open REPL with script loaded
shawl --engine ruby shell myscript.rb
```

## Engine Configuration Structure

Each `.toml` file defines 6 execution modes:

- **druid** - Source script and execute named function
- **exec** - Execute entire script with interpreter
- **shebang** - Execute script using its shebang line
- **pipe** - Stream script content through stdin
- **shell** - Open interactive REPL
- **shim** - Execute framework helper scripts

## Creating Custom Engines

1. Create `myengine.toml` with the required sections
2. Create `myengine.tpl` with template variables like `${SHAWL_FUNCTION}`
3. Test with: `shawl --engine myengine init test > test.ext`

See existing engine files for examples.
