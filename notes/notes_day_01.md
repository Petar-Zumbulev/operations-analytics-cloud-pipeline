# Day 1 Notes — Project Setup

## Main Goal

Set up the foundation for the Operations Analytics & Cloud Data Pipeline project.

## What I Created

-   Local project folder
-   Git repository with `git init`
-   Basic Day 1 project files:
    -   `README.md`
    -   `requirements.txt`
    -   `.gitignore`
    -   `notes/notes_day_01.md`
-   Initial project documentation

## Why This Matters

A clean project setup makes the project easier to understand, maintain, and present to employers.

Real data jobs require more than writing analysis code. They also require:

-   Clear folder structure
-   Reproducible setup
-   Documentation
-   Version control with Git
-   Clean project organization

This project should look like a serious portfolio project, not just a random collection of scripts.

## Project Positioning

This project is an operations analytics and cloud data pipeline case study.

It uses a realistic marketplace/e-commerce business case to practice:

-   Python data cleaning
-   SQL analytics
-   Data quality checks
-   KPI reporting
-   Forecasting and predictive modeling
-   AWS/cloud basics
-   GitHub portfolio documentation

## Target Roles This Project Supports

-   Data Analyst
-   BI Analyst
-   Analytics Engineer
-   Junior Data Engineer
-   Operations Analyst
-   Applied Data Scientist

## Tools Used Today

-   Git
-   Git Bash
-   VS Code
-   Markdown
-   Python

## Important Git Concepts From Today

### git init

Initializes a local Git repository in the current folder.

This creates the hidden `.git/` folder, where Git stores commits, history, branches, and tracking information.

### git status

Shows the current state of the repository.

It tells me:

-   Which files are untracked
-   Which files are staged
-   Which files are modified
-   Whether the working tree is clean

### git remote -v

Shows whether the local project is connected to a remote GitHub repository.

If it shows nothing, the local project is not connected to GitHub yet.

### .gitkeep

A `.gitkeep` file is an empty placeholder file.

Git does not track empty folders, so `.gitkeep` can be used when I want GitHub to show an empty folder before real files exist inside it.

For now, I do not need to create `.gitkeep` files unless I specifically want GitHub to show empty folders.

## Important Terminal Concepts From Today

### mkdir

Creates a new folder.

Example:

-   `mkdir notes`

This creates a folder called:

-   `notes/`

### mkdir -p

Creates folders safely.

The `-p` means:

-   Create parent folders if needed
-   Do not show an error if the folder already exists

Example:

-   `mkdir -p data/raw`

This creates:

-   `data/`
-   `data/raw/`

Even if `data/` does not exist yet.

Another example:

-   `mkdir -p data/raw data/interim data/processed`

This creates:

-   `data/raw/`
-   `data/interim/`
-   `data/processed/`

### touch

Creates an empty file.

Example:

-   `touch README.md`

This creates an empty file called:

-   `README.md`

## Day 1 Files

The main files for Day 1 are:

-   `README.md`
-   `requirements.txt`
-   `.gitignore`
-   `notes/notes_day_01.md`

## Day 1 Git Commands

Commands used or planned today:

-   `git init`
-   `git status`
-   `git add .`
-   `git commit -m "Initialize project structure for day 1"`
-   `git status`

The final `git status` should say:

-   `nothing to commit, working tree clean`

## Reflection

Today I started the Operations Analytics & Cloud Data Pipeline project.

The main goal was not to do analysis yet, but to set up the project professionally.

This matters because a clean GitHub project should show employers that I can organize technical work clearly and reproducibly.

# Useful git commands

instead of typing

cd p cd operations...

just do

cd p/operations-analytics-cloud-pipeline

and it goes to the directory at once

type "code ." in git bash to open the whole directory in VS Code, useful

# Virtual Environments

-   it is a seperate Python workspace for a certain project

if you dont work on a virtual environment, all your packages get installed onto your general computer Python

a virtual environment allows your project to have its own isolated package folder this is the .venv/ that exists in your project folder

when we install:

pandas numpy scikit-learn jupyter statsmodels

they belong to this project’s .venv, not your whole computer

Why?

different projects may need different packages.

Example:

Operations pipeline project: pandas, scikit-learn, statsmodels, SQLAlchemy Old R/Shiny project: mostly R packages Future ML project: PyTorch, TensorFlow, transformers Small script: maybe only pandas

so as you can see, each project has its own packages and its own versions of packages!

The virtual environment prevents package conflicts and makes the project reproducible

The professional workflow:

Project folder → .venv → requirements.txt → GitHub repo

You create the virtual environment only once per project:

python -m venv .venv

After that, the .venv folder stays inside the project.

However, you have to activate the virtual environment every time you open a fresh terminal!

how to activate: source .venv/Scripts/activate

Then you should see:

(.venv)

That tells you: I am now using the project Python environment.

Check 1: Look for (.venv)

You want to see this at the beginning of the terminal line:

(.venv) Peter [Enis\@DESKTOP](mailto:Enis@DESKTOP){.email}...

Check 2: Run this which python

When .venv is active, it should show something like:

/p/operations-analytics-cloud-pipeline/.venv/Scripts/python

This means Python is coming from your project.

This means your terminal is using the Python inside your project’s .venv. So yes, you are working inside the virtual environment

terminal with git bash:

ctrl + c

to cancel running process that could be freezing up your terminal

# .gitignore tells Git:

These files/folders exist on my computer, but do not upload/track them in GitHub

The project folder now contains things that should not be committed to GitHub.

Most important:

.venv/

That folder contains the whole virtual environment: installed packages, Python binaries, caches, etc.

It can become huge and messy. You do not upload .venv/ to GitHub.

Instead, you upload:

requirements.txt

That file says which packages are needed. So another person can recreate the environment with:

pip install -r requirements.txt

Simple example

Bad GitHub repo:

project/ ├── .venv/ ❌ huge local environment ├── data/raw/*.csv ❌ maybe big/private generated files ├── outputs/*.xlsx ❌ generated reports ├── **pycache**/ ❌ Python cache garbage └── src/

Good GitHub repo:

project/ ├── requirements.txt ✅ package list ├── src/ ✅ your code ├── README.md ✅ explanation ├── notes/ ✅ learning/project notes ├── sql/ ✅ SQL work └── data/raw/.gitkeep ✅ keeps empty folder structure

# src

stands for source

source code

where my python scripts go



# Is there a VS Code equivalent of .Rproj?

Kind of, but not exactly.

Your .Rproj file is an RStudio project file. It tells RStudio: “This folder is a project.”

VS Code usually does not need a special project file. In VS Code, the folder itself becomes the project when you open it with:

code .

or when you open the folder manually:

File → Open Folder

.Rproj is useful for RStudio.
VS Code does not need an equivalent yet.
Opening the folder in VS Code is enough.


You seem to have two history files:

.Rhistory
notes/.Rhistory

They are not necessarily the same. The one inside notes/ may have been created because R or RStudio was opened while the working directory was notes/.

Day 1 is done.

You completed the real setup work:

- Created the project folder
-  Initialized Git
-  Created the GitHub repo
-  Connected local repo to GitHub with SSH
-  Made the initial push
-  Created README.md
-  Created .gitignore
-  Created requirements.txt
-  Created notes/notes_day_01.md
-  Added extra Git/VS Code setup notes
-  Created basic folders: data/, notes/, src/
-  Set up/activated the Python virtual environment
- created a local LICENSE file thats synched to GitHub