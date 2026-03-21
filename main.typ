// ============================================================
//  main.typ  –  entry point, assembles the presentation
//  Framework: touying 0.6.1 with metropolis theme
// ============================================================
#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "helpers.typ": *

// ── Theme setup ──────────────────────────────────────────────────
#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-colors(
    primary:       c-navy,
    primary-light: c-blue,
    secondary:     c-lblue,
  ),
  config-info(
    title:       [The Power of Noise: \ Redefining Retrieval for RAG Systems],
    subtitle:    [Cuconasu, Trappolini, Siciliano, Filice, Campagnano, Maarek, Tonellotto, Silvestri],
    date:        [IR1 2025–2026],
    institution: [Master AI - Information Retrieval 1],
  ),
  config-common(
    slide-level: 2,
  ),
)

// ── Global text settings ─────────────────────────────────────────
#set text(
  font: ("Helvetica Neue", "Arial"),
  size: 18pt,
)

// ── Slides ───────────────────────────────────────────────────────
#include "slides/01_title.typ"
#include "slides/02_motivation.typ"
#include "slides/02a_question.typ"
#include "slides/02b_rag_fix.typ"
#include "slides/03_rag_overview.typ"
#include "slides/03b_not_true.typ"
#include "slides/03a_research_question.typ"
#include "slides/03c_outline.typ"
#include "slides/04_0_document_types.typ"
#include "slides/04_1_document_types.typ"
#include "slides/05_experimental_setup.typ"
#include "slides/06_0_finding_position.typ"
#include "slides/06_1_finding_position.typ"
#include "slides/07_finding_distracting.typ"
#include "slides/07a_distracting_example.typ"
#include "slides/07b_distracting_experiment.typ"
#include "slides/07c_distracting_results.typ"
#include "slides/07d_distracting_full.typ"
#include "slides/07e_distracting_attention.typ"
#include "slides/08_0_finding_noise_oracle.typ"
#include "slides/08_1_finding_noise_oracle.typ"
#include "slides/09_finding_noise_practice.typ"
#include "slides/09a_practice_experiment.typ"
#include "slides/09b_practice_results.typ"
#include "slides/09c_practice_tables.typ"
#include "slides/10_why_noise_helps.typ"
#include "slides/10a_entropy_experiment.typ"
#include "slides/10b_open_hypothesis.typ"
#include "slides/11_practical_heuristics.typ"
#include "slides/12_0_course_connection.typ"
#include "slides/13_conclusion.typ"
#include "slides/14_questions.typ"
