---
description: Create an orchestrated plan with subagent delegation and progress tracking
agent: plan-orchestrator
---

Analyze the following task and create a comprehensive plan with subagent delegation:

$ARGUMENTS

Instructions:
1. Create a plan document in ~/.claude/plans/ with a descriptive filename
2. Break the task into discrete, parallelizable units
3. Assign appropriate agents to each task (Explore, Plan, Bash, general-purpose)
4. Begin executing tasks, running independent ones in parallel
5. Update the plan document with progress after each task
6. Provide a final summary when complete
