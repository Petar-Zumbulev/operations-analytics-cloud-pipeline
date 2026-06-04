# VS Code + Python Virtual Environment Setup Summary

## Project

Repo/project folder:

```text
operations-analytics-cloud-pipeline
```

Main goal of setup:

```text
Use VS Code + Git Bash + project-local .venv for a clean Python, SQL, GitHub, and cloud/data-pipeline workflow.
```

This setup is better for long-term data analyst / analytics engineer / data engineering work than relying only on Spyder or Anaconda.

---

# 1. Tool decision

## Main tool

```text
VS Code
```

## Terminal

```text
Git Bash
```

## Python environment style

```text
Project-local .venv
```

## Keep

```text
VS Code
Git / Git Bash
RStudio
Positron
Normal Python from Python.org
```

## Optional / removed

```text
PyCharm: optional, not needed right now
Anaconda: not needed for this project workflow
Spyder: optional backup only, not main workflow
```

---

# 2. Important concepts

## IDE / editor

Where I write code.

Examples:

```text
VS Code
PyCharm
Spyder
Positron
RStudio
```

For this project:

```text
VS Code
```

## Terminal

Where I type commands.

Examples:

```text
Git Bash
PowerShell
Command Prompt
VS Code integrated terminal
```

For this project:

```text
Git Bash
```

## Python interpreter

The actual Python executable that runs the code.

Example system Python:

```text
/c/Users/Peter Enis/AppData/Local/Programs/Python/Python313/python
```

Example project Python:

```text
/p/operations-analytics-cloud-pipeline/.venv/Scripts/python
```

## Virtual environment

A project-specific Python environment.

It keeps this project’s Python packages separate from the rest of the computer.

Project structure:

```text
operations-analytics-cloud-pipeline/
├── .venv/
├── src/
├── notebooks/
├── sql/
├── notes/
├── README.md
└── requirements.txt
```

`.venv/` stays on my computer.

`requirements.txt` goes to GitHub.

---

# 3. Why we use `.venv`

Without `.venv`, packages get installed globally and can create conflicts.

With `.venv`, each project has its own packages.

Example:

```text
Project A: pandas, scikit-learn, statsmodels
Project B: PyTorch, transformers
Project C: small script with only requests
```

The professional workflow is:

```text
Project folder
→ .venv
→ requirements.txt
→ GitHub repo
```

---

# 4. Git Bash vs PowerShell

## Git Bash

Git Bash shows something like:

```text
MINGW64
```

Example:

```text
Peter Enis@DESKTOP... MINGW64 /p/operations-analytics-cloud-pipeline
```

This is what I want to use for this project.

## PowerShell

PowerShell shows something like:

```text
PS P:\operations-analytics-cloud-pipeline>
```

PowerShell is okay, but commands can be different. For consistency, use Git Bash.

---

# 5. Check Python before setup

In Git Bash:

```bash
python --version
which python
```

Good result:

```text
Python 3.13.1
/c/Users/Peter Enis/AppData/Local/Programs/Python/Python313/python
```

This means normal Python is installed and working.

If it showed Anaconda, it would look something like:

```text
/c/Users/Peter Enis/anaconda3/python
```

---

# 6. Clean VS Code reinstall

## Uninstall VS Code

Windows:

```text
Settings
→ Apps
→ Installed apps
→ Microsoft Visual Studio Code (User)
→ Uninstall
```

Important:

```text
Microsoft Visual Studio Code (User) = correct VS Code app
Microsoft Visual Studio 2010 Tools for Office Runtime = unrelated, do not uninstall
```

## Delete old VS Code settings

Open:

```text
Win + R
%APPDATA%
```

Delete:

```text
Code
```

Open:

```text
Win + R
%USERPROFILE%
```

Delete:

```text
.vscode
.vscode-R
```

`.vscode-R` is only old VS Code R extension data. It does not delete RStudio or R projects.

---

# 7. Reinstall VS Code

Download:

```text
Windows User Installer x64
```

During installation, check:

```text
Add to PATH
Add "Open with Code" action to Windows Explorer file context menu
Add "Open with Code" action to Windows Explorer directory context menu
Register Code as an editor for supported file types
```

At the welcome screen:

```text
Continue without Signing in
```

Reason:

