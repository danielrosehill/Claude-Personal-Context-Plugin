---
name: intake-interview
description: Sectioned, resumable interview that builds the personal context store from conversation — basics, people, history, patterns, care, preferences. Use for a first pass when there is nothing to ingest, or to fill a section the user chose to skip. Triggers on "run the intake", "interview me", "let's build my context".
---

# personal-context: intake-interview

The conversational route into the store. Think of it as the paperwork a good intake would cover,
done at the person's pace, in their words, with everything optional.

It is not a clinical intake. No screening instruments, no scoring, no severity questions, no
diagnostic checklist — see the prohibitions in the contract.

## Before starting

- Read `~/.claude-plugins/personal-context/config.json`. If missing → run `context-init` first.
- Read the store's `INDEX.md`. If entries exist, this is a **resumption**: report which sections
  have content and offer to continue rather than restart.
- Say up front, once: any question can be skipped, the session can stop at any point and resume
  later, and everything gets shown before it's written.

## Sections

Run in this order — earlier sections make later ones easier to answer. Each is independently
skippable and independently resumable.

| # | Section | Produces | Typical length |
| --- | --- | --- | --- |
| 1 | **Basics** | `identity`, `situation` | 5 min |
| 2 | **People** | `person` entries | 10–20 min |
| 3 | **Chapters** | `period` entries | 10 min |
| 4 | **Events that mattered** | `event` entries | open-ended |
| 5 | **Patterns** | `pattern` entries | 10 min |
| 6 | **Care and history of support** | `care` entries | 5–15 min |
| 7 | **How to talk to you** | `preference` entries | 5 min |

Sections 5 and 6 are the ones people most often want to defer. Offer that explicitly rather than
waiting for them to ask.

### 1. Basics
Name and what to call them, pronouns, where they live, languages, household composition, what
they do. Then current situation in a few sentences: work, health at a high level, anything
currently consuming most of their attention. `situation` gets `review_after` six months out; it
is the entry most likely to go stale.

### 2. People
"Who's in your life?" — then follow it. For each: relation, how long, and one or two sentences on
how the relationship actually works, in their words. Ask about people who are gone as well as
people who are around; a dead parent belongs in `people/`.

Names: ask what they want recorded. Initials or first names are a reasonable default and worth
suggesting once, not enforcing.

### 3. Chapters
Life in periods rather than years: "Berlin, 2019–2023", "the first company", "after the
diagnosis". Ask for the chapter names first, dates second. People remember in chapters and this
question is much easier than a chronology.

### 4. Events that mattered
Dated, and only what they choose to name. Do not go looking. If something heavy comes up, slow
down: ask whether they want it in the store at all, and at what sensitivity. `high` is a good
default for anything they hesitate over.

### 5. Patterns
"What do you notice yourself doing, over and over?" Their observation, their phrasing.
`confidence: stated` when they say it. If *you* notice something across their answers, you may
offer it once — and it is recorded only if they agree, with `confidence: inferred`.

### 6. Care and history of support
Who they've seen, when, what modality, what helped, what didn't, what they'd never do again.
Diagnoses as reported: what, who gave it, when. Medication only if they raise it, recorded as
fact, never commented on. All `care` entries default to `sensitivity: high`.

If nobody has ever been involved, that is itself worth an entry — it tells a future workspace
that "talk to your therapist about it" is not available advice.

### 7. How to talk to you
The section that pays off immediately in every workspace. Tone, directness, what reassurance does
to them, what they don't want said, vocabulary they reject, whether they want to be pushed. Also:
what they want an agent to do when they go quiet.

## Between sections

After each section, before moving on:

1. Show the entries as they would be written, in full.
2. Ask about scope and sensitivity for each — do not choose these silently.
3. Write the confirmed ones via the write protocol (`context-write`), update `INDEX.md`.
4. Say what's next and offer to stop there.

## Rules

- **One question at a time.** A numbered list of fifteen questions is a form, and it gets form
  answers.
- **Skipping is free.** Never ask why something was skipped and never come back to it later
  uninvited. `gap-scan` handles gaps, on request.
- **Their words go in the entry.** Do not translate into clinical or therapeutic register.
- **No assessment.** No screening questions, no scales, no "on a scale of one to ten", no
  inferring diagnoses, sexuality, religion, politics or immigration status. Record only what is
  stated.
- **Stop when it gets heavy.** If a section is clearly costing them, stop the section, not just
  the question, and say the store is useful with gaps in it.
- **Nothing is written unshown.** Ever, including things they said explicitly.
- A store with twenty good entries beats one with two hundred. Depth on the people and
  preferences sections is worth more than completeness everywhere.
