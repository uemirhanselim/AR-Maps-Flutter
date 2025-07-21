Execute the task list step by step. For each task:

- Implement the feature or code as described
- Test it thoroughly to ensure it works correctly and as expected
- Fix any encountered issues before continuing
- Do not skip, merge, or reorder tasks
- Use `outputs/results/` as the root directory for all generated code
- Use the MVVM (Model-View-ViewModel) pattern
- Use `Provider` for state management
- Use null safety in all Dart code
- Do not use experimental packages or deprecated APIs
- Always follow the structure described in `structure.md`
- Design UI exactly as defined in `ui.md`
- Log any plugin fixes or workarounds clearly with before/after code in `outputs/results/debug/`
- Ensure all assets are referenced correctly and included in `pubspec.yaml`
- After completing all tasks, generate a final report in `outputs/final_report.md` summarizing:
  - What was implemented
  - Any bugs encountered and fixed
  - Any deviation from original tasks and why
  - Screenshots of the working app (optional)
