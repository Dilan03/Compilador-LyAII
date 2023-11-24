import compilerTools.TextColor;
import java.awt.Color;

%%
%class LexerColor
%type TextColor
%char
%{
    private TextColor textColor(long start, int size, Color color){
        return new TextColor((int) start, size, color);
    }
%}
/* Variables básicas de comentarios y espacios */
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
{Comentario} { return textColor(yychar, yylength(), new Color(146, 146, 146)); }
{EspacioEnBlanco} { /*Ignorar*/ }

/*Identificador*/
\VAR_{Identificador} { return textColor(yychar, yylength(), Color.orange); }

/*Tipos de dato*/
ente | real | bolo { return textColor(yychar, yylength(), Color.red); }

/*Entero*/
{Numero} { return textColor(yychar, yylength(), Color.cyan); }

/*Real*/
{Numero}"."{Numero} { return textColor(yychar, yylength(), Color.cyan); }

/*Boleano*/
"FAL"|"VER" { return textColor(yychar, yylength(), Color.green); }

/*Operadores de agrupacion*/
"(" | "(" | "}" | "}" { return textColor(yychar, yylength(), Color.blue); }

/*Signos de puntuacion*/
"," { /*Ignorar*/ }
";" { /*Ignorar*/ }

/*Operador de asignacion*/
--> { return textColor(yychar, yylength(), Color.blue); }

/*Estructura if*/
ysisi | ysino { return textColor(yychar, yylength(), Color.magenta); }

/* Operadores logicos */ 
"Y" | "O" { return textColor(yychar, yylength(), Color.orange); }

/*Final*/
final { return textColor(yychar, yylength(), Color.red); }

. { /* Ignorar */ }