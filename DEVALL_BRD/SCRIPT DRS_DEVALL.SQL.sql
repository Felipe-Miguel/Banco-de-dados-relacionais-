/*
Este select simples é usado para resgatar informações principais de usuários que
possuem mais de 40 anos com o intuito de analisar a quantidade de pessoas mais 
velhas que utilizam o aplicativo, tirando como conclusão a maior praticidade com 
a tecnologia utilizada.
*/
SELECT  NM_USUARIO NOME,
        DS_EMAIL EMAIL,
        NR_CPF CPF,
        TRUNC(MONTHS_BETWEEN (SYSDATE,DT_NASCIMENTO) / 12) IDADE
FROM T_DIN_USUARIO
WHERE TRUNC(MONTHS_BETWEEN (SYSDATE,DT_NASCIMENTO) / 12)>=40
ORDER BY IDADE
;

/*
Este select envolvendo 1+ tabelas é utilizado para consultar os dados
de entregas concluidas, contando com o usuário do pedido, o telefone do mesmo,
o endereco, o conteudo enviado, a data de conclusao do envio e o preço do envio.
*/
SELECT  USU.NM_USUARIO NOME,
        TEL.NR_DDD "DDD",
        TEL.NR_TELEFONE "NUMERO DE TELEFONE",
        END.NM_LOGRADOURO "LOGRADOURO",
        END.NR_LOGRADOURO "NUMERO DO LOGRADOURO",
        END.NR_CEP "CEP",
        PAC.DS_CONTEUDO "DESCRICAO DO CONTEUDO",
        ENT.DT_CONCLUSAO "DATA DA ENTREGA",
        ENT.VL_PRECO "VALOR DO PEDIDO"
FROM T_DIN_TELEFONE TEL INNER JOIN T_DIN_USUARIO USU
ON ( TEL.ID_USUARIO = USU.ID_USUARIO) INNER JOIN T_DIN_ENTREGA ENT
ON ( USU.ID_USUARIO = ENT.ID_USUARIO) INNER JOIN T_DIN_ENTREGA_ENDERECO EE
ON (ENT.ID_ENTREGA = EE.ID_ENTREGA) INNER JOIN T_DIN_ENDERECO END
ON (EE.ID_ENDERECO = END.ID_ENDERECO) INNER JOIN T_DIN_PACOTE PAC
ON (ENT.ID_PACOTE = PAC.ID_PACOTE)
WHERE ENT.ST_ENTREGA = 'C' AND EE.TP_ENDERECO = 'R'
ORDER BY ENT.DT_CONCLUSAO;

/*
    Este select envolvendo função de grupo e agrupamento serve para consultar
    o valor total de lucros e potencial de lucros obtido por todas as entregas, 
    mostrando todo o capital já obtido com envios concluídos e também possíveis
    valores ganhos com entregas em andamento(em viagem).
*/
SELECT  SUM(VL_PRECO) "VALOR TOTAL",
        CASE ST_ENTREGA 
        WHEN 'C' then 'Concluido'
        WHEN 'V' then 'Em viagem' end as "STATUS DE ENTREGA"
FROM T_DIN_ENTREGA
WHERE ST_ENTREGA = 'C' OR ST_ENTREGA ='V'
GROUP BY ST_ENTREGA;

/* Este select utilizando função de grupo, agrupamento com filtro (having) e 
junção de tabelas é utilizado para consultar a qunatidade de pedidos/entregas 
por cada estado, tendo uma dimensão de quais regiões o site é mais utilizado.
*/
SELECT  ES.NM_ESTADO "ESTADO",
        COUNT(ENT.ID_ENTREGA) "TOTAL DE ENTREGAS"
FROM T_DIN_USUARIO US INNER JOIN T_DIN_ENTREGA ENT
ON ( US.ID_USUARIO = ENT.ID_USUARIO) INNER JOIN T_DIN_ENTREGA_ENDERECO EE
ON ( ENT.ID_ENTREGA = EE.ID_ENTREGA) INNER JOIN T_DIN_ENDERECO EN
ON ( EE.ID_ENDERECO = EN.ID_ENDERECO) INNER JOIN T_DIN_CIDADE CI
ON (EN.ID_CIDADE = CI.ID_CIDADE) INNER JOIN T_DIN_ESTADO ES
ON (CI.ID_ESTADO = ES.ID_ESTADO)
GROUP BY ES.NM_ESTADO
HAVING COUNT(*) >= 1
ORDER BY COUNT(ENT.ID_ENTREGA) DESC;
