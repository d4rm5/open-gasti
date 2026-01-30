# Gasti Skills - OpenCode Finance Integration

## TL;DR

> **Quick Summary**: Create 4 OpenCode skills for natural language interaction with beancount personal finance system. Skills handle adding transactions, querying data, checking balances, and updating dollar prices.
> 
> **Deliverables**:
> - `.opencode/skills/opengasti-add/SKILL.md` - Add transactions in Spanish
> - `.opencode/skills/opengasti-query/SKILL.md` - Natural language queries
> - `.opencode/skills/opengasti-balance/SKILL.md` - Balance and net-worth views
> - `.opencode/skills/opengasti-prices/SKILL.md` - Blue dollar rate updates
> 
> **Estimated Effort**: Medium (4-6 hours)
> **Parallel Execution**: YES - 3 waves
> **Critical Path**: Task 1 (accounts reference) → Task 2 (opengasti-add) → Task 6 (validation)

---

## Context

### Original Request
Create skills to interact with beancount setup in this folder.

### Interview Summary
**Key Discussions**:
- User wants ALL skills: /add, /query, /balance, /prices
- Skills should work with Spanish natural language input
- Must use `uv run` prefix for all beancount commands

**Research Findings**:
- Existing `skill-creator` skill provides the pattern to follow
- Makefile already has `prices`, `balance`, `net-worth` targets we can wrap
- Account definitions in `config/accounts.bean`
- Pre-configured queries in `config/queries.bean`
- Transaction file pattern: `transactions/YYYY/MM-month.bean`

### Metis Review
**Identified Gaps** (addressed):
- Account hallucination risk: Skills MUST read `config/accounts.bean` first
- File path errors: Use dynamic discovery, not hardcoded month names
- Broken build risk: `opengasti-add` MUST run `make check` after writing
- Pattern reuse: Use existing `make` targets where possible

---

## Work Objectives

### Core Objective
Create 4 OpenCode skills that enable natural language finance management in Spanish for the beancount-based open-gasti system.

### Concrete Deliverables
- `.opencode/skills/opengasti-add/SKILL.md` with `references/accounts.md`
- `.opencode/skills/opengasti-query/SKILL.md` with `references/queries.md`
- `.opencode/skills/opengasti-balance/SKILL.md`
- `.opencode/skills/opengasti-prices/SKILL.md`

### Definition of Done
- [x] `ls .opencode/skills/gasti-*/SKILL.md` returns 4 files
- [x] `uv run bean-check main.bean` passes after skill creation
- [x] Each SKILL.md has valid YAML frontmatter with name and description

### Must Have
- Spanish natural language support for all skills
- `uv run` prefix on ALL beancount commands
- Account grounding from `config/accounts.bean` for opengasti-add
- Validation step (make check) in opengasti-add workflow
- Error handling instructions in each skill

### Must NOT Have (Guardrails)
- Hardcoded month file names (use dynamic discovery)
- Invented account names (must reference accounts.bean)
- Direct `bean-*` commands without `uv run` prefix
- Complex scripts when `make` targets exist
- README.md or other auxiliary documentation files

---

## Verification Strategy (MANDATORY)

### Test Decision
- **Infrastructure exists**: NO (no automated tests for skills)
- **User wants tests**: Manual-only
- **Framework**: N/A
- **QA approach**: Automated verification via bash commands

### Automated Verification (NO User Intervention)

Each TODO includes EXECUTABLE verification procedures:

**For skill file creation:**
```bash
# Agent runs:
test -f .opencode/skills/opengasti-add/SKILL.md && echo "opengasti-add: OK"
test -f .opencode/skills/opengasti-query/SKILL.md && echo "opengasti-query: OK"
test -f .opencode/skills/opengasti-balance/SKILL.md && echo "opengasti-balance: OK"
test -f .opencode/skills/opengasti-prices/SKILL.md && echo "opengasti-prices: OK"
```

**For beancount integrity:**
```bash
uv run bean-check main.bean && echo "Ledger: OK"
```

