# ADR 003: Environment Variables for Configuration

## Status
Accepted

## Context
Configuration must be portable across local development, CI, and deployment environments without committing secrets.

## Decision
Use environment variables as the primary configuration mechanism.

## Consequences
- Clear separation between code and environment-specific values.
- Safer secret handling by avoiding hardcoded credentials.
- Requires disciplined environment setup and documentation.
