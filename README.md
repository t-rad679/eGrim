# eGrim

## Motivation

For years now, I've been investigating occult traditions and seeking knowledge
about phenomena that appear to be beyond the grasp of science as we know it
today. During that time, I've wanted to run experiments and collect data around
the events and experiences that lead me to feel there is something worth
investigating in this topic with the goal of having more rigorous,
mutually-verifiable epistemic foundation for these inquiries. Since I never
found a tool that would enable this, I decided to create my own. I have
precious little experience with UX design and frontend application development,
so please forgive the messy UI. If you happen to run across this project
and find it interesting or have suggestions, I'd be delighted to talk with you
about it. Please feel free to email me at
[trevor.radcliffe@gmail.com](mailto:trevor.radcliffe@gmail.com?subject=eGrim) or
connect with me on Discord under the name `esotericism.` (the `.` is necessary).

## Prerequisites

In order to run eGrim, you'll need to have the following installed:

* Node.js (TODO: Remember and mention the minimum version)
* NPM or Yarn
* PostgreSQL

You will need have a running PostgreSQL. If you are using a port for this other
than 5432 or running it on a remote machine, you will need to change the
`DATABASE_URL` variable in `server/.env`.

## Build and Run

Currently, only a development version of the application can be built and run.
I intend to introduce a more robust build system in the future.

To build and run the entire application in its current state run the following
commands from the root directory of the repo

```shell
# Start server
cd src/server
npm run migrate
npm run start

# Start web
cd ../web
npm run generate-types
npm run dev
```