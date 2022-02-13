# Projet d'analyseur statique du cours TAS - Rapport de projet
Auteur: Edwin ANSARI - 28708326

**Tout les fonctionnalités sont implémentées.**

Problèmes rencontrées: 
- Quelques étudiants (y compris moi) non pas réussi a `build/make` le projet pour un certain moment à cause d'un problème avec `menhir`. j'ai donc réglé et détaillé le problème dans un [issue#1](https://stl.algo-prog.info/tas-2021oct/projet-tas/-/issues/1).

## 1. Prise en main

### 1.1 Analyse concrète

> 1.1.1 Quelles est la sémantique de l'instruction rand(l,h) dans un programme ? quel est le résultat attendu de l'interprète?

`rand` est utilisé pour représenter un bou de code/fonction complexe ou avec résultat imprévisible par example un `input`. Donc on suppose une intervalle `[l,h]` de valeurs possible.  
Dans le cas de l'interpréteur *`concret`* on attend que l'analyse induit les résultats pour tout execution possible du programme donc pour une variable à valeurs dans `[l,h]` on aura `(h-l+1)` valeurs possible.

> 1.1.2. Sous quelles conditions l'exécution d'un programme s'arrête-t-elle ? quel est alors le résultat
de l'interprète ?

Dans le cas d'un `assert false` ou bien la fin d'un programme avec instruction `halt` => environnement vide.

> 1.1.3. Si le programme comporte une boucle infinie, est-il possible que l'interprète termine tout de même ? dans quels cas ?

Oui dans le cas ou l'interpréteur utilise `join` ou `widen` pour accélérer la convergence de l'environnement d'une boucle et de trouver un `fixpoint`.


### 1.2 Ajout du support des assertions
[interpreter.ml](src/interpreter/interpreter.ml)
```ml
| AST_assert e ->
    (* to be sound, we return the argument unchanged *)
    let f1 = filter a e false and f2 = filter a e true in
    if D.is_bottom f1 then        
    f2 else (error ext "assertion failure"; f2)
```
`f2` : le résultat en supposant que l'assert est correcte est renvoyé dans les deux cas.

### 1.3 Complétion du domaine des constantes
[constant_domain.ml](src/domains/constant_domain.ml) :  
e.x. Testing 0124_mul_rand.c: imprecision pour mul, TOP * {0} = {0}
- [x] mul
- [x] eq, neq, gt, ge

## 2. partie commune

### 2.1 Domaine des intervalles
- [x] [domains/interval_domain.ml](src/domains/domain.ml)
- [x] [main.ml](src/main.ml): IntervalAnalysis, `-interval` option
- [x] [tests/10_interval](tests/10_interval/)

### 2.2 Analyse des boucles
- [x] [domains/interval_domain.ml](src/domains/interval_domain.ml): widen
- [x] [interpreter/interpreter.ml](src/interpreter/interpreter.ml): line 154
- [x] [tests/12_interval_loop/](tests/12_interval_loop/)
- [x] [main.ml](src/main.ml): -delay n option
- [x] [tests/13_interval_loop_delay/](tests/13_interval_loop_delay/)
- [x] [main.ml](src/main.ml): -unroll u option
- [ ] [tests/14_interval_loop_delay_unroll/](tests/14_interval_loop_delay_unroll/)
  - seulement 2 tests ne passe pas:
    `0207_loop_nested.c` et `0208_loop_nested.c`

### 2.3 Produit réduit
- [x] [domains/value_reduction.ml](src/domains/value_reduction.ml): signature des réductions
- [x] [domains/value_reduced_product.ml](src/domains/value_reduced_product.ml): produit réduit générique
- [x] [domains/parity_interval_reduction.ml](src/domains/parity_interval_reduction.ml): instance de réduction
- [x] [main.ml](src/main.ml): -parity-interval option
- [x] [tests/20_reduced/](tests_20_reduced/)

## 3. Extension au choix: **Analyse des entiers machine modulaires**
- [x] [domains/z_type](src/domains/z_type.ml): ajout du signature de `zarith.Z`
- [x] [domains/z32](src/domains/z32.ml): support basé sur `Int32` pour l'arithmétique modulaire sur 32 bits
- [x] [domains/concrete_domain.ml](src/domains/concrete_domain.ml): paramétré par un module `Z` arbitraire avec la même signature que `zarith`
- [x] [main.ml](src/main.ml): option `concrete-int32` pour l'arithmétique sur 32 bits
- [x] [tests/30_extension/concrete/](tests/30_extension/concrete/): implementation cohérent avec anciens tests