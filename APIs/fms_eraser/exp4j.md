# exp4j

> exp4j is a mathematical expression evaluator for the Java programming language.

links : [http://projects.congrace.de/exp4j/](http://projects.congrace.de/exp4j/)

API docs : [http://www.objecthunter.net/exp4j/apidocs/index.html](http://www.objecthunter.net/exp4j/apidocs/index.html)

## Installation

download Binary jar from link below and add for code directory.

Or, drag jar file and drop on Processing IDE.

[http://projects.congrace.de/exp4j/download.html](http://projects.congrace.de/exp4j/download.html)

## Preparation

```
import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ExpressionBuilder;
```

## Built-in

### Operators

- `Addition`       : 2 + 2
- `Subtraction`    : 2 - 2
- `Multiplication` : 2 * 2
- `Division`       : 2 / 2
- `Exponentation`  : 2 ^ 2
- `Sign Operators` : +2 - (-2)
- `Modulo`         : 2 % 2

### Functions

- `abs`    : absolute value
- `acos`   : arc cosine
- `asin`   : arc sine
- `atan`   : arc tangent
- `cbrt`   : cubic root
- `ceil`   : nearest upper integer
- `cos`    : cosine
- `cosh`   : hyperbolic cosine
- `exp`    : euler's number raised to the power (e^x)
- `floor`  : nearest lower integer
- `log`    : logarithmus naturalis (base e)
- `log10`  : logarithm (base 10)
- `log2`   : logarithm (base 2)
- `sin`    : sine
- `sinh`   : hyperbolic sine
- `sqrt`   : square root
- `tan`    : tangent
- `tanh`   : hyperbolic tangent
- `signum` : signum function

## Sample

### Evaluating an expression

```java
import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ExpressionBuilder;

void setup() {
  Expression e = new ExpressionBuilder("3 * sin(y) - 2 / (x - 2)")
    .variables("x", "y")
    .build()
    .setVariable("x", 2.3)
    .setVariable("y", 3.14);
  double result = e.evaluate();
  println(result);
}
```

> output : -6.661890082267629

## Extension

```java:main.pde
import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ExpressionBuilder;

void setup() {
  var x = new var("x", 1);
  var y = new var("y", 2);
  println(fomula("x + y", x, y));
  // output : 3.0
}
```

```java:fomula.pde
import java.util.Map;
import java.util.HashSet;

double fomula(String _fomula, var... _var) {
  try {
    HashSet<String> set = new HashSet<String>();
    Map<String, Double> map = new HashMap<String, Double>();
    for (var v : _var) {
      set.add(v.name);
      map.put(v.name, v.value);
    }
    Expression e = new ExpressionBuilder(_fomula)
      .variables(set)
      .build()
      .setVariables(map);
    for (var v : _var) e.setVariable(v.name, v.value);
    return e.evaluate();
  }
  catch(UnknownFunctionOrVariableException _e) {
    return 0;
  }
}
```

```java:var.pde
class var{
    String name;
    double value;
    
    var(String _name, double _value){
        name  = _name;
        value = _value;
    }
}
```