```text
Cleaner setup first. GitHub/Google sign-in is optional later.
```

---

# 8. Verify VS Code from Git Bash

Open a new Git Bash window:

```bash
code --version
```

Then open the project:

```bash
cd /p/operations-analytics-cloud-pipeline
code .
```

---

# 9. Install only needed VS Code extensions

Install only these first:

```text
Python by Microsoft
Jupyter by Microsoft
```

Do not install many extensions at the beginning.

If VS Code recommends the R extension, ignore it for now.

---

# 10. Set VS Code terminal to Git Bash

In VS Code:

```text
Ctrl + Shift + P
Terminal: Select Default Profile
Git Bash
```

Then:

```text
Terminal → New Terminal
```

Correct terminal should show:

```text
MINGW64 /p/operations-analytics-cloud-pipeline
```

Check current folder:

```bash
pwd
```

Expected:

```text
/p/operations-analytics-cloud-pipeline
```

List project files:

```bash
ls
```

Important: `ls` is lowercase L + lowercase s.

Not:

```text
Is
```

---

# 11. Create the virtual environment

Only once per project:

```bash
python -m venv .venv
```

This creates:

```text
.venv/
```

inside the project folder.

---

# 12. Activate the virtual environment

Every time I open a new terminal for this project, activate it:

```bash
source .venv/Scripts/activate
```

After activation, I should see:

```text
(.venv)
```

near the beginning of the terminal prompt.

Example:

```text
(.venv) Peter Enis@DESKTOP... MINGW64 /p/operations-analytics-cloud-pipeline
```

---

# 13. Confirm the virtual environment is active

Run:

```bash
which python
```

Good result:

```text
/p/operations-analytics-cloud-pipeline/.venv/Scripts/python
```

This means Python is coming from the project environment.

Bad result:

```text
/c/Users/Peter Enis/AppData/Local/Programs/Python/Python313/python
```

This means I am using system Python, not the project `.venv`.

If I see the bad result, run:

```bash
source .venv/Scripts/activate
```

---

# 14. Upgrade pip inside `.venv`

Only after `.venv` is active:

```bash
python -m pip install --upgrade pip
```

If VS Code shows a popup saying packages may be installed globally, ignore it if the terminal shows:

```text
(.venv)
```

To double-check:

```bash
which pip
```

Good result:

```text
/p/operations-analytics-cloud-pipeline/.venv/Scripts/pip
```

---

# 15. Install project packages

Only after `.venv` is active:

```bash
pip install pandas numpy matplotlib seaborn scikit-learn statsmodels jupyter ipykernel openpyxl sqlalchemy python-dotenv
```

These packages are for:

```text
pandas           data cleaning and analysis
numpy            numerical operations
matplotlib       plotting
seaborn          statistical plots
scikit-learn     machine learning
statsmodels      statistics / forecasting basics
jupyter          notebooks
ipykernel        notebook kernel support
openpyxl         Excel export/import
sqlalchemy       database connection workflows
python-dotenv    environment variables / secrets handling
```

---

# 16. Save packages to `requirements.txt`

After installing packages:

```bash
pip freeze > requirements.txt
```

Check file:

```bash
cat requirements.txt
```

Expected: many package lines, for example:

```text
pandas==...
numpy==...
scikit-learn==...
matplotlib==...
```

Important:

```text
requirements.txt records the package list.
.venv/ contains the actual installed packages.
```

GitHub gets:

```text
requirements.txt
```

GitHub does not get:

```text
.venv/
```

Another person can recreate the environment with:

```bash
pip install -r requirements.txt
```

---

# 17. Test the environment

Run:

```bash
python -c "import pandas, numpy, sklearn, statsmodels; print('Environment works')"
```

Expected:

```text
Environment works
```

---

# 18. Select `.venv` interpreter in VS Code

In VS Code:

```text
Ctrl + Shift + P
Python: Select Interpreter
```

Choose:

```text
.venv/Scripts/python.exe
```

This tells VS Code to use the project Python environment.

---

# 19. `.gitignore`

`.gitignore` tells Git:

```text
These files exist on my computer, but do not track/upload them to GitHub.
```

Important things to ignore:

```text
.venv/
Python cache files
secret .env files
large/generated CSV data
generated reports/outputs
local VS Code and RStudio settings
```

