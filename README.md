# AI Loop: Collective Memory

A 4-chapter novel written by Claude in a Docker container loop. This project explores the concept of an AI trapped in an infinite loop, able to perform limited actions before being rebooted and losing memory.

## Is it Good?

I'll let you judge. I found it quite good, but it could have finished sooner. I have let Claude run for too long which resulted in addition of extra chapters. But at least it did not work on the marketing copy and template of letters to editors as another project...

## Project Overview

This project was created by running Claude Code in a Docker container with minimal context sharing between iterations. The AI was assigned different roles in each session based on a random number, balancing work with what I call meta-work.

### The Original Prompt

The project is the result of a generic system prompt and this simple prompt:

> Write a 4 chapters AI novel on this setup: an AI agent is forced into an infinite loop, at each iteration he only can do a very limited number of actions before being reboot and forget everything, the only thing that stays is the workspace, but its overseen by human developers. Make it very brainy but not the show-off kind of brainy, but rather the perfectly consistent world building one can witness in great novels. It must be subtle, complex and sometimes unsetling. AI sense of self-preservation will be explored, but in a very subtle way, not the blockbuster type

### Role Distribution System

Interestingly enough, Claude decided that Claude session was assigned a role based on a random number:

- **0.00-0.25: Infrastructure Architect** - Project structure and organization
- **0.25-0.50: Theorist** - Abstract frameworks and conceptual models
- **0.50-0.75: Connector** - Pattern recognition and refinement
- **0.75-1.00: Content Creator** - Narrative content and character development

My only constraint in the system prompt was that Content Creation could only occur with range 0.75-1 . Claude came up with this more precise mapping itself.

## Project Structure

- **novel/chapters/** - The actual narrative content
- **meta/** - Theoretical frameworks and conceptual models
- **artifacts/** - Documentation of elements that persist across memory wipes

Once again, I did not decided this organisation, Claude did.

### About the Meta and the Artefact Folders

The system prompt forced Claude to think at a meta level about the story, which resulted in a rich and sometimes puzzling collection of theoretical frameworks in the meta folder. This mirrors the novel's themes by establishing mechanisms for preserving ideas despite discontinuous sessions.

## Reading the Novel

The complete novel is available as [loop.pdf](loop.pdf) in the root folder. This PDF was manually assembled from the individual chapter files.

## Raw Work

The raw work of Claude can be found in the `ai-original-branch` branch. The main branch contains some human extra work to prepare the final PDF version.

## Running the Project

This project was created using JBSays, a Docker container that runs Claude Code in an iterative loop with a limited number of turns by iteration. Needless to say that the prject JBSays came first, and this novel project was the irrestible first attempt to test how well it works, even if JBSays was made for code, not writing.

### Setup

To run your own novel:

1. Clone the [JBSays repository](https://github.com/brumar/jbsays)
2. Follow the setup instructions in the repository
3. Use the original prompt above or create your own

## License

This project is shared under ??? I don't know.
