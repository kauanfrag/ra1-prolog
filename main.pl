% Sistema Especialista - Escolha sua trilha 
% Autores: Kauan Fragoso, Lucas Maciel Cardoso, Kevyn Nícolas

:- dynamic resposta/2.

% trilhas
trilha(ciencia_de_dados, 'Analise e interpretacao de dados').
trilha(ciberseguranca, 'Protecao de sistemas contra acessos indevidos').
trilha(inteligencia_artificial, 'Modelos que aprendem a agir sozinhos').
trilha(back_end, 'Logica por tras das aplicacoes').
trilha(front_end, 'Experiência do usuário e design visual').

% perfis
perfil(ciencia_de_dados, estatistica, 5).
perfil(ciencia_de_dados, numeros, 4).
perfil(ciencia_de_dados, visualizacao_dados, 3).
perfil(ciencia_de_dados, excel, 3).

perfil(ciberseguranca, seguranca_digital, 5).
perfil(ciberseguranca, enigmas_logicos, 4).

perfil(inteligencia_artificial, machine_learning, 5).
perfil(inteligencia_artificial, autonomia_sistemas, 3).
perfil(inteligencia_artificial, raciocinio_logico, 2).

perfil(back_end, python, 5).
perfil(back_end, java, 5).
perfil(back_end, banco_de_dados, 5).
perfil(back_end, problemas_complexos, 3).

perfil(front_end, html_css, 5).
perfil(front_end, design_visual, 4).

% perguntas
pergunta(1, 'Voce gosta de estatistica?', estatistica).
pergunta(2, 'Voce gosta de resolver problemas com numeros?', numeros).
pergunta(3, 'Voce gosta de criar graficos e dashboards?', visualizacao_dados).
pergunta(4, 'Voce tem afinidade com Excel?', excel).

pergunta(5, 'Voce se interessa por seguranca digital?', seguranca_digital).
pergunta(6, 'Voce gosta de resolver enigmas logicos?', enigmas_logicos).

pergunta(7, 'Voce se interessa por machine learning?', machine_learning).
pergunta(8, 'Voce gosta de sistemas autonomos?', autonomia_sistemas).
pergunta(9, 'Voce tem facilidade com raciocinio logico?', raciocinio_logico).

pergunta(10, 'Voce gosta de programar em Python?', python).
pergunta(11, 'Voce gosta de programar em Java?', java).
pergunta(12, 'Voce se interessa por banco de dados?', banco_de_dados).
pergunta(13, 'Voce gosta de resolver problemas complexos?', problemas_complexos).

pergunta(14, 'Voce gosta de trabalhar com design visual?', design_visual).
pergunta(15, 'Voce tem afinidade com HTML e CSS?', html_css).

% soma
soma_lista([], 0).
soma_lista([X|Xs], T) :-
    soma_lista(Xs, P),
    T is X + P.

% inicio
iniciar :-
    retractall(resposta(_, _)),
    writeln('Bem-vindo ao sistema especialista!'),
    writeln('Responda com s ou n.'),
    faz_perguntas,
    recomenda(R),
    exibe_resultado(R).

faz_perguntas :-
    forall(pergunta(ID, Texto, _), perguntar(ID, Texto)).

perguntar(ID, Texto) :-
    write(Texto), write(' (s/n): '),
    read_line_to_string(user_input, S),
    string_lower(S, Resp),
    (Resp = "s" -> assertz(resposta(ID, s));
     Resp = "n" -> assertz(resposta(ID, n));
     writeln('Digite só s ou n please.'), perguntar(ID, Texto)).

% calculo
calcula_pontuacao(Trilha, Lista, Total) :-
    findall(P,
        (perfil(Trilha, Car, P),
         member(Car, Lista)),
        Pesos),
    soma_lista(Pesos, Total).

calcula_pontuacao(Trilha, P) :-
    findall(Car, (pergunta(ID, _, Car), resposta(ID, s)), Lista),
    calcula_pontuacao(Trilha, Lista, P).

% recomendacao
recomenda(Ranking) :-
    findall(P-Trilha, (trilha(Trilha, _), calcula_pontuacao(Trilha, P)), Pares),
    keysort(Pares, Ordenado),
    reverse(Ordenado, Desc),
    findall(T-P, member(P-T, Desc), Ranking).

% justificativa
justificativa(Trilha, Lista) :-
    findall(Texto,
        (perfil(Trilha, Car, _),
         pergunta(ID, Texto, Car),
         resposta(ID, s)),
        Lista).

% resultado
exibe_resultado([]) :- writeln('Nenhuma trilha foi encontrada').
exibe_resultado(R) :-
    R = [Melhor-P | _],
    write('Melhor trilha: '), writeln(Melhor),
    write('Ponto: '), writeln(P),
    writeln('Ranking:'),
    mostrar_ranking(R, 1),
    writeln('Justificativa:'),
    (justificativa(Melhor, L), L \= [] ->
        forall(member(T, L), (write('- '), writeln(T)));
        writeln('Nenhuma resposta positiva')).

mostrar_ranking([], _).
mostrar_ranking([T-P|R], N) :-
    write(N), write(') '), write(T), write(' - '), writeln(P),
    N1 is N+1,
    mostrar_ranking(R, N1).

% testes
run_test(Arq) :-
    retractall(resposta(_, _)),
    consult(Arq),
    recomenda(R),
    exibe_resultado(R),
    retractall(resposta(_, _)).





