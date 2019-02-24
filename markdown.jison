%lex
%%
\s+                   /* skip whitespace */
[\w\s\:\/\.\'\-]+     return 'TEXT';
"#"                   return 'HEADER1';
"*"                   return 'ASTERISK';
"["                   return 'LEFT-BRACKET';
"]"                   return 'RIGHT-BRACKET';
"("                   return 'LEFT-PARENTHESIS';
")"                   return 'RIGHT-PARENTHESIS';
"!"                   return 'EXCLAMATION';
">"                   return 'GREATER-THAN';
// "##"                  return 'HEADER2';
<<EOF>>               return 'EOF';

/lex

%start expressions

%% /* language grammar */

expressions
    : e EOF
        {console.log($1); return $1;}
    ;

e
:'HEADER1' 'TEXT'
{$$ = "<h1>"+$2+"</h1>";}

| 'HEADER1' 'HEADER1' 'TEXT'
{$$ = "<h2>"+$3+"</h2>";}

| 'HEADER1' 'HEADER1' 'HEADER1' 'TEXT'
{$$ = "<h3>"+$4+"</h3>";}

| 'ASTERISK' 'TEXT'
  {$$ = "<li>"+$2+"</li>";}

| 'ASTERISK' 'TEXT' 'ASTERISK'
  {$$ = "<i>"+$2+"</i>";}

| 'ASTERISK' 'ASTERISK' 'TEXT' 'ASTERISK' 'ASTERISK'
{$$ = "<b>"+$3+"</b>";}

| 'LEFT-BRACKET' 'TEXT' 'RIGHT-BRACKET' 'LEFT-PARENTHESIS' 'TEXT' 'RIGHT-PARENTHESIS'
{$$ = `<a href="${$5}">${$2}</a>`;}

| 'EXCLAMATION' 'LEFT-BRACKET' 'TEXT' 'RIGHT-BRACKET' 'LEFT-PARENTHESIS' 'TEXT' 'RIGHT-PARENTHESIS'
{$$ = `<p><img alt="${$3}" src="${$6}"></p>`;}

| 'GREATER-THAN' 'TEXT'
  {$$ = $2;}

| 'ASTERISK' 'ASTERISK' 'ASTERISK'
{$$ = "<hr>";}

| TEXT
  {$$ = yytext;}
;
