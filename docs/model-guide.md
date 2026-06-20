# Model Guide

Current Open WebUI default is `tinyllama:latest` for fast CPU responses. `qwen3:30b-a3b` remains installed for higher-quality testing; it is a larger MoE-style model, but only a subset of parameters are active per token, so it can perform better than some smaller dense models on the current CPU-only VM.

| Model | First-use purpose |
|---|---|
| `tinyllama:latest` | fast default for CPU-only interactive use |
| `qwen3:4b` | first validation model |
| `llama3.2:3b` | lightweight general chat |
| `gemma3:4b` | compact general-purpose option |
| `qwen2.5-coder:1.5b` | lightweight coding-focused option |
| `qwen3:8b` | stronger general model on CPU |
| `qwen2.5-coder:7b` | compact coding-focused model |
| `phi3.5:latest` | compact reasoning/general model |
| `gemma3:12b` | larger Gemma quality test |
| `deepseek-r1:7b` | distilled reasoning-focused model |
| `phi4:14b` | larger reasoning/general model |
| `qwen3:14b` | higher-quality Qwen CPU test |
| `qwen3:30b-a3b` | higher-quality MoE-style model for current testing |
| `mistral` | general-purpose baseline |

Current Ansible starter bundle:

- `tinyllama:latest`
- `qwen3:4b`
- `llama3.2:3b`
- `gemma3:4b`
- `qwen2.5-coder:1.5b`
- `qwen3:8b`
- `qwen2.5-coder:7b`
- `phi3.5:latest`
- `gemma3:12b`
- `deepseek-r1:7b`
- `phi4:14b`
- `qwen3:14b`
- `qwen3:30b-a3b`
- `mistral`

Current deployment note:

- Model pulls are automated by `ansible/roles/ai_stack/tasks/main.yml` after the Compose stack starts.
- Open WebUI is configured with `DEFAULT_MODELS=tinyllama:latest`.
- Open WebUI task work is configured with `TASK_MODEL=tinyllama:latest` so title generation does not use the large chat model by default.
- Follow-up, tag, and autocomplete generation are disabled by default to reduce background CPU work.
- The Compose runtime starts an `ollama-warmup` one-shot container that pulls and warms TinyLlama when the stack starts.
- The Compose runtime is tuned with one loaded model and one parallel request for CPU-oriented use.
- First-token delay is still expected after cold starts because the model must load from disk into memory.

Current Ollama runtime tuning:

- `OLLAMA_CONTEXT_LENGTH=2048`
- `OLLAMA_KEEP_ALIVE=1h`
- `OLLAMA_MAX_LOADED_MODELS=1`
- `OLLAMA_NUM_PARALLEL=1`
- `OLLAMA_MAX_QUEUE=4`
- `OLLAMA_LOAD_TIMEOUT=10m`

CPU tuning notes:

- `OLLAMA_CONTEXT_LENGTH=2048` is the current balance between speed and usable chat memory.
- Use `1024` if TinyLlama responsiveness is more important than long prompts or chat history.
- Use `4096` for `qwen3:30b-a3b` when quality and longer context matter more than first-token latency.
- `OLLAMA_NUM_PARALLEL=1` prevents multiple generations from competing for CPU.
- `OLLAMA_MAX_LOADED_MODELS=1` avoids keeping multiple model weights resident in memory.
- `OLLAMA_MAX_QUEUE=4` prevents too many requests from silently piling up behind a slow CPU generation.

Current default model:

- `OLLAMA_DEFAULT_MODEL=tinyllama:latest`

Current Open WebUI task defaults:

- `OPEN_WEBUI_TASK_MODEL=tinyllama:latest`
- `OPEN_WEBUI_ENABLE_TITLE_GENERATION=true`
- `OPEN_WEBUI_ENABLE_FOLLOW_UP_GENERATION=false`
- `OPEN_WEBUI_ENABLE_TAGS_GENERATION=false`
- `OPEN_WEBUI_ENABLE_AUTOCOMPLETE_GENERATION=false`

Qwen3 thinking note:

- Your direct API test showed `qwen3:30b-a3b` spending most of the request generating `thinking` tokens before a short answer.
- Use `/no_think` at the start of simple prompts to avoid that extra CPU work.
- Use `/think` only when the extra reasoning is worth the latency.

Track real HX5 performance here as you test:

| Model | RAM used | Load time | Tokens/sec | Notes |
|---|---:|---:|---:|---|
| `tinyllama:latest` | TBD | TBD | TBD | Open WebUI default |
| `qwen3:30b-a3b` | TBD | TBD | TBD | higher-quality test model |
