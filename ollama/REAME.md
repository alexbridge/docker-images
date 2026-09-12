### Installation

1) docker compose up -d
2) `docker exec -it ollama` && `ollama pull qwen2.5-coder:7b`

#### Claude code

```bash
npm install -g @anthropic-ai/claude-code

.bashrc
export ANTHROPIC_BASE_URL="http://localhost:11434/v1"
export ANTHROPIC_API_KEY="sk-local-unused"
```