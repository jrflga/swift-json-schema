# Fork do jrflga

Base: `v0.13.2` do [original](https://github.com/ajevans99/swift-json-schema).
Usado pelo `jrflga/a2ui-swift`, que o `jrflga/molde` usa.

O que muda do original:
- `swift-syntax` e `swift-collections` em versão exata;
- sem `swift-docc-plugin` e sem `swift-snapshot-testing`, e sem o alvo
  `JSONSchemaIntegrationTests`, que dependia deles.

Atualizar: `git fetch original --tags`, criar o ramo a partir da tag nova,
reaplicar as mudanças acima, ler o diff do original e marcar
`<versão>-jrflga.1`. Nunca usar faixa de versão.
