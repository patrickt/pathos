all:
	coffee -m -o src/javascript -w src/coffeescript; exit 0

clean:
	rm src/javascript/*.js
