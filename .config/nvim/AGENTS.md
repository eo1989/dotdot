# Repository Guidelines

## Project Structure & Module Organization
Neovim profile anchored by `init.lua`, which sets global defaults and wires plugin specs. Custom modules live under `lua/eo`, split by concern (`lsp/`, `plugs/`, `langs/`, `ui.lua`). Shared helpers sit in `lua/util` and `defaults.lua`. Runtime overrides land in `after/` and filetype tweaks in `ftplugin/`. Lazy.nvim generated config stays in `plugin/`. Snippets reside in `luasnippets/` and `snips/`. Tooling scripts are under `bin/` and `python/`, while long-form experiments live in `test/`.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy sync" +qa` refreshes plugin lockfile after changing specs in `lua/eo/plugs`.
- `stylua lua after ftplugin plugin` formats Lua using `stylua.toml`.
- `selene lua` runs lint checks against the `lua51+vim` standard from `selene.toml`.
- `dprint fmt python test` applies Ruff-formatting to Python notebooks and scripts.
- `ruff check python test` validates Python style and mirrors CI expectations.

## Coding Style & Naming Conventions
Lua uses two-space indentation, sorted `require` blocks, and prefers single-quoted strings, as enforced by Stylua. Keep module filenames kebab-free and aligned with their feature (for example, `lua/eo/lsp/servers.lua`). For Python, Ruff formats to 80 characters and forces double quotes; type-checking is advisory through `basedpyright`. When adding plugins, follow the pattern in `lua/eo/plugs/*` of returning Lazy specs.

## Testing Guidelines
Configure adapters in Neotest via `lua/eo/plugs/tests.lua`. Trigger suite runs with `<localleader>ta` inside Neovim or call `pytest -vv` from the repo root for standalone Python modules. Place reproducible examples under `test/` with descriptive filenames, and clean auxiliary data or caches before submitting.

## Commit & Pull Request Guidelines
Use concise, imperative subjects and group commits by feature; Conventional Commit prefixes (`feat`, `fix`, `chore`, `docs`) keep history actionable. Each PR should outline motivation, summarize functional impact, and link matching issues or notes. Include configuration diffs, screenshots, or logs when UI behaviour changes. Before opening a PR, rerun the commands above and mention the verification in the description.
