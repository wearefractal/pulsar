build: components lib
	@rm -rf dist
	@mkdir dist
	@coffee -o dist -c lib/main.coffee lib/Client.coffee lib/Channel.coffee
	@component build --standalone Pulsar
	@mv build/build.js pulsar.js
	@rm -rf build
	@node_modules/.bin/uglifyjs -nc --unsafe -mt -o pulsar.min.js pulsar.js
	@echo "File size (minified): " && cat pulsar.min.js | wc -c
	@echo "File size (gzipped): " && cat pulsar.min.js | gzip -9f  | wc -c
	@cp pulsar.js example/public/pulsar.js

components: component.json
	@component install --dev

clean:
	rm -fr components