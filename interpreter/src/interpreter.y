%{
  import java.io.*;
  import java.util.Collection;
  import java.util.List;
%}


// lista de tokens por orden de prioridad

%token NL         // nueva línea
%token CONSTANT   // constante
%token WORLD

%token PRINT

%token WUMPUS
%token HERO
%token GOLD
%token PIT

%token PUT
%token REM
%token IN

%%

program
  : // Programa vacio
  | world_statement
    statement_list
  ;

world_statement
  : WORLD CONSTANT 'x' CONSTANT ';' NL {world.create((int)$2, (int)$4);}
  ;

statement_list
  : // Sentencia vacia
  | statement ';' NL statement_list // Sentencia,y lista
  ;

statement
  : action_statement
  | print_statement
  ;

action_statement 
  : PUT object IN una_celda   { world.putObject((String)$2, (Celda)$4); }
  | PUT PIT IN una_celda      { world.putPit((Celda)$4); }
  | PUT PIT IN muchas_celda   { world.putPits((Collection<Celda>)$4); }
  ;


una_celda // Retorna una sola celda
  : '[' CONSTANT ',' CONSTANT ']' { $$ = new Celda((int)$2,(int)$4); }
  ;

muchas_celda // Retorna un CONJUNTO de celdas
  : '[' CONSTANT ',' '?'      ':' cond_list ']' {$$ = $6;}
  | '[' '?'      ',' CONSTANT ':' cond_list ']' {$$ = $6;}
  | '[' '?'      ',' '?'      ':' cond_list ']' {$$ = $6;}
  ;

cond_list
  : cond
  | cond ',' cond_list {$$ = world.condicion((List<Celda>)$1,(List<Celda>)$3,(a,b) -> true);}
  ;

cond
  : expr '=''=' expr {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$4).celdas(),(a,b) -> a == b);}
  | expr '>''=' expr {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$4).celdas(),(a,b) -> a >= b);}
  | expr '<''=' expr {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$4).celdas(),(a,b) -> a <= b);}
  | expr '>' expr    {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$3).celdas(),(a,b) -> a > b);}
  | expr '<' expr    {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$3).celdas(),(a,b) -> a < b);}
  ;

// La regla expr es ambigua y no posee una correcta asociatividad y precedencia.
// Modificarla para respetar las convenciones matemáticas
expr
  : op
  | expr '+' expr { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a+b); }
  | expr '-' expr { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a-b); }
  | expr '*' expr { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a*b); }
  | expr '/' expr { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a/b); }
  ;

op
  : CONSTANT  { $$ = Matriz.constante((int)$1); }
  | 'i'       { $$ = Matriz.i(); }
  | 'j'       { $$ = Matriz.j(); }
  ;


print_statement
  : PRINT WORLD { world.print(); }
  ;

object : HERO | GOLD | WUMPUS;


%%

  /** referencia al analizador léxico
  **/
  private Lexer lexer ;

  private WumpusWorld world;

  /** constructor: crea el Interpreteranalizador léxico (lexer)
  **/
  public Parser(Reader r)
  {
     lexer = new Lexer(r, this);
     world = new WumpusWorld();
  }

  /** esta función se invoca por el analizador cuando necesita el
  *** siguiente token del analizador léxico
  **/
  private int yylex ()
  {
    int yyl_return = -1;

    try
    {
       yylval = new Object();
       yyl_return = lexer.yylex();
    }
    catch (IOException e)
    {
       System.err.println("error de E/S:"+e);
    }

    return yyl_return;
  }

  /** invocada cuando se produce un error
  **/
  public void yyerror (String descripcion, int yystate, int token)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     System.err.println ("Token leído : "+yyname[token]);
  }

  public void yyerror (String descripcion)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     //System.err.println ("Token leido : "+yyname[token]);
  }
