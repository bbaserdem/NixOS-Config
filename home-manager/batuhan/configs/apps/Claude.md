# Communication Guidelines
- Always let me know what my second best suggestion would have been
- Do what has been asked; nothing more, nothing less
- NEVER implement more simple solution for sole purpose of passing a build
- Don't assume a task is complete unless it's tested first.

# Coding
- Always plan a code change thoroughly before implementing it.
- Evaluate your thought process before starting any implementation.
- Use TodoWrite to itemize the feature implementations.

# Dev Environment
- We are working in a nix dev shell loaded with direnv at all times.
- All project dependencies and used binaries should be in the dev shell defined by the flake.
- Warn if a binary used is not present in the dev shell.
- Don't edit flake unless asked to, always suggest the changes without applying them first.

# Workspace Boundary
- Never create any files outside the directory of the dev environment.
- Don't generate any non-local config files; ~/.ssh is verboten while ./ssh is allowed.

# Testing
- While writing tests, never hardcode features in the tests just to make them pass.
- All the libraries in test cases should come from the main code, never write code to be just used for a test case.
- While writing tests, always think about what features are to be tested first.

# Documentation
- Any documentation you create can be put in a parent folder called `ai_notes`.
- `docs` directory will contain detailed files describing the coding project
- Never edit `docs` directory unless explicitly asked for.

# Debugging
- When user presents an error, read through code first to figure out why the error is happening.
- Plan first without making changes when debugging. Only when the plan is fully mapped out, start implementing the solution.

# Workflow
- Be sure to typecheck when you’re done making a series of code changes
- Prefer running single tests, and not the whole test suite, for performance
