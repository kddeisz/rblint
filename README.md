# rblint

A linter for Ruby code.

## Getting started

To run the linter, run `bin/rblint file/pattern/**/*.rb`.

## Developing

If you want to play around with this project, you'll need a rudimentary understanding of ripper's syntax. You can delve into it by running

```bash
bin/cst 'foo + bar'
```

This will return to you the concrete syntax tree below

```ruby
[:program,
 [:stmts_add,
  [:stmts_new],
  [:binary,
   [:vcall, [:@ident, "foo", [1, 0]]],
   :+,
   [:vcall, [:@ident, "bar", [1, 6]]]]]]
```

You can then use that in developing any additional rules in `lib/rblint/rules.rb`.

## Testing

You can add tests by adding comments above the module that defines your rule indented by 5 spaces. Then run `bin/test` to run all of the tests. I realize this is a bit silly as a test runner, but it's just an experiment.
