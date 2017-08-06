pubflags=--mode debug
dartanalyzer=/usr/lib/dart/bin/dartanalyzer
dartanalyzerflags=--strong
dirs=test web lib
pub=/usr/lib/dart/bin/pub
sass_root=web/sass
css_dest=build/web/styles.css

.PHONY: test start build analyze build-sass

start:
	find $(dirs) -name '*.dart' | grep -v '#' | entr make build &
	find $(sass_root) -name '*.scss' | grep -v '#' | entr make build-sass

build: web/*.dart analyze
	$(pub) build $(pubflags)

build-sass:
	find web/sass/ -name '*.scss' | awk '{print "@import \"" $$0 "\""}' | SASS_PATH='.' sass --stdin > $(css_dest)

analyze: 
	$(dartanalyzer) $(dartanalyzerflags) web/main.dart

test:
	find $(dirs) -name '*.dart' | grep -v '#' | entr pub run test test/*.dart

