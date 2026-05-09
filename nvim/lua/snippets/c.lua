-- ~/.config/nvim/lua/snippets/c.lua
-- Versão 9.0 — snippets inteligentes para C de faculdade
-- rep_node: edita um campo e todos os iguais atualizam juntos

local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local rep = require("luasnip.extras").rep

ls.add_snippets("c", {

-- ══════════════════════════════════════════════════════════════════
-- ESTRUTURA BASE
-- ══════════════════════════════════════════════════════════════════

s("main", {
    t({ "#include <stdio.h>", "#include <stdlib.h>", "", "int main() {", "    " }),
    i(1, "// código aqui"),
    t({ "", "    return 0;", "}" }),
}),

s("vars", {
    t({
        "/* Variaveis em C - cola rapida:",
        "   int a = 0;             // inteiro",
        "   int a, b, c;           // varios inteiros",
        "   float preco = 0.0;     // decimal simples",
        "   double media = 0.0;    // decimal com mais precisao",
        "   char letra = 'A';      // um caractere",
        "   char texto[50] = \"\";  // texto/string, se precisar",
        "*/",
    }),
}),

s("vars3", {
    t("int "), i(1, "a"), t(" = "), i(2, "0"), t({ ";", "int " }),
    i(3, "b"), t(" = "), i(4, "0"), t({ ";", "float " }),
    i(5, "media"), t(" = "), i(6, "0.0"), t(";"),
}),

s("vi", {
    t("int "), i(1, "a"), t(" = "), i(2, "0"), t(";"),
}),

s("vii", {
    t("int "), i(1, "a"), t(", "), i(2, "b"), t(";"),
}),

s("vf", {
    t("float "), i(1, "x"), t(" = "), i(2, "0.0"), t(";"),
}),

s("vd", {
    t("double "), i(1, "x"), t(" = "), i(2, "0.0"), t(";"),
}),

s("vc", {
    t("char "), i(1, "c"), t(" = '"), i(2, "A"), t("';"),
}),

s("vs", {
    t("char "), i(1, "nome"), t("["), i(2, "50"), t("] = \""), i(3, ""), t("\";"),
}),

-- ══════════════════════════════════════════════════════════════════
-- ENTRADA COM VALIDAÇÃO (do/while + scanf)
-- ══════════════════════════════════════════════════════════════════

s("lein", {
    t("int "), i(1, "n"), t({ ";", "do {", '    printf("Digite ' }),
    i(2, "um valor inteiro"),
    t({ ': ");', "} while (scanf(\"%d\", &" }), rep(1), t(") != 1);"),
}),

s("lef", {
    t("float "), i(1, "n"), t({ ";", "do {", '    printf("Digite ' }),
    i(2, "um valor decimal"),
    t({ ': ");', "} while (scanf(\"%f\", &" }), rep(1), t(") != 1);"),
}),

-- ══════════════════════════════════════════════════════════════════
-- FUNÇÕES
-- ══════════════════════════════════════════════════════════════════

s("fun", {
    i(1, "float"), t(" "), i(2, "nomeFuncao"), t("("), i(3, "float a, float b"),
    t({ ") {", "    return " }), i(4, "a + b"), t({ ";", "}" }),
}),

s("funv", {
    t("void "), i(1, "nomeFuncao"), t("("), i(2, "int n"),
    t({ ") {", "    " }), i(3, "// código"), t({ "", "}" }),
}),

s("funmedia", {
    t({ "float calcularMedia(float a, float b, float c) {",
        "    return (a + b + c) / 3.0;",
        "}", "" }),
}),

s("funmaior", {
    t({ "float maior(float a, float b) {",
        "    return (a > b) ? a : b;",
        "}", "" }),
}),

-- ══════════════════════════════════════════════════════════════════
-- ESTRUTURAS DE CONTROLE
-- ══════════════════════════════════════════════════════════════════

s("seif", {
    t("if ("), i(1, "condicao"), t({ ") {", "    " }),
    i(2, "// verdadeiro"),
    t({ "", "} else if (" }), i(3, "outra"), t({ ") {", "    " }),
    i(4, "// outro caso"),
    t({ "", "} else {", "    " }), i(5, "// falso"),
    t({ "", "}" }),
}),

-- for com rep_node: variável i sincronizada em todos os lugares
s("paraf", {
    t("for (int "), i(1, "i"), t(" = "), i(2, "0"),
    t("; "), rep(1), t(" < "), i(3, "10"),
    t("; "), rep(1), t({ "++) {", "    " }),
    i(4, "// código"),
    t({ "", "}" }),
}),

s("enquanto", {
    t("while ("), i(1, "condicao"), t({ ") {", "    " }),
    i(2, "// código"),
    t({ "", "}" }),
}),

s("dowhile", {
    t({ "do {", "    " }), i(1, "// código"),
    t({ "", "} while (" }), i(2, "condicao"), t(");"),
}),

s("switch", {
    t("switch ("), i(1, "opcao"), t({ ") {", "    case " }),
    i(2, "1"), t({ ":", "        " }), i(3, "// caso 1"),
    t({ "", "        break;", "    case " }),
    i(4, "2"), t({ ":", "        " }), i(5, "// caso 2"),
    t({ "", "        break;", "    default:", "        " }), i(6, "// inválido"),
    t({ "", "        break;", "}" }),
}),

-- ══════════════════════════════════════════════════════════════════
-- MENU INTERATIVO (loop + switch + funções)
-- ══════════════════════════════════════════════════════════════════

s("menu", {
    t({ "int opcao;", "", "do {",
        '    printf("\\n=== MENU ===\\n");',
        '    printf("1 - ' }), i(1, "Opcao um"), t({ '\\n");',
        '    printf("2 - ' }), i(2, "Opcao dois"), t({ '\\n");',
        '    printf("0 - Sair\\n");',
        '    printf("Escolha: ");',
        '    scanf("%d", &opcao);', "",
        "    switch (opcao) {",
        "        case 1:", "            " }), i(3, "// chama funcao 1"),
    t({ "", "            break;",
        "        case 2:", "            " }), i(4, "// chama funcao 2"),
    t({ "", "            break;",
        "        case 0:",
        '            printf("Saindo...\\n");',
        "            break;",
        "        default:",
        '            printf("Opcao invalida!\\n");',
        "    }",
        "", "} while (opcao != 0);" }),
}),

-- ══════════════════════════════════════════════════════════════════
-- ALGORITMOS PRONTOS
-- ══════════════════════════════════════════════════════════════════

s("media", {
    t({ "float n1, n2, n3, media;", "",
        'printf("Nota 1: "); scanf("%f", &n1);',
        'printf("Nota 2: "); scanf("%f", &n2);',
        'printf("Nota 3: "); scanf("%f", &n3);', "",
        "media = (n1 + n2 + n3) / 3.0;",
        'printf("Media: %.2f\\n", media);', "",
        'if      (media >= 7.0) printf("Aprovado\\n");',
        'else if (media >= 5.0) printf("Recuperacao\\n");',
        'else                   printf("Reprovado\\n");' }),
}),

s("areac", {
    t({ "float raio, area;",
        'printf("Raio: "); scanf("%f", &raio);', "",
        "area = 3.14159 * raio * raio;",
        'printf("Area do circulo: %.2f\\n", area);' }),
}),

s("arear", {
    t({ "float base, altura, area;",
        'printf("Base: ");   scanf("%f", &base);',
        'printf("Altura: "); scanf("%f", &altura);', "",
        "area = base * altura;",
        'printf("Area do retangulo: %.2f\\n", area);' }),
}),

s("areat", {
    t({ "float base, altura, area;",
        'printf("Base: ");   scanf("%f", &base);',
        'printf("Altura: "); scanf("%f", &altura);', "",
        "area = (base * altura) / 2.0;",
        'printf("Area do triangulo: %.2f\\n", area);' }),
}),

s("areatrap", {
    t({ "float b1, b2, altura, area;",
        'printf("Base maior: "); scanf("%f", &b1);',
        'printf("Base menor: "); scanf("%f", &b2);',
        'printf("Altura: ");     scanf("%f", &altura);', "",
        "area = ((b1 + b2) * altura) / 2.0;",
        'printf("Area do trapezio: %.2f\\n", area);' }),
}),

s("imc", {
    t({ "float peso, altura, imc;",
        'printf("Peso (kg): "); scanf("%f", &peso);',
        'printf("Altura (m): "); scanf("%f", &altura);', "",
        "imc = peso / (altura * altura);",
        'printf("IMC: %.2f\\n", imc);', "",
        'if      (imc < 18.5) printf("Abaixo do peso\\n");',
        'else if (imc < 25.0) printf("Normal\\n");',
        'else if (imc < 30.0) printf("Sobrepeso\\n");',
        'else                 printf("Obesidade\\n");' }),
}),

s("celsius", {
    t({ "float c, f, k;",
        'printf("Celsius: "); scanf("%f", &c);', "",
        "f = (c * 9.0 / 5.0) + 32;",
        "k = c + 273.15;",
        'printf("Fahrenheit: %.2f\\n", f);',
        'printf("Kelvin:     %.2f\\n", k);' }),
}),

s("maiorm", {
    t({ "float a, b, c, maior;",
        'printf("Tres numeros: "); scanf("%f %f %f", &a, &b, &c);', "",
        "maior = a;",
        "if (b > maior) maior = b;",
        "if (c > maior) maior = c;",
        'printf("Maior: %.2f\\n", maior);' }),
}),

-- vetor: rep_node sincroniza nome e tamanho
s("vetor", {
    t("int "), i(1, "v"), t("["), i(2, "10"), t({ "], i;", "" }),
    t({ "for (i = 0; i < " }), rep(2), t({ "; i++) {", '    printf("v[%d]: ", i);' }),
    t({ "", "    scanf(\"%d\", &" }), rep(1), t({ "[i]);", "}", "" }),
    t({ "for (i = 0; i < " }), rep(2), t({ "; i++)", '    printf("v[%d] = %d\\n", i, ' }),
    rep(1), t({ "[i]);" }),
}),

-- ══════════════════════════════════════════════════════════════════
-- STRUCT
-- ══════════════════════════════════════════════════════════════════

s("struct", {
    t({ "typedef struct {", "    " }),
    i(1, "char nome[50]"), t({ ";", "    " }),
    i(2, "float nota"), t({ ";", "} " }),
    i(3, "Aluno"), t(";"),
}),

-- strucle: rep_node sincroniza nome da variável e do tipo
s("strucle", {
    i(1, "Aluno"), t(" "), i(2, "a"), t({ ";", "" }),
    t('printf("Nome: ");  scanf("%s",  '), rep(2), t({ ".nome);", "" }),
    t('printf("Nota: ");  scanf("%f", &'), rep(2), t({ ".nota);", "" }),
    t('printf("\\n%s — %.2f\\n", '), rep(2), t(".nome, "), rep(2), t(".nota);"),
}),

-- ══════════════════════════════════════════════════════════════════
-- ARQUIVOS
-- ══════════════════════════════════════════════════════════════════

s("farq", {
    t('FILE *'), i(1, "arq"), t(' = fopen("'), i(2, "dados.txt"), t('", "'), i(3, "w"), t({ '");', "" }),
    t("if ("), rep(1), t({ " == NULL) {", '    printf("Erro ao abrir!\\n");', "    return 1;", "}", "" }),
    t("fprintf("), rep(1), t(', "'), i(4, "%s\\n"), t('", '), i(5, "variavel"), t({ ");", "" }),
    t("fclose("), rep(1), t(");"),
}),

s("farql", {
    t('FILE *'), i(1, "arq"), t(' = fopen("'), i(2, "dados.txt"), t({ '", "r");', "" }),
    t("if ("), rep(1), t({ " == NULL) {", '    printf("Erro ao abrir!\\n");', "    return 1;", "}", "" }),
    t("char "), i(3, "linha"), t({ "[256];", "" }),
    t("while (fgets("), rep(3), t(", sizeof("), rep(3), t("), "), rep(1), t({ ") != NULL)", '    printf("%s", ' }),
    rep(3), t({ ");", "" }),
    t("fclose("), rep(1), t(");"),
}),

-- ══════════════════════════════════════════════════════════════════
-- PRINTF RÁPIDO
-- ══════════════════════════════════════════════════════════════════

s("pf",  { t('printf("'), i(1, "msg"), t('\\n");') }),
s("pfd", { t('printf("'), i(1, "var"), t(': %d\\n", '), i(2, "var"), t(");") }),
s("pff", { t('printf("'), i(1, "var"), t(': %.2f\\n", '), i(2, "var"), t(");") }),
s("pfs", { t('printf("'), i(1, "var"), t(': %s\\n", '), i(2, "var"), t(");") }),

})
