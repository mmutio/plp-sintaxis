// fuente 'jflex' para interprete

package org.unp.plp.interprete;

%%

%class Lexer
%byaccj

%{

  private Parser yyparser;

  /** constructor del analizador sintáctico
  *** acepta como parámetro el lector de caracteres a usar
  **/

  public Lexer(java.io.Reader r, Parser p )
  {
    this(r);
    yyparser = p  ;
  }

  /** devuelve el numero de linea donde está el último caracter leido
  **/

  public int lineaActual()
  {
     return yyline;
  }

%}

%%

"world" {return Parser.WORLD;}

"put" {return Parser.PUT;}
"rem" {return Parser.REM;}
"in" {return Parser.IN;}

"hero" {yyparser.yylval = yytext(); return Parser.HERO;}
"wumpus" {yyparser.yylval = yytext(); return Parser.WUMPUS;}
"gold" {yyparser.yylval = yytext(); return Parser.GOLD;}
"pit" {return Parser.PIT;}
"print" {return Parser.PRINT;}

[0-9]+
   {  yyparser.yylval = new Integer(yytext());
      return Parser.CONSTANT;
   }

\r|\n|\r\n
  { // lleva la cuenta de lineas
    yyline++ ;
    return Parser.NL;
  }

[+\-*/\[\],;:><=\?ijx] 
{
      /** Deja pasar los caracteres únicos como literales **/
      /** No es ninguna expresión regular, sólo los caracteres literales **/
      yyparser.yylval = yytext();
      return yytext().charAt(0);
}

[ \t]+ {  /** accion vacia: se ignoran los espacios y tabuladores **/
       }

.      {  /** token desconocido: se produce un mensaje de error **/
          yyparser.yyerror("El lexema '"+yytext()+"' no corresponden a ningún token conocido");
       }
