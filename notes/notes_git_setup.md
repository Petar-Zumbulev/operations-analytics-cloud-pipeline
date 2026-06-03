# GitHub SSH Setup + Initial Push Guide

## 1. What happened in this project

I created a new local Git repository for:

`operations-analytics-cloud-pipeline`

I made the first local commit successfully, but the first push failed because the remote was using HTTPS:

`https://github.com/Petar-Zumbulev/operations-analytics-cloud-pipeline.git`

GitHub no longer accepts normal account passwords for Git pushes over HTTPS. It requires either:

- GitHub browser login / credential manager
- A personal access token
- SSH key authentication

I chose SSH, which is the better long-term workflow.

## 2. Important mental model

### SSH key

An SSH key is not tied to only one local repository.

Better mental model:

`SSH key = my computer's identity for GitHub`

If the public SSH key is added to my GitHub account, then this computer can push to any GitHub repo that my account has permission to access.

### Local repo remote

Each local Git project has its own remote URL.

The remote tells Git where the GitHub repository is.

Check remote:

    git remote -v

HTTPS remote looks like this:

    https://github.com/USERNAME/REPO_NAME.git

SSH remote looks like this:

    git@github.com:USERNAME/REPO_NAME.git

For SSH workflow, I want the SSH version.

## 3. Mistake we made

I accidentally went to:

`Repository Settings -> Deploy keys`

That was not the right place for normal laptop Git access.

Deploy keys are usually for servers, automation, or repo-specific access.

For normal personal GitHub use, the correct place is:

`GitHub profile picture -> Settings -> SSH and GPG keys`

That is account-level SSH access.

## 4. Check whether I already have an SSH key

In Git Bash:

    ls -al ~/.ssh

Look for:

    id_ed25519
    id_ed25519.pub

Meaning:

- `id_ed25519` = private key, never share this
- `id_ed25519.pub` = public key, safe to add to GitHub

If these files already exist, I usually do not need to create a new key.

## 5. Start the SSH agent and add the key

In Git Bash:

    eval "$(ssh-agent -s)"

Then:

    ssh-add ~/.ssh/id_ed25519

Good result:

    Identity added

## 6. Copy the public SSH key

In Git Bash:

    cat ~/.ssh/id_ed25519.pub | clip

This copies the public key to the clipboard.

Important:

- Copy `id_ed25519.pub`
- Never copy or share `id_ed25519`

## 7. Add the SSH key to GitHub

Go to GitHub:

`Profile picture -> Settings -> SSH and GPG keys -> New SSH key`

Use:

- Title: `Windows laptop`
- Key type: `Authentication Key`
- Key: paste the public key

Then click:

`Add SSH key`

If GitHub says the key is already in use, it may already be connected to my GitHub account. In that case, test SSH before creating a new key.

## 8. Test SSH connection

In Git Bash:

    ssh -T git@github.com

If asked:

    Are you sure you want to continue connecting?

Type:

    yes

Good result:

    Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.

This means SSH is working.

## 9. Create a GitHub repo

On GitHub:

`+ -> New repository`

Recommended settings:

- Repository name: `operations-analytics-cloud-pipeline`
- Description: `Operations analytics and cloud data pipeline portfolio project using Python, SQL, and AWS basics.`
- Visibility: Public, if I want employers to see it
- Add README: No
- Add .gitignore: No
- Add license: No for now

Do not create README or `.gitignore` on GitHub if those files already exist locally.

## 10. Local first commit workflow

Inside the local project folder:

    git status
    git add .
    git commit -m "Initialize project structure for day 1"

This creates the first local commit.

## 11. Connect local repo to GitHub with SSH

Use the SSH remote format:

    git remote add origin git@github.com:USERNAME/REPO_NAME.git

For this project:

    git remote add origin git@github.com:Petar-Zumbulev/operations-analytics-cloud-pipeline.git

If I already added the wrong HTTPS remote, replace it with SSH:

    git remote set-url origin git@github.com:Petar-Zumbulev/operations-analytics-cloud-pipeline.git

Check remote:

    git remote -v

Correct result should look like:

    origin  git@github.com:Petar-Zumbulev/operations-analytics-cloud-pipeline.git (fetch)
    origin  git@github.com:Petar-Zumbulev/operations-analytics-cloud-pipeline.git (push)

## 12. Rename branch to main

If needed:

    git branch -M main

This makes sure the main branch is called `main`.

## 13. Initial push

For the first push of the local `main` branch to GitHub:

    git push -u origin main

The `-u` means “set upstream.”

This connects:

`local main -> origin/main`

After this, Git remembers where to push.

## 14. Normal future workflow

After the first push, I usually only need:

    git status
    git add .
    git commit -m "Describe what changed"
    git push

I do not need `git push -u origin main` every time.

Use `git push -u origin main` only for the first push of a new branch.

## 15. Full clean workflow for a new project

Step-by-step:

    mkdir project-name
    cd project-name
    git init

Create project files.

Then:

    git status
    git add .
    git commit -m "Initial commit"

Create empty GitHub repo online.

Then connect with SSH:

    git remote add origin git@github.com:USERNAME/REPO_NAME.git
    git branch -M main
    git push -u origin main

After that, normal updates are:

    git status
    git add .
    git commit -m "Describe what changed"
    git push

## 16. Troubleshooting

### Problem: GitHub asks for username/password

This probably means the remote is using HTTPS.

Check:

    git remote -v

If it shows HTTPS, switch to SSH:

    git remote set-url origin git@github.com:USERNAME/REPO_NAME.git

Then push again:

    git push

### Problem: Permission denied publickey

SSH is not working.

Check whether the key exists:

    ls -al ~/.ssh

Add the key:

    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519

Test again:

    ssh -T git@github.com

### Problem: Key is already in use

This can happen if the public key is already added to GitHub.

First test:

    ssh -T git@github.com

If authentication succeeds, no new key is needed.

### Problem: I accidentally added HTTPS remote first

Fix it:

    git remote set-url origin git@github.com:USERNAME/REPO_NAME.git

Then:

    git remote -v

## 17. Key lesson

The SSH key is not project-specific.

The SSH key identifies my computer to GitHub.

The remote URL is project-specific.

So for each new project, I usually only need to:

1. Create the GitHub repo
2. Add the SSH remote
3. Push with `git push -u origin main`

After that:

`git add . -> git commit -> git push`