# 🚀 Guidelines for ft_transcendence

## 🔀 Branch workflow
Please follow these steps:
1. Create a new branch from the master and name it like: _yourname_branchname_
2. Work on your feature
3. Create a pull request in Github when finished
4. Wait for a review from another team member
5. Merge your branch back into the master


## ⚠️ Issues & ToDo
### New issue/ToDo
When you encounter a problem or missing feature in the code that you can't solve right away, follow these steps:
1. Create an issue in Github
2. Write a clear description of the issue and how to reproduce it (make sure that a team member can start fixing the issue without your help)
3. Add a tag with the type of issue (bug, improvement, feature, etc.)

### Fixing an issue
When you start working on an issue:
1. Assign yourself to the issue, so everyone knows you're working on it
2. Follow the branch workflow
3. Link the issue to the created pull request so it's closed when the pr is merged

## 🛠 Build & Run
The current configuration uses Docker to run the server and db in a container.
The goal is to make it easier to develop on multiple different systems. If it turns out
that it's too slow or too much of a hassle we might have to change this.

Commands:
- Force build and run: docker-compose up --build
- Run: docker-compose up
- Build: docker-compose build
- Attach to the rails container: docker-compose exec web bash

The root directory is mounted to the container so you should be able to develop without restarting the container
all the time. 

### The End
If you find anything that should be added to this guide, please go ahead and add it!