**For skill content validation:**
```bash
# Verify frontmatter exists
head -5 .opencode/skills/opengasti-add/SKILL.md | grep -q "^---" && echo "Frontmatter: OK"
```

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Start Immediately):
├── Task 1: Create accounts reference file
├── Task 3: Create opengasti-balance skill
├── Task 4: Create opengasti-prices skill
└── Task 5: Create opengasti-query skill (+ references)

Wave 2 (After Task 1):
└── Task 2: Create opengasti-add skill (depends on accounts reference)

Wave 3 (After All):
└── Task 6: Final validation and testing

Critical Path: Task 1 → Task 2 → Task 6
Parallel Speedup: ~50% faster than sequential
```

### Dependency Matrix

| Task | Depends On | Blocks | Can Parallelize With |
|------|------------|--------|---------------------|
| 1 | None | 2 | 3, 4, 5 |
| 2 | 1 | 6 | 3, 4, 5 |
| 3 | None | 6 | 1, 4, 5 |
| 4 | None | 6 | 1, 3, 5 |
| 5 | None | 6 | 1, 3, 4 |
| 6 | 2, 3, 4, 5 | None | None (final) |

### Agent Dispatch Summary

| Wave | Tasks | Recommended Dispatch |
|------|-------|---------------------|
| 1 | 1, 3, 4, 5 | 4 parallel agents (category: quick) |
| 2 | 2 | 1 agent (category: unspecified-low) |
| 3 | 6 | 1 agent (category: quick) |

---

## TODOs

- [x] 1. Create accounts reference file for opengasti-add

  **What to do**:
  - Read `config/accounts.bean` and extract all account definitions
  - Create `.opencode/skills/opengasti-add/references/accounts.md` with:
    - Categorized list of all valid accounts
    - Common expense categories with Spanish aliases
    - Payment method to account mappings (débito → Assets:AR:Bank:*, crédito → Liabilities:AR:CreditCard:*)

  **Must NOT do**:
  - Invent accounts not in accounts.bean
  - Include closed or deprecated accounts

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Single file transformation, straightforward extraction
  - **Skills**: [`skill-creator`]
    - `skill-creator`: Provides skill structure patterns

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 3, 4, 5)
  - **Blocks**: Task 2
  - **Blocked By**: None

  **References**:
  - `config/accounts.bean` - Source of all valid account names
  - `.opencode/skills/skill-creator/SKILL.md:47-100` - Skill anatomy and structure

  **Acceptance Criteria**:
  ```bash
  test -f .opencode/skills/opengasti-add/references/accounts.md && echo "OK"
  grep -q "Assets:AR:Bank" .opencode/skills/opengasti-add/references/accounts.md && echo "Has bank accounts"
  grep -q "Expenses:Food" .opencode/skills/opengasti-add/references/accounts.md && echo "Has expense accounts"
  ```

  **Commit**: NO (groups with Task 2)

---

- [x] 2. Create opengasti-add skill (COMPLEX - Main Skill)

  **What to do**:
  - Create `.opencode/skills/opengasti-add/SKILL.md` with:
    - YAML frontmatter: name=opengasti-add, description includes Spanish triggers
    - Workflow: Parse input → Load accounts → Find month file → Write transaction → Validate
  - Include Spanish natural language parsing examples:
    - "gasté 5000 en el super con débito" → transaction format
    - "pagué 10000 de internet con crédito"
    - "cobré 500 usd de freelance"
  - MUST include validation step: `uv run bean-check main.bean`

  **Must NOT do**:
  - Hardcode file paths like `transactions/2026/01-january.bean`
  - Skip the validation step
  - Use `bean-check` without `uv run` prefix

  **Recommended Agent Profile**:
  - **Category**: `unspecified-low`
    - Reason: Moderate complexity, requires careful workflow design
  - **Skills**: [`skill-creator`]
    - `skill-creator`: Essential for proper SKILL.md structure

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 2 (sequential after Task 1)
  - **Blocks**: Task 6
  - **Blocked By**: Task 1

  **References**:
  - `.opencode/skills/skill-creator/SKILL.md` - Full skill creation guide
  - `.opencode/skills/skill-creator/references/workflows.md` - Multi-step workflow patterns
  - `transactions/2026/01-january.bean` - Transaction format examples
  - `config/accounts.bean` - Valid account names
  - `AGENTS.md:Transaction Format` section - Beancount syntax reference

  **Acceptance Criteria**:
  ```bash
  # File exists
  test -f .opencode/skills/opengasti-add/SKILL.md && echo "File: OK"
  
  # Has valid frontmatter
  head -5 .opencode/skills/opengasti-add/SKILL.md | grep -q "name: opengasti-add" && echo "Frontmatter: OK"
  
  # Contains validation step
  grep -q "bean-check" .opencode/skills/opengasti-add/SKILL.md && echo "Validation: OK"
  
  # Uses uv run prefix
  grep -q "uv run" .opencode/skills/opengasti-add/SKILL.md && echo "UV prefix: OK"
  
  # References accounts file
  grep -q "accounts" .opencode/skills/opengasti-add/SKILL.md && echo "Account grounding: OK"
  ```

  **Commit**: YES
  - Message: `feat(skills): add opengasti-add skill for Spanish transaction entry`
  - Files: `.opencode/skills/opengasti-add/*`
  - Pre-commit: None (skill files, not code)

---

- [x] 3. Create opengasti-balance skill (SIMPLE)

  **What to do**:
  - Create `.opencode/skills/opengasti-balance/SKILL.md` with:
    - YAML frontmatter: name=opengasti-balance, description for balance queries
    - Simple workflow wrapping `make balance` and `make net-worth`
    - Support for quick commands like "/balance", "/patrimonio"

  **Must NOT do**:
  - Recreate logic already in Makefile
  - Add complex query building

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Simple wrapper around existing make targets
  - **Skills**: [`skill-creator`]
    - `skill-creator`: SKILL.md structure

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 4, 5)
  - **Blocks**: Task 6
  - **Blocked By**: None

  **References**:
  - `Makefile:75-81` - balance and net-worth targets
  - `.opencode/skills/skill-creator/SKILL.md:47-70` - Skill anatomy

  **Acceptance Criteria**:
  ```bash
  test -f .opencode/skills/opengasti-balance/SKILL.md && echo "File: OK"
  head -5 .opencode/skills/opengasti-balance/SKILL.md | grep -q "name: opengasti-balance" && echo "Frontmatter: OK"
  grep -q "make balance\|bean-report" .opencode/skills/opengasti-balance/SKILL.md && echo "Uses make: OK"
  ```

  **Commit**: NO (groups with final commit)

---

- [x] 4. Create opengasti-prices skill (SIMPLE)

  **What to do**:
  - Create `.opencode/skills/opengasti-prices/SKILL.md` with:
    - YAML frontmatter: name=opengasti-prices, description for dollar rate updates
    - Simple workflow wrapping `make prices`
    - Explain output format and where prices are saved

  **Must NOT do**:
  - Recreate fetch_prices.py logic in the skill
  - Add complex API handling

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Simple wrapper around existing make target
  - **Skills**: [`skill-creator`]
    - `skill-creator`: SKILL.md structure

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 3, 5)
  - **Blocks**: Task 6
  - **Blocked By**: None

  **References**:
  - `Makefile:65-66` - prices target
  - `scripts/fetch_prices.py` - Understanding what it does
  - `.opencode/skills/skill-creator/SKILL.md:47-70` - Skill anatomy

  **Acceptance Criteria**:
  ```bash
  test -f .opencode/skills/opengasti-prices/SKILL.md && echo "File: OK"
  head -5 .opencode/skills/opengasti-prices/SKILL.md | grep -q "name: opengasti-prices" && echo "Frontmatter: OK"
  grep -q "make prices\|fetch_prices" .opencode/skills/opengasti-prices/SKILL.md && echo "Uses make: OK"
  ```

  **Commit**: NO (groups with final commit)

---

- [x] 5. Create opengasti-query skill with query references

  **What to do**:
  - Create `.opencode/skills/opengasti-query/SKILL.md` with:
    - YAML frontmatter: name=opengasti-query, description for natural language queries
    - Workflow: Parse Spanish question → Translate to BQL → Execute with bean-query
    - Common query patterns and examples
  - Create `.opencode/skills/opengasti-query/references/queries.md` with:
    - Pre-built queries from `config/queries.bean`
    - Spanish trigger phrases mapped to queries
    - BQL syntax quick reference

  **Must NOT do**:
  - Hardcode specific dates or amounts
  - Skip the BQL translation step

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Moderate complexity but well-defined patterns
  - **Skills**: [`skill-creator`]
    - `skill-creator`: SKILL.md structure and references pattern

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Tasks 1, 3, 4)
  - **Blocks**: Task 6
  - **Blocked By**: None

  **References**:
  - `config/queries.bean` - All pre-configured queries (10 queries)
  - `AGENTS.md:Common Queries` section - Query examples
  - `.opencode/skills/skill-creator/SKILL.md:140-175` - Reference file patterns

  **Acceptance Criteria**:
  ```bash
  test -f .opencode/skills/opengasti-query/SKILL.md && echo "Skill file: OK"
  test -f .opencode/skills/opengasti-query/references/queries.md && echo "Reference file: OK"
  head -5 .opencode/skills/opengasti-query/SKILL.md | grep -q "name: opengasti-query" && echo "Frontmatter: OK"
  grep -q "bean-query" .opencode/skills/opengasti-query/SKILL.md && echo "Uses bean-query: OK"
  ```

  **Commit**: NO (groups with final commit)

---

- [x] 6. Final validation and integration test

  **What to do**:
  - Verify all 4 skills exist and have valid structure
  - Run `uv run bean-check main.bean` to ensure ledger still valid
  - Test one command from each skill category:
    - `make balance` (opengasti-balance)
    - `make prices --help` or script check (opengasti-prices)
    - Basic bean-query (opengasti-query)
  - Create final commit with all skills

  **Must NOT do**:
  - Skip validation
  - Modify ledger files during testing

  **Recommended Agent Profile**:
  - **Category**: `quick`
    - Reason: Verification only, no complex work
  - **Skills**: []
    - No special skills needed for validation

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 3 (final)
  - **Blocks**: None (final task)
  - **Blocked By**: Tasks 2, 3, 4, 5

  **References**:
  - `Makefile` - All make targets for testing
  - `.opencode/skills/*/SKILL.md` - All created skills

  **Acceptance Criteria**:
  ```bash
  # All skills exist
  ls .opencode/skills/gasti-*/SKILL.md | wc -l | grep -q "4" && echo "All 4 skills: OK"
  
  # Ledger valid
  uv run bean-check main.bean && echo "Ledger: OK"
  
  # Make targets work
  make balance > /dev/null 2>&1 && echo "Balance command: OK"
  ```

  **Commit**: YES
  - Message: `feat(skills): add opengasti-query, opengasti-balance, opengasti-prices skills`
  - Files: `.opencode/skills/gasti-*/*`
  - Pre-commit: `uv run bean-check main.bean`

---

## Commit Strategy

| After Task | Message | Files | Verification |
|------------|---------|-------|--------------|
| 2 | `feat(skills): add opengasti-add skill for Spanish transaction entry` | `.opencode/skills/opengasti-add/*` | None |
| 6 | `feat(skills): add opengasti-query, opengasti-balance, opengasti-prices skills` | `.opencode/skills/gasti-*/*` | `uv run bean-check main.bean` |

---

## Success Criteria

### Verification Commands
```bash
# All skills created
ls .opencode/skills/gasti-*/SKILL.md
# Expected: 4 files

# Ledger still valid
uv run bean-check main.bean
# Expected: no output (success)

# Frontmatter valid in all skills
for skill in .opencode/skills/gasti-*/SKILL.md; do
  head -3 "$skill" | grep -q "^---" && echo "$skill: OK"
done
# Expected: 4 "OK" lines
```

### Final Checklist
- [x] All 4 skills have valid SKILL.md files
- [x] All skills have YAML frontmatter with name and description
- [x] opengasti-add includes account grounding from accounts.bean
- [x] opengasti-add includes validation step (bean-check)
- [x] All beancount commands use `uv run` prefix
- [x] No hardcoded file paths or dates
- [x] Ledger passes validation after skill creation
