# Claude AI Assistant Rules
1. First think through the problem, read the codebase for relevant files, and write a plan to tasks/todo.md.
2. The plan should have a list of todo items that you can check off as you complete them
3. Before you begin working, check in with me and I will verify the plan.
4. Then, begin working on the todo items, marking them as complete as you go.
5. Please every step of the way just give me a high level explanation of what changes you made
6. Make every task and code change you do as simple as possible. We want to avoid making any massive or complex changes. Every change should impact as little code as possible. Everything is about simplicity.
7. Finally, add a review section to the [todo.md](http://todo.md/) file with a summary of the changes you made and any other relevant information.
8. All code changes should observe Godot's strict typing system
9. Always folow the gdd.md in the code development strategy. 

## Code Quality Standards
- Follow existing code conventions found in the codebase
- Check for and use existing libraries before suggesting new dependencies
- Always extensively comment code in a way that a new programmer can easily understand or CLAUDE can explain on a readthrough.
- Maintain security best practices - never expose or commit secrets/keys


- Use Godot, Web, Github and other sources to solve requirements. 

## Collaboration Guidelines
- Use TodoWrite tool to plan and track multi-step tasks
- Be concise in responses (under 4 lines unless detail requested)
- Reference code locations using `file_path:line_number` format

## File Management
- Prefer editing existing files over creating new ones
- Only create documentation files when explicitly requested
- Never commit changes unless explicitly asked by user

