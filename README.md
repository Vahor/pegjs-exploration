# Docs

- json.pegjs grammar: https://github.com/peggyjs/peggy/blob/main/examples/json.pegjs

# Development

Debug with `input.txt`:
```sh
bunx peggy grammar.pegjs -S start --trace -T input.txt -w
```

Generate `grammar.js` and `grammar.d.ts`:
```sh
bunx peggy grammar.pegjs -S start --plugin ./node_modules/ts-pegjs/dist/tspegjs.js -o grammar.ts
```

# Result

From:
```pegjs
companies {
    "EmptyCompany" {
      keywords: []
      context: "It's empty"
    }
    "TechCorp" {
      keywords: ["cloud", "saas", "enterprise"]
      context: "Cloud computing"
    }
    "GreenEnergy" {
      context: "Solar panel manufacturing"
      keywords: ["solar", "renewable"]
    }
}
-> select {
  top(3) by negative.ASC
  top(4) by positive.ASC
}
-> fields [title, score]

```

To :
```json
{
  "companies": [
    {
      "_key": "EmptyCompany",
      "keywords": [],
      "context": "It's empty"
    },
    {
      "_key": "TechCorp",
      "keywords": [
        "cloud",
        "saas",
        "enterprise"
      ],
      "context": "Cloud computing"
    },
    {
      "_key": "GreenEnergy",
      "context": "Solar panel manufacturing",
      "keywords": [
        "solar",
        "renewable"
      ]
    }
  ],
  "select": [
    {
      "method": "top",
      "count": 3,
      "field": "negative",
      "order": "ASC"
    },
    {
      "method": "top",
      "count": 4,
      "field": "positive",
      "order": "ASC"
    }
  ],
  "fields": [
    "title",
    "score"
  ]
}
```

The syntax is is okish, quite readable tanks to the `->` syntax. The execution order is more clear, first the `companies` filter then `select` and the result `fields` are always at the end.
We also have a *free* typesystem, if something is not in the grammar, it's not a valid query and thanks to the ts plugin we get ts types from it (note: the types are not perfect, it has a lot of `any`, and does not have a strict syntax, every string is typed as `string` even if we request some specific char to be present like "(" ; and the type for "False" is `boolean` where it should be `false`).

However, it's not as usable as a json object, there's no way to add a company without having to write a lib for it, whereas with a json you can simply access the `companies` object and add a new entry.
It will also be less simple for new users or to document this.
