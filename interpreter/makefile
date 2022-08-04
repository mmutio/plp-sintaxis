NAME = interpreter
DIR = org/unp/plp/interprete
PKG = org.unp.plp.interprete
JFLEX  = jflex
BYACCJ = byaccj -J -Jsemantic=Object -Jpackage=$(PKG)
JAVAC  = javac


.SUFFIXES:
#.PHONY: ejecuta

Main.class: Lexer.java Parser.java
	mkdir -p ./bin
	rm -f ./bin/$(DIR)/*.class
	$(JAVAC) -d ./bin ./src/$(DIR)/*.java

Lexer.java:
	$(JFLEX) -d ./src/$(DIR) ./src/$(NAME).l
	rm -f ./src/$(DIR)/Lexer.java~

Parser.java:
	$(BYACCJ) ./src/$(NAME).y
	mv ./Parser.java ./src/$(DIR)/Parser.java


run: Main.class
	java -cp ./bin $(PKG).Main

clean:
	rm -f ./src/$(DIR)/Lexer.java ./src/$(DIR)/Parser.java ./bin/$(DIR)/*.class
