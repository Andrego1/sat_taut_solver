# SAT and TAUT Checker

## A simple SAT and TAUT checker for boolean expressions written in Haskell

This project allows you to check whether a boolean expression is **satisfiable (SAT)** or a **tautology (TAUT)**.

### Syntax

Expressions follow a familiar logical syntax. Example:


### Supported Operators

| Symbol   | Meaning            |
|----------|--------------------|
| `!`      | Negation (NOT)     |
| `&&`     | Conjunction (AND)  |
| `\|\|`       | Disjunction (OR)   |
| `->`     | Implication        |
| `<->`    | Biconditional      |
| `(expr)` | Parentheses for grouping |

**Operator precedence** (from highest to lowest):

1. `!`
2. `&&`
3. `||`
4. `->`
5. `<->`

Associativity and precedence are respected during parsing.

---

### Implementation Details

- **Lexer**: Built using [Alex](https://www.haskell.org/alex/), defined in `Lexer.x`  
  → Generates the `alexScanTokens` function.
  
- **Parser**: Built using [Happy](https://www.haskell.org/happy/), defined in `Parser.y`  
  → Generates the `parse` function that consumes tokens and produces an AST.

- **Evaluator**: Defined in `Main.hs`, uses:
  - **Backtracking** to check if a formula is satisfiable (`SAT`)
  - **Exhaustive checking** to determine if a formula is always true (`TAUT`)

---

### How to Use

1. Compile the project using:
   ```bash
   ghc -o Main Main.hs
2. Run the executable:
   ```bash
   ./Main
3. Choose whether to test for `SAT` or `TAUT`, by typing `1` or `2` respectivly
4. Enter expressions, one per line
5. Type `return` to go back to the main menu
6. And you can exit the program by typing `exit`

Note: you could also use a file like `test.txt` with the command:
```bash 
./Main < test.txt
```

---

### Example Expressions

```text
Test if SAT (1) or TAUT (2)? (type "1" or "2")
1
Type expressions one per line. Type "return" to go back to main menu.
a -> b ----- SAT

a: True
b: True

a <-> b ----- SAT

a: True
b: True

a && b ----- SAT

a: True
b: True

a || !a ----- SAT

a: True
return
Test if SAT (1) or TAUT (2)? (type "1" or "2")
exit
