" =============================================================================
" SINTAXE PORTUGOL (after/syntax/portugol.vim)
" =============================================================================
" Destaque de sintaxe pra Portugol (VisuAlg / PortugolStudio)
" Usado em disciplinas de algoritmos no IFAC e outras instituições BR.

if exists("b:current_syntax")
    finish
endif

" Palavras-chave principais
syntax keyword portugolKeyword
    \ algoritmo fimalgoritmo
    \ inicio fim
    \ var const
    \ procedimento funcao fimfuncao fimprocedimento retorne
    \ se entao senao fimse
    \ escolha caso outrocaso fimescolha
    \ enquanto faca fimenquanto
    \ para ate passo fimpara
    \ repita ate
    \ interrompa
    \ escreva escreval leia
    \ verdadeiro falso

" Tipos de dados
syntax keyword portugolType
    \ inteiro real logico caractere
    \ vetor matriz string

" Operadores lógicos
syntax keyword portugolOperator
    \ e ou nao xou

" Operadores de comparação
syntax match portugolCompare /[<>]=\?/
syntax match portugolCompare /[<>]/
syntax match portugolCompare /=/
syntax match portugolCompare /<>/

" Strings (entre " " e ' ')
syntax region portugolString start=/"/ end=/"/
syntax region portugolString start=/'/ end=/'/

" Números
syntax match portugolNumber /\<\d\+\(\.\d\+\)\?\>/

" Comentários (// e { })
syntax match portugolComment /\/\/.*/
syntax region portugolComment start=/{/ end=/}/

" Funções matemáticas comuns
syntax keyword portugolBuiltin
    \ abs arccos arcsen arctan cos exp int log logn pi quadrado raizq sen tan
    \ compr copia maiusc minusc numpcarac

" Links de highlight
highlight link portugolKeyword  Keyword
highlight link portugolType     Type
highlight link portugolOperator Operator
highlight link portugolCompare  Operator
highlight link portugolString   String
highlight link portugolNumber   Number
highlight link portugolComment  Comment
highlight link portugolBuiltin  Function

let b:current_syntax = "portugol"
