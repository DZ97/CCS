/*
N-rainhas
Dado um N, numero de rainhas, encontrar uma configuracao para 
 as n rainhas em um tabuleiro n x n
*/
include "globals.mzn";

%numero de rainhas
int : n;
 n = 10;
 
%vetor das rainhas, indice = linha,
% valor = coluna
array[1..n] of var 1..n : rainha;

/*
rainhas devem ter colunas distintas, os indices sao 
naturalmente distintos, portanto as linhas sao distintas
*/
constraint
          alldifferent(rainha);

/*
a distancia entre linhas de duas rainhas deve ser diferente 
da distancia entre colunas destas rainhas
ou seja, nao podem estar na mesma diagonal
*/
constraint
  forall( i in 1..n-1 )(
    forall( j in i+1..n ) (
      %% restricao nas diagonais ... parte superior e inferior
      ( ( rainha[i] - rainha[j] ) != ( i - j ) )
        /\ 
        ( ( rainha[j] - rainha[i] ) != ( i - j ) )
    )
  );


%%% Anotacao -- ann de codigo ou procedimento 
ann : search_EXPLORE;
%solve :: search_EXPLORE  maximize somaTotal;
solve :: search_EXPLORE satisfy; 

%% SELECT_VAR_INT={input_order, anti_first_fail, first_fail, smallest, largest, max_regret}
%% DOMAIN_VAR_INT={indomain, indomain_split, indomain_random, indomain_median, indomain_max, indomain_min}
%% DETAILS in http://www.minizinc.org/g12_www/zinc/doc-2.0/html/zinc-manual.html#htoc17

%% em arquivo separado
%search_EXPLORE = int_search( rainha, anti_first_fail, indomain_split, complete);
search_EXPLORE = int_search( rainha, first_fail, indomain_min, complete );
%search_EXPLORE = int_search( rainha, first_fail, indomain_max, complete );
%search_EXPLORE = int_search( rainha, first_fail, indomain_median, complete ) ;
%search_EXPLORE = int_search( rainha, first_fail, indomain_random, complete );

%%
%search_EXPLORE = int_search( rainha, input_order, indomain_median, complete );
%search_EXPLORE = int_search( rainha, input_order, indomain_max, complete );
%search_EXPLORE = int_search( rainha, anti_first_fail, indomain_median, complete );
%search_EXPLORE = int_search( rainha, anti_first_fail, indomain_random, complete ) ;
%search_EXPLORE = int_search( rainha, anti_first_fail, indomain_split, complete );

%%solve :: bool_search([LIST OF VARS], SELECT_VAR, DOMAIN_VAR, complete) minimize   COST_FUNCTION;
% EXAMPLE
%solve :: bool_search([ x[i,j] | i,j in 1..N ], input_order, indomain_min, complete) minimize  peso_tabuleiro;
%solve :: int_search([ x[i,j] | i,j in 1..N ], input_order, indomain_min, complete) minimize  peso_tabuleiro;
%%% SAIDA

output["Para N rainhas .....  temos:\n"]  ++
	[	if fix( rainha[i] ) = j then "R " else ". " endif ++
	 	if j = n then "\n" else "" endif
	|	i, j in 1..n
	];

