# Example Code Review

This example demonstrates the expected output format.

---

### 1. 🔴 CRITICAL Security: SQL Injection Vulnerability

**Location:** `src/users/repository.ts:87`

**Issue:** User input interpolated directly into SQL query.

**Why it matters:** Attackers can execute arbitrary SQL, leading to data theft
or deletion.

**Suggestion:**
```typescript
// Before
const query = `SELECT * FROM users WHERE id = ${userId}`;

// After - use parameterized query
const query = 'SELECT * FROM users WHERE id = $1';
const result = await db.query(query, [userId]);
```

---

### 2. 🔴 CRITICAL Logic: Race Condition in Balance Update

**Location:** `src/accounts/service.ts:45-52`

**Issue:** Balance is read, modified, then written without locking. Concurrent
requests can cause lost updates.

**Why it matters:** Users could lose money or overdraw accounts when parallel
transactions occur.

**Suggestion:**
Use a database transaction with row-level locking:
```typescript
// Before
const account = await db.accounts.findOne(id);
account.balance += amount;
await db.accounts.save(account);

// After
await db.transaction(async (tx) => {
  const account = await tx.accounts.findOne(id, { lock: 'FOR UPDATE' });
  account.balance += amount;
  await tx.accounts.save(account);
});
```

---

### 3. 🟠 MAJOR Design: God Function

**Location:** `src/orders/service.ts:145-280`

**Issue:** `processOrder()` handles validation, pricing, inventory, payment,
and notifications in 135 lines.

**Why it matters:** Difficult to test, understand, and modify. Changes to
notifications risk breaking payment logic.

**Suggestion:**
Extract into focused functions:
1. `validateOrder(order): ValidationResult`
2. `calculatePricing(order, discounts): PricingDetails`
3. `reserveInventory(items): ReservationResult`
4. `processPayment(order, pricing): PaymentResult`
5. `sendConfirmation(order, result): void`

Compose in `processOrder()` with early returns on failure.

---

### 4. 🟠 MAJOR Correctness: Diverged Validation Copies — `admin.ts` Accepts
Invalid Phones

**Location:** `src/api/users.ts:34-48`, `src/api/admin.ts:67-81`

**Issue:** Both handlers validate contact info. `users.ts:41` guards
`data.phone && !isValidPhone(data.phone)`; `admin.ts:74` checks the email only
— the phone clause was never copied across.

**Why it matters:** Admin-created records bypass phone validation entirely, so
malformed numbers reach the notification queue and fail at send time. This is
not a DRY nit: the two copies disagree, and `admin.ts` is the wrong one.

**Suggestion:**
Extract to a shared validator and route both handlers through it:
```typescript
// src/validation/contact.ts
export function validateContactInfo(data: ContactInput): ValidationResult {
  const errors: string[] = [];
  if (!isValidEmail(data.email)) errors.push('Invalid email format');
  if (data.phone && !isValidPhone(data.phone)) errors.push('Invalid phone format');
  return { valid: errors.length === 0, errors };
}
```

---

### 5. 🟡 MINOR Style: Inconsistent Naming

**Location:** `src/utils/helpers.ts:12, 28, 45`

**Issue:** Mixed naming conventions: `getUserData`, `fetch_user_prefs`,
`LoadUserSettings`.

**Why it matters:** Inconsistency increases cognitive load and makes codebase
feel unprofessional.

**Suggestion:**
Standardize on camelCase (matching project convention):
- `fetch_user_prefs` → `fetchUserPrefs`
- `LoadUserSettings` → `loadUserSettings`

---

### 6. 🟡 MINOR Code Quality: Magic Number

**Location:** `src/auth/token.ts:23`

**Issue:** `const expiry = Date.now() + 86400000` — unclear what this number
represents.

**Why it matters:** Future developers must calculate or guess. Easy to
introduce errors when modifying.

**Suggestion:**
```typescript
const ONE_DAY_MS = 24 * 60 * 60 * 1000;
const expiry = Date.now() + ONE_DAY_MS;
```

---

### 7. 🔵 NIT Documentation: Missing JSDoc on Public Function

**Location:** `src/api/orders.ts:12`

**Issue:** `createOrder()` is exported but has no documentation.

**Why it matters:** Consumers of this API must read implementation to
understand expected input/output.

**Suggestion:**
```typescript
/**
 * Creates a new order for the given customer.
 * @param customerId - The customer placing the order
 * @param items - Array of items with productId and quantity
 * @returns The created order with generated ID and calculated totals
 * @throws {ValidationError} If items array is empty or quantities invalid
 */
export async function createOrder(customerId: string, items: OrderItem[]): Promise<Order>
```

---

## Summary

| Severity | Count |
|----------|-------|
| 🔴 Critical | 2 |
| 🟠 Major | 2 |
| 🟡 Minor | 2 |
| 🔵 Nit | 1 |

**Overall:** The code has critical security and concurrency issues, plus the
`admin.ts` validation gap, that must be addressed before merging. The
god-function refactor is worth doing but could be tracked as follow-up work.
Good use of TypeScript types throughout.
