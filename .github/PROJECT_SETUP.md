# GitHub Projects Setup Guide

This guide walks you through setting up a GitHub Project to track Signal's launch tasks.

---

## Option 1: Quick Setup (Recommended)

### Create the Project

1. **Navigate to Projects**
   - Go to: https://github.com/lewisflude/signal-nix/projects
   - Or: Repository → Projects tab

2. **Create New Project**
   - Click: "New project"
   - Choose: "Board" template
   - Name: **"Signal v1.0 Launch"**
   - Description: "Track all tasks for Signal Design System v1.0 launch"
   - Click: "Create project"

3. **Configure Columns**
   
   Rename the default columns to:
   - **📋 Todo** - Tasks not yet started
   - **🏃 In Progress** - Currently working on
   - **✅ Done** - Completed tasks
   - **🚫 Blocked** - Waiting on something (optional)

4. **Add Custom Fields** (optional but useful)
   
   Click "+ New field" to add:
   - **Priority**: Single select (High, Medium, Low)
   - **Estimated Time**: Text (e.g., "2 hours")
   - **Category**: Single select (Technical, Visual, Documentation, Community)
   - **Depends On**: Text (list issue numbers)

---

## Option 2: Import from Template

### Use Project Template

1. **Create from Template**
   - Go to: https://github.com/lewisflude/signal-nix/projects
   - Click: "New project"
   - Choose: "Team planning" or "Feature release"
   - Customize as needed

2. **Adjust for Launch**
   - Rename to "Signal v1.0 Launch"
   - Modify columns to match launch phases
   - Add relevant custom fields

---

## Adding Tasks to Project

### Method 1: Convert from Tracking Issue

1. **Create the tracking issue**
   - Go to: https://github.com/lewisflude/signal-nix/issues/new
   - Paste content from `.github/LAUNCH_TRACKING_ISSUE.md`
   - Submit issue

2. **Add to project**
   - Open the issue
   - Right sidebar → Projects
   - Select "Signal v1.0 Launch"
   - Set status: "Todo"

3. **Break down tasks**
   - For each major checkbox in the tracking issue
   - Create a separate issue using the task templates
   - Link back to tracking issue

### Method 2: Create Task Issues Manually

Use the task templates in `.github/ISSUE_TEMPLATES/`:

1. **Screenshots Task**
   - Use: `task-screenshots.md`
   - Create issue from template
   - Add to project → "Todo"
   - Set priority: "High"

2. **Launch Day Task**
   - Use: `task-launch-day.md`
   - Create issue from template
   - Add to project → "Todo"
   - Set priority: "High"
   - Add dependency: Screenshots task

3. **Additional Tasks**
   - Create issues for other major tasks:
     - "Test CI workflows"
     - "Review documentation"
     - "Create demo videos"
     - "Monitor post-launch feedback"

### Method 3: Add Draft Items Directly

1. **In the Project Board**
   - Click "+ Add item" in "Todo" column
   - Type task name
   - Press Enter

2. **Convert to Issue**
   - Hover over draft item
   - Click "..." → "Convert to issue"
   - Choose repository
   - Add details and submit

---

## Organizing Your Project

### Suggested Workflow

**Todo Column:**
- All unstarted tasks
- Sorted by priority (High at top)
- Clear dependencies noted

**In Progress Column:**
- Only 1-3 tasks at a time (stay focused!)
- Update status regularly
- Add notes/comments as you work

**Done Column:**
- Completed tasks
- Keep for reference during launch
- Archive after launch complete

**Blocked Column** (optional):
- Tasks waiting on dependencies
- Note what's blocking
- Re-evaluate daily

### Using Labels

Add labels to issues for better filtering:

**Priority:**
- 🔴 `priority: high` - Must complete before launch
- 🟡 `priority: medium` - Important but not blocking
- 🟢 `priority: low` - Nice to have

**Category:**
- 🔧 `launch` - Launch-related tasks
- 📸 `documentation` - Docs and screenshots
- ⚙️ `technical` - CI/CD and testing
- 🎨 `visual` - Screenshots and videos
- 👥 `community` - Announcements and engagement

**Status:**
- ⏸️ `blocked` - Waiting on something
- 🐛 `bug` - Issues to fix
- ✨ `enhancement` - Future improvements

---

## Project Views

### Create Multiple Views

1. **Board View** (default)
   - Kanban-style columns
   - Drag and drop tasks
   - Best for daily workflow

2. **Table View** (optional)
   - Click "+ New view" → Table
   - See all fields at once
   - Sort by priority, date, etc.
   - Best for planning