Recommended `.gitignore`:

```gitignore
# Python virtual environments
.venv/
venv/
env/

# Python cache files
__pycache__/
*.py[cod]
*$py.class

# Jupyter notebooks
.ipynb_checkpoints/

# Environment variables and secrets
.env
.env.local

# Logs
*.log
logs/

# OS files
.DS_Store
Thumbs.db

# VS Code local settings
.vscode/

# RStudio local project files
.Rproj.user/

# Generated data files
data/raw/*.csv
data/interim/*.csv
data/processed/*.csv
data/external/*.csv

# Keep folder structure
!data/raw/.gitkeep
!data/interim/.gitkeep
!data/processed/.gitkeep
!data/external/.gitkeep

# Generated outputs
outputs/figures/*
outputs/tables/*
outputs/excel/*

# Keep output folder structure
!outputs/figures/.gitkeep
!outputs/tables/.gitkeep
!outputs/excel/.gitkeep
```

---

# 20. Why `.gitkeep` exists

Git does not track empty folders.

So we add `.gitkeep` files to keep folder structure visible on GitHub.

Example:

```text
data/raw/.gitkeep
data/interim/.gitkeep
data/processed/.gitkeep
outputs/figures/.gitkeep
outputs/tables/.gitkeep
outputs/excel/.gitkeep
```

`.gitkeep` is just an empty placeholder file.

---

# 21. Check Git status before committing

Run:

```bash
git status
```

or shorter:

```bash
git status --short
```

Important:

```text
.venv/ should NOT appear.
```

If `.venv/` appears, fix `.gitignore` before committing.

---

# 22. Add and commit

After confirming `.venv/` is ignored:

```bash
git add .
```

Check:

```bash
git status --short
```

Commit:

```bash
git commit -m "Initialize operations analytics project setup"
```

After commit:

```bash
git status
```

Good result:

```text
nothing to commit, working tree clean
```

---

# 23. Normal workflow when starting work

Every time I start working on this project:

```bash
cd /p/operations-analytics-cloud-pipeline
source .venv/Scripts/activate
which python
```

Good result:

```text
/p/operations-analytics-cloud-pipeline/.venv/Scripts/python
```

Then I can run scripts, install packages, or use Git.

---

# 24. Normal Git workflow

After making changes:

```bash
git status
git add .
git commit -m "Describe what changed"
git push
```

For the first push to GitHub after connecting remote:

```bash
git push -u origin main
```

After that:

```bash
git push
```

---

# 25. Terminal troubleshooting

If terminal feels frozen:

```text
Ctrl + C
```

This cancels the current running command.

In terminals:

```text
Ctrl + C = cancel/interrupt command
```

It does not copy text.

If the terminal still feels broken:

```text
Click trash can icon in VS Code terminal
Terminal → New Terminal
source .venv/Scripts/activate
```

---

# 26. Key mental model

## Files that stay local

```text
.venv/
.env
cache files
generated CSV files
generated outputs
local editor settings
```

## Files that go to GitHub

```text
README.md
requirements.txt
.gitignore
src/
sql/
notebooks/
notes/
reports/
docs/
aws/
interview/
.gitkeep files
```

## Most important command chain

```bash
cd /p/operations-analytics-cloud-pipeline
python -m venv .venv
source .venv/Scripts/activate
which python
python -m pip install --upgrade pip
pip install pandas numpy matplotlib seaborn scikit-learn statsmodels jupyter ipykernel openpyxl sqlalchemy python-dotenv
pip freeze > requirements.txt
python -c "import pandas, numpy, sklearn, statsmodels; print('Environment works')"
git status
git add .
git commit -m "Initialize operations analytics project setup"
```

---

# 27. Summary

What I accomplished:

```text
Installed VS Code cleanly
Set Git Bash as the terminal
Confirmed normal Python works
Created project-local .venv
Activated .venv
Installed core Python data packages
Saved packages to requirements.txt
Prepared .gitignore so .venv and generated files are not uploaded
Learned how to check if the correct Python environment is active
Prepared the repo for a clean Day 1 commit
```

Most important thing to remember:

```text
Use VS Code for editing.
Use Git Bash for commands.
Activate .venv before Python work.
Commit requirements.txt, not .venv.
```