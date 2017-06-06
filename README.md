# Language Load Performance Profiling

Waiting to reload code after making a change imposes a significant cost on developers in large codebases. I wanted to measure roughly what this looks like for a few common languages and patterns. Note that I'm not aiming for accuracy here -- just a coarse comparison of languages and patterns.

For each of Ruby, Python and Javascript, I wrote templates to generate 5000 files of comparable code. This translates to 2-3M lines of code depending on the language. In the "simple" case each file defines a single class with some methods and made-up bodies. In the "dsl" case, I add on some load-time code execution to mimic common DSL patterns in each of the languages. Note that since each of these languages handle DSL-like behavior very differently these implementations diverge quite a bit. I generated the templates with:

```
rm -r data/; ruby generate.rb simple/ruby.rb.erb simple/python.py.erb simple/javascript.js.erb dsl/ruby.rb.erb dsl/python.py.erb dsl/javascript.js.erb
```

I ran a first pass of data with:
```
ruby run.rb data simple/javascript simple/ruby simple/python dsl/javascript dsl/ruby dsl/python
```

I looked at the contribution of bytecode compilation to Python times with:
```
rm -r data/simple/python/__pycache__/ data/dsl/python/__pycache__/; PYTHONDONTWRITEBYTECODE=1 ruby run.rb data simple/python dsl/python
```

I also implemented simple instruction sequence caching in Ruby:
```
USE_ISEQ=1 ruby run.rb data simple/ruby dsl/ruby
```
