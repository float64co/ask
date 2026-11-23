# ask

Query a local [ollama](https://ollama.com) model from the shell, with web `search` (DuckDuckGo) and `web_fetch` tools. Install with `pip install -r requirements.txt`, then run `./install.sh` to symlink `ask` into `~/.local/bin` (`./install.sh --uninstall` removes it). Use it as `ask what's in the news? do a web search` or `somecommand | ask what's going on here?`. Use `ask -i` (or `--interactive`) for a chat REPL that keeps context (`/clear` resets, `/exit` or Ctrl-D quits); it also takes a first question or piped input, e.g. `cmd | ask -i what happened?`. Run `ask --configure` to pick the default model from your installed tool-capable models; this also happens on first run if none is set.

Config lives in `~/.config/ask/`: `ask.conf` (`model = name`) and `systemprompt.txt` (created with a default on first run; `$date` is replaced with today's date). Set `ASK_NUM_CTX` to change the context window (default 16384).