3. **Timeline View** (optional)
   - Click "+ New view" → Timeline
   - Add start/end dates to tasks
   - See launch schedule visually
   - Best for deadline tracking

### Filtering

Create saved filters:

1. **High Priority Only**
   - Filter: `priority:high`
   - Shows only urgent tasks

2. **My Tasks**
   - Filter: `assignee:@me`
   - Your personal todo list

3. **Blocked Tasks**
   - Filter: `status:blocked`
   - Quick view of bottlenecks

---

## Daily Workflow

### Morning Routine

1. **Review Project Board**
   - Check "In Progress" - finish these first
   - Check "Blocked" - anything unblocked?
   - Pick 1-3 tasks from "Todo" for today

2. **Update Task Status**
   - Move tasks you'll work on today to "In Progress"
   - Add comments on overnight thoughts/blockers

### During Work

3. **Update as You Go**
   - Check off sub-tasks in issue descriptions
   - Add notes/comments with progress
   - Move to "Done" when complete

### Evening Routine

4. **End of Day Review**
   - What did you complete?
   - What's still in progress?
   - Any new tasks discovered?
   - Plan tomorrow's 1-3 tasks

---

## Launch Day Special

### Set Up Launch Dashboard

1. **Pin Important Issues**
   - Pin the main tracking issue
   - Pin launch day task issue
   - Pin any critical bugs

2. **Create Launch View**
   - New view: "Launch Day"
   - Filter: `label:launch status:todo,in-progress`
   - Sort by priority
   - Keep this open all day

3. **Mobile Access**
   - Install GitHub mobile app
   - Access project on-the-go
   - Update status from anywhere

---

## Example Project Structure

```
Signal v1.0 Launch
├── 📋 Todo (5)
│   ├── #1 - 📸 Create launch screenshots [High]
│   ├── #2 - ⚙️ Test CI workflows [High]
│   ├── #3 - 📝 Review documentation [Medium]
│   ├── #4 - 🎥 Record demo videos [Low]
│   └── #5 - 📢 Prepare social posts [High]
│
├── 🏃 In Progress (2)
│   ├── #6 - 🔧 Set up GitHub Discussions [Medium]
│   └── #7 - 📋 Update README [Medium]
│
├── ✅ Done (3)
│   ├── #8 - ⚙️ Create CI workflows
│   ├── #9 - 📝 Write CONTRIBUTING.md
│   └── #10 - 🔧 Add issue templates
│
└── 🚫 Blocked (1)
    └── #11 - 🚀 Launch day execution [Depends on: #1, #2]
```

---

## Tips & Best Practices

### Do's ✅

- **Keep it updated** - Stale projects are useless
- **Use automation** - Auto-move issues based on status
- **Add notes** - Context helps future you
- **Celebrate progress** - Check off tasks as you go!
- **Link related items** - Use issue references (#123)

### Don'ts ❌

- **Don't create too many tasks** - Keep it manageable (20-30 max)
- **Don't over-complicate** - Simple is better
- **Don't ignore blockers** - Address them early
- **Don't work on too many things** - Focus on 1-3 at a time
- **Don't forget to update** - 5 min daily keeps it useful

---

## Automation Ideas

### GitHub Actions (Advanced)

You can automate project updates:

```yaml
# Auto-move to "In Progress" when PR is opened
- name: Update project
  if: github.event_name == 'pull_request'
  run: gh project item-edit --status "In Progress"
```

### Built-in Automation

1. **Auto-add items**
   - Settings → Workflows
   - "Auto-add to project" when issue created with label

2. **Auto-move items**
   - "Move to Done" when issue closed
   - "Move to In Progress" when PR opened

---

## Alternative: Simple Tracking Issue

If GitHub Projects feels like overkill, use a simple tracking issue:

1. **Create one main issue** with all tasks as checkboxes
2. **Update checkboxes** as you complete tasks
3. **Add comments** with progress updates
4. **GitHub shows progress** automatically: `[===> ] 45%`

See `.github/LAUNCH_TRACKING_ISSUE.md` for a ready-to-use template!

---

## Resources

- **GitHub Projects Docs**: https://docs.github.com/en/issues/planning-and-tracking-with-projects
- **Project Templates**: https://github.com/orgs/community/projects
- **Best Practices**: https://github.blog/2022-07-27-planning-next-to-your-code-github-projects-is-now-generally-available/

---

## Questions?

If you need help setting up your project:
- Check GitHub's project documentation
- Ask in GitHub Community Discussions
- Or just start simple with a tracking issue!

---

**Ready to track your launch? Let's go!** 🚀

**Perception, engineered.** 🎨✨
