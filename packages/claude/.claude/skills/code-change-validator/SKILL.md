---
name: code-change-validator
description: Post-change validation and regression testing for developers. Use when a developer has made significant code changes and wants to validate behavior, run real-world tests, and write automated regression tests for any issues found. Triggers on phrases like "validate my changes", "test my code changes", "check my git diff", "run tests on my changes", or when the user indicates they've just modified code and want verification.
---

# Code Change Validator

Validate code changes by analyzing diffs, running existing tests, performing exploratory testing, and writing regression tests for any issues discovered.

## Workflow

1. **Analyze the diff** → Understand what changed
2. **Determine intent** → Use conversation context or ask the user
3. **Find run instructions** → Locate README, Makefile, package.json, etc.
4. **Build the project** → Compile/build before testing to catch build errors early
5. **Run existing tests** → Execute the project's test suite
6. **Exploratory testing** → Manually verify the changed behavior
7. **Write regression tests** → If issues found, add tests with descriptive comments

## Step 1: Analyze the Git Diff

```bash
git diff HEAD~1   # or git diff main, git diff --staged, etc.
```

Identify:
- Which files changed
- What functions/classes/modules were modified
- The nature of changes (new feature, bug fix, refactor, config change)

## Step 2: Determine Intent

**If prior conversation context exists:** Extract the intended behavior from the conversation. Look for descriptions of what the changes should accomplish.

**If no context:** Ask the user:
> "I see changes to [files/areas]. What behavior should these changes produce? What problem are they solving?"

Keep the question focused on the specific changes observed.

## Step 3: Find Run Instructions

Search for setup and run documentation in this order:
1. `README.md`, `README.rst`, `README`
2. `Makefile`, `Taskfile.yml`, `justfile`
3. `package.json` (scripts section)
4. `pyproject.toml`, `setup.py`, `setup.cfg`
5. `Cargo.toml`, `go.mod`, `build.gradle`, `pom.xml`
6. `docker-compose.yml`, `Dockerfile`
7. `.github/workflows/` (CI configs often reveal test commands)

Extract:
- How to install dependencies
- How to run the application
- How to run tests (unit, integration, e2e)
- Where and how to write e2e/integration tests (test directories, frameworks, config, conventions)

## Step 4: Build the Project

Before running tests, build the project to catch compilation and build errors early.

Use the build command discovered in Step 3. Common patterns:

| Stack | Detection | Build Command |
|-------|-----------|---------------|
| Node/JS | `package.json` with build script | `npm run build` |
| TypeScript | `tsconfig.json` | `npx tsc --noEmit` or `npm run build` |
| Python | `pyproject.toml` with build backend | `pip install -e .` or `python -m build` |
| Rust | `Cargo.toml` | `cargo build` |
| Go | `go.mod` | `go build ./...` |
| Java | `pom.xml` or `build.gradle` | `mvn compile` or `gradle build` |

If the build fails, fix build errors before proceeding to tests. Report any build failures that cannot be resolved.

## Step 5: Run Existing Tests

Detect and run the project's test suite:

| Stack | Detection | Run Command |
|-------|-----------|-------------|
| Node/JS | `package.json` with jest/vitest/mocha | `npm test` or `npx jest` |
| Python | `pytest.ini`, `pyproject.toml`, `tests/` | `pytest` or `python -m pytest` |
| Rust | `Cargo.toml` | `cargo test` |
| Go | `*_test.go` files | `go test ./...` |
| Ruby | `Gemfile` with rspec/minitest | `bundle exec rspec` or `rake test` |
| Java | `pom.xml` or `build.gradle` | `mvn test` or `gradle test` |

If tests fail, note the failures for later regression test writing.

## Step 6: Exploratory Testing

**Prefer the project's own test infrastructure over ad-hoc bash scripts.** If Step 3 revealed documentation or configuration for e2e/integration tests (e.g., Playwright, Cypress, Selenium, Testcontainers, or a custom harness), write new test cases there to exercise the changed behavior. This produces repeatable, CI-friendly validation instead of throwaway manual checks.

### If e2e/integration test infrastructure exists:

1. **Read the project's test docs** to understand conventions (file location, naming, setup/teardown, fixtures)
2. **Write test cases** in the existing framework that cover:
   - The changed code paths with representative inputs
   - Edge cases relevant to the changes
   - Regressions in related functionality
3. **Run the new tests** using the project's test runner
4. **Document any failures** — expected vs. observed behavior

### If no e2e/integration test infrastructure exists:

Fall back to manual exploratory testing:

1. **Start the application** using discovered run instructions
2. **Exercise the changed code paths** with real inputs
3. **Verify expected behavior** matches the stated intent
4. **Test edge cases** relevant to the changes
5. **Check for regressions** in related functionality

Document any issues discovered:
- What behavior was expected
- What behavior was observed
- Steps to reproduce

## Step 7: Write Regression Tests

**Only if issues were found** in steps 5 or 6.

### Test File Location

Follow the project's existing convention:
- `tests/`, `test/`, `__tests__/`, `spec/`
- Co-located `*.test.js`, `*_test.py`, `*_test.go`

### Test Structure

Every regression test MUST include a comment explaining:
1. What bug or issue this test guards against
2. How the bug manifested
3. Reference to the validation session (date or context)

### Examples by Framework

**Jest/Vitest (JavaScript/TypeScript):**
```javascript
/**
 * Regression test: Validates fix for [issue description]
 * 
 * Bug: [Describe what went wrong]
 * Expected: [What should happen]
 * Found during: Code change validation [date/context]
 */
test('should [expected behavior]', () => {
  // Arrange
  // Act
  // Assert
});
```

**pytest (Python):**
```python
def test_regression_issue_description():
    """
    Regression test: Validates fix for [issue description]
    
    Bug: [Describe what went wrong]
    Expected: [What should happen]
    Found during: Code change validation [date/context]
    """
    # Arrange
    # Act
    # Assert
```

**Go:**
```go
// TestRegressionIssueDescription validates fix for [issue description]
//
// Bug: [Describe what went wrong]
// Expected: [What should happen]
// Found during: Code change validation [date/context]
func TestRegressionIssueDescription(t *testing.T) {
    // Arrange
    // Act
    // Assert
}
```

### After Writing Tests

1. Run the new tests to confirm they pass with the fix
2. Optionally verify they would have caught the original issue (if reproducible)
3. Ensure tests follow project conventions (naming, organization, assertions)

## Reporting

Summarize findings:

```
## Validation Summary

**Changes analyzed:** [files/areas]
**Intended behavior:** [from context or user]

### Existing Tests
- Status: [passed/failed]
- [Details of any failures]

### Exploratory Testing
- [What was tested]
- [Issues found, if any]

### Regression Tests Added
- [List of new tests with brief descriptions]
- [Or "None required - all tests passed"]
```
