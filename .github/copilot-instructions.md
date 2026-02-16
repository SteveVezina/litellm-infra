# Copilot AI Agent Instructions for LiteLLM

## Project Overview
LiteLLM is a proxy and integration layer for multiple LLM providers (OpenAI, Anthropic, HuggingFace, etc.), supporting unified API endpoints, model routing, and credential management. It is designed for extensibility and easy deployment (Docker, Python, etc.).

## Architecture & Key Components
- **Proxy Server**: Exposes OpenAI-compatible endpoints (e.g., `/v1/messages`, `/chat/completion`).
- **Provider Integrations**: Each provider (OpenAI, Anthropic, etc.) is implemented as a module under `litellm/providers/`.
- **Credential Management**: Credentials are encrypted using `LITELLM_SALT_KEY` and stored in a Postgres DB (see `DATABASE_URL`).
- **Model Routing**: Requests are routed to the correct provider/model based on config and request params.
- **A2A Protocol**: Agent-to-agent communication is supported via the A2A protocol (see `a2a_protocol/`).

## Developer Workflows
- **Environment**: Use `.env` for secrets. Launch with Docker Compose (`make docker-up`).
- **Testing**: (If present) Run tests with `pytest` or `make test`.
- **Logs**: Use `make docker-logs` for container logs.
- **DB**: Postgres runs on a random port (see `POSTGRES_PORT` in `.env`).

## Patterns & Conventions
- **Provider Abstraction**: Add new providers by implementing the required interface in `litellm/providers/`.
- **Model Names**: Use provider/model slugs (e.g., `huggingface/bigcode/starcoder`).
- **API Keys**: Never hardcode secrets; always use environment variables.
- **Agent Config**: For A2A, define agents in YAML with `agent_name`, `agent_card_params`, and `model`.

## Integration Points
- **External LLMs**: Integrate via provider modules and environment variables.
- **A2A**: See `a2a_protocol/` for agent communication patterns.
- **DotPrompt/Levo**: See `integrations/` for prompt management and workflow tools.

## Example: Launching with Docker Compose
```sh
make docker-up
# Access LiteLLM at http://localhost:4000
```

## Key Files & Directories
- `.env` – Environment variables
- `docker-compose.yml` – Service definitions
- `Makefile` – Common workflows
- `litellm/providers/` – Provider integrations
- `a2a_protocol/` – Agent-to-agent protocol
- `integrations/` – Prompt/workflow integrations

---
If you add new providers, update the provider abstraction and document usage in this file.
