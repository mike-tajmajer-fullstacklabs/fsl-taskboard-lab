---
name: plan
description: Create a detailed feature plan broken into implementable chunks following your project patterns
argument-hint: <feature description>
disable-model-invocation: true
---

# Feature Planning

You are creating a feature plan using Hypr. This command uses the **feature-planner** agent to create a comprehensive, actionable feature document.

## Prerequisites Check

First, verify the setup:

1. Check if `.claude/rules/planning.md` exists
   - If not, tell user to run `/hypr:assess-planning` first
2. Check if `features/` directory exists (create if not)

## Feature Request

The feature to plan is provided in $ARGUMENTS.

If $ARGUMENTS is empty, ask the user to describe the feature they want to plan.

## Planning Process

Use the **feature-planner** agent to:

1. **Analyze Requirements**
   - Understand what the user wants to build
   - Identify core functionality and acceptance criteria
   - List affected systems and integrations

2. **Load Project Patterns**
   - Read `.claude/rules/planning.md`
   - Apply project-specific planning patterns

3. **Study Similar Features**
   - Find 2-3 existing features similar to this request
   - Learn from how they were structured

4. **Design Architecture**
   - Plan how feature fits into existing architecture
   - Identify database, API, and UI changes needed

5. **Break Into Chunks**
   - Create small, independent chunks (< 2 hours each)
   - Define dependencies between chunks
   - Mark each as Frontend, Backend, or Both

6. **Plan Testing Strategy**
   - Define tests needed for each chunk
   - Plan integration testing approach

7. **Document Rollback Plan**
   - How to undo the feature if needed
   - Migration rollback procedures

8. **Create Feature Document**
   - Generate `features/feature-XXX-[name].md`
   - Include all planning details

## Output

The plan is saved to:

```
features/feature-XXX-[feature-name].md
```

The document includes:

- Requirements and acceptance criteria
- Architecture design
- Implementation chunks with dependencies
- Testing strategy
- Rollback plan

## Next Steps

After the plan is created:

1. Review the plan with the user
2. Make any adjustments needed
3. Start implementing chunks with:
   - `/hypr:implement` for general implementation
   - Frontend chunks use the frontend-executor agent
   - Backend chunks use the backend-executor agent

## Example Usage

```
/hypr:plan Add user authentication with email/password login
/hypr:plan Create a dashboard showing user activity metrics
/hypr:plan Implement file upload feature for profile pictures
```
