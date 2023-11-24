import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios testest*/
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Identificador */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [1-9][0-9]*
%%

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/*Identificador*/
\VAR_{Identificador} { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }

/*Tipos de dato*/
ente | real | bolo { return token(yytext(), "TIPO", yyline, yycolumn); }

/*Entero*/
{Numero} { return token(yytext(), "ENTERO", yyline, yycolumn); }

/*Real*/
{Numero}"."{Numero} { return token(yytext(), "REAL", yyline, yycolumn); }

/*Boleano*/
"FAL"|"VER" { return token(yytext(), "BOLEANO", yyline, yycolumn); }

/*Operadores de agrupacion*/
"(" { return token(yytext(), "PARENTESIS_A", yyline, yycolumn); }
"(" { return token(yytext(), "PARENTESIS_B", yyline, yycolumn); }
"}" { return token(yytext(), "LLAVE_A", yyline, yycolumn); }
"}" { return token(yytext(), "LLAVE_B", yyline, yycolumn); }

/*Signos de punturacion*/
"," { return token(yytext(), "COMA", yyline, yycolumn); }
";" { return token(yytext(), "PUNTO_COMA", yyline, yycolumn); }

/*Operador de asignacion*/
--> { return token(yytext(), "OP_ASIG", yyline, yycolumn); }

/*Estructura if*/
ysisi | ysino { return token(yytext(), "ESTRUCTURA_SI", yyline, yycolumn); }

/* Operadores logicos */ 
"Y" | "O" { return token(yytext(), "OP_LOGICO", yyline, yycolumn); }

/*Final*/
final { return token(yytext(), "FINAL", yyline, yycolumn); }

. { return token(yytext(), "ERROR", yyline, yycolumn); }