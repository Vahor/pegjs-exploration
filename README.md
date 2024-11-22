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
