# Model Guide

Current preference is to use `qwen3:30b-a3b` as the default model. It is a larger MoE-style model, but only a subset of parameters are active per token, so it can perform better than some smaller dense models on the current CPU-only VM.

| Model | First-use purpose |
|---|---|
| `qwen3:4b` | first validation model |
| `llama3.2:3b` | lightweight general chat |
| `gemma3:4b` | compact general-purpose option |
| `qwen3:8b` | stronger general model on CPU |
| `qwen2.5-coder:7b` | compact coding-focused model |
| `gemma3:12b` | larger Gemma quality test |
| `phi4:14b` | larger reasoning/general model |
| `qwen3:14b` | higher-quality Qwen CPU test |
| `qwen3:30b-a3b` | preferred default model for current testing |
| `mistral` | general-purpose baseline |

Current Ansible starter bundle:

- `qwen3:4b`
- `llama3.2:3b`
- `gemma3:4b`
- `qwen3:8b`
- `qwen2.5-coder:7b`
- `gemma3:12b`
- `phi4:14b`
- `qwen3:14b`
- `qwen3:30b-a3b`
- `mistral`

Current deployment note:

- Model pulls are automated by `ansible/roles/ai_stack/tasks/main.yml` after the Compose stack starts.
- The Compose runtime is tuned with one loaded model and one parallel request to favor `qwen3:30b-a3b` stability.
- First-token delay is still expected after cold starts because the model must load from disk into memory.

Current Ollama runtime tuning:

- `OLLAMA_KEEP_ALIVE=1h`
- `OLLAMA_MAX_LOADED_MODELS=1`
- `OLLAMA_NUM_PARALLEL=1`
- `OLLAMA_LOAD_TIMEOUT=10m`

Track real HX5 performance here as you test:

| Model | RAM used | Load time | Tokens/sec | Notes |
|---|---:|---:|---:|---|
| `qwen3:30b-a3b` | TBD | TBD | TBD | preferred default |
