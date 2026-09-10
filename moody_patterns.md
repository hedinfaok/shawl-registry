# Moody Patterns

This is the implementor-facing pattern catalog. Use it when deciding how to
shape an agent before writing code.

Each pattern answers:

- when to use it
- when not to use it
- what the parent owns
- what children own
- what face carries
- what failure it prevents

## 1. Parent + Children

Use when a behavior has a stable outer responsibility and smaller behaviors
with independent identity.

Shape:

- parent initializes ctx/face for the operation
- parent calls `run_children`, `chain_children`, or `collect_*`
- children gate on their own triggers
- children return face

Face:

- carries the result of the operation
- advances from child to child when chained

Do not use when the children would only be private branches of one local
decision with no reuse, identity, or observability value. Use Flat Dispatcher
Child instead.

Common failure:

- one large agent with many unrelated moods and no hierarchy

## 2. Real-Data Dispatch

Use when a parent iterates records, tokens, events, nodes, rows, messages, or
requests and each handler should decide whether it applies.

Shape:

- parent owns the cursor or loop
- parent passes the current item in ctx
- child trigger checks data already present on the item
- child strategy advances face or parent-owned cursor state

Good triggers:

```js
ctx.node.type === 'call'
ctx.event === 'catalog:ready'
ctx.token.kind === 'identifier'
ctx.req.method === 'POST'
```

Bad triggers:

```js
ctx.mode === 'call'
ctx.production === 'identifier'
ctx._route === 'post-handler'
```

Face:

- carries the accumulator
- child contributions return through face

Common failure:

- mood signaling on synthetic routing flags
- recursive `self.run({ ...ctx, mode : 'x' })`

## 3. Flat Dispatcher Child

Use when multiple cases are flat local branches of the same decision and do not
deserve separate child-agent identity.

Shape:

- one dispatcher child
- many moods with `last : true`
- each trigger checks real data
- parent calls the dispatcher as one child

Face:

- same as Real-Data Dispatch

Do not use as the first answer to every case split. If cases have reusable
identity, separate observability, or separate lifecycle, make them children.

Common failure:

- a root agent becomes a giant `last:true` method table

## 4. Tree-Fold

Use for one recursive tree or AST: compile, emit, decompile, render, transform,
evaluate.

Shape:

- parent owns an iterative worklist of `expand` and `combine` frames
- each node-type child has two arms
- expand arm returns children
- combine arm consumes child results from face and pushes its result

Triggers:

```js
ctx.node.type === 'call' && face == null
ctx.node.type === 'call' && face != null
```

Face:

- result stack
- top of stack is the current synthesized value

Do not use recursive agent self-calls for structural children. The worklist is
the recursion.

Common failure:

- algebra lives in helpers while agents only wrap helper calls
- parent stores results in `subCtx.result`
- result stack kept as parent-local state instead of face

## 5. Pair-Fold

Use for coupled walks over two structures: pattern matching, schema-vs-value
validation, tree diff, equality with captures, bidirectional checks.

Shape:

- parent owns a worklist of `{ left, right, op }`
- left side drives dispatch
- child triggers on left type, and sometimes right type
- `null` face means bail / no match

Face:

- captures
- edit list
- validation accumulator
- any matched-state object

Do not force symmetry when the problem is naturally asymmetric. Wildcards,
captures, and schema nodes often gate only on the left and consume any right.

Common failure:

- returning `{ matched, captures }` wrappers when `null` already means absence
- storing captures on ctx

## 6. Foreign-Fold

Use when a tree traversal reaches a named extraction that must be processed as
a fresh problem by the same agent.

Shape:

- current child strategy calls `SameAgent.run({ root : extracted, ... })`
- the new run has a fresh worklist
- the outer strategy awaits the returned face

This is allowed when the recursive call is a fresh top-level problem on smaller
input. It is not the same as `self.run()` recursion inside the current mood
chain.

Face:

- outer face carries current traversal state
- inner run returns the extracted value's result

Common failure:

- pushing special routing work-items into the outer worklist
- adding bridge agents that only call the same agent
- helper functions doing cross-call behavior outside Moody

## 7. Declarative Instantiation / Activator

Use when runtime instances are described by rows: connectors, validators,
dialects, subscriptions, adapters, policies.

Shape:

- activator reads declared rows
- resolves references
- materializes runtime agents or handlers
- attaches children when needed
- registers instances
- emits lifecycle event if appropriate

Face:

- materialized instances
- registration results
- diagnostics

Do not write factory functions as the primary architecture for per-instance
composition. Rows describe; activators reify.

Common failure:

- factory-function default
- hand-written setup for every instance

## 8. Catalog Pipeline

Use when catalog-driven behavior repeats the same lifecycle:

1. discover rows
2. resolve rows into runnable/materialized form
3. apply the result

Shape:

- discover: query catalog
- resolve: compile/materialize/validate references
- apply: register, dispatch, emit, or persist

Face:

- discovered rows
- resolved records
- apply results

When two instances share discover and apply and only resolve varies, consider a
higher-order catalog-pipeline agent.

Common failure:

- three-stage activators copied repeatedly with only the middle stage changing

## 9. Validation as a Mood

Use when an agent must reject malformed input or output. There is no validation
extension — validation is just a mood that checks and throws.

Shape:

- an early mood reads `ctx` (or `face`), checks required fields / shapes
- throws on violation; the thrown error unwinds with its `moody_path` stamped
- later moods trust the checked shape

Face:

- unchanged on success (validation is a guard, not a transform)

Notes:

- in MANATEE, data validation belongs in MUSEUM; moody-level checks are local guards
- `retry` / `timeout` are mood fields, not moods — see the runtime contract

Common failure:

- reaching for a framework "validation layer" instead of a guard mood

## 10. Cross-Cutting as a Wrapping Agent

Use for logging, auth, timing, tracing — behavior that surrounds work rather than
being the work. There is no middleware stack; you wrap.

Shape:

- a parent agent whose mood does setup, runs the inner agent via `run_children`
  / `chain_children`, then does teardown — the inner work is a child
- or, for one agent, a leading guard mood (e.g. auth) before the work moods

Face:

- threaded through unchanged except for what the cross-cutting step contributes

Notes:

- timing / profiling specifically is dev tooling — use `MoodyObserver`, not a mood
- this keeps the concern visible in the mood chain instead of hidden in a global
  interceptor that every agent silently pays for

Common failure:

- a global middleware chain that taxes every run for a concern few moods need

## 11. Retry / Timeout — Behavior You Place

There is no retry or timeout artifact — no field, no agent, no extension. They are
local control flow, and only you know *what* should retry or time out, so you
write them where the behavior belongs.

Retry one mood — loop inside the strategy:

```js
strategy: async (self, ctx, face) => {
    for (var attempt = 1; ; attempt++) {
        try { return await doRiskyThing(ctx) }
        catch (err) {
            if (attempt >= 3) throw err
            await new Promise(function (r) { setTimeout(r, 100 * attempt) })
        }
    }
}
```

Retry a self-contained unit — loop around `run_children` in a parent mood. Retry
the whole agent — loop around `agent.run` at the call site.

Timeout — race the work against a timer wherever it is invoked:

```js
var timer = new Promise(function (_, reject) {
    setTimeout(function () { reject(new Error('timeout')) }, ms)
})
return Promise.race([doRiskyThing(ctx), timer])
```

Pick the granularity by where you place it: a mood, a child dispatch, or the run.

Common failure:

- reaching for a framework retry/timeout feature that has to guess the granularity
