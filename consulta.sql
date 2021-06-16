## workshop - dados de vacinação/énóis
# como usar a linguagem sql para consultar dados de vacinação na base dos dados?

## códigos de municípios
# https://basedosdados.org/dataset/br-bd-diretorios-brasil
# https://console.cloud.google.com/bigquery?p=basedosdados&d=br_bd_diretorios_brasil&t=municipio&page=table

## sql
# para aquecer: exemplos de consulta de cidade

select *
from `basedosdados.br_bd_diretorios_brasil.municipio`

select id_municipio, municipio
from `basedosdados.br_bd_diretorios_brasil.municipio`
where municipio like '%josé dos campos%'

select uf, count(id_municipio) as total
from `basedosdados.br_bd_diretorios_brasil.municipio`
group by uf

select uf, count(id_municipio) as total
from `basedosdados.br_bd_diretorios_brasil.municipio`
group by uf
order by total desc

# desafios: qual o total de municípios cujo nome começa a palavra "santa" por estado?

select uf, count(id_municipio) as total
from `basedosdados.br_bd_diretorios_brasil.municipio`
where municipio like 'santa%'
group by uf
order by total desc

#####################

# vacinação
# https://basedosdados.org/dataset/br-ms-vacinacao-covid19
# https://console.cloud.google.com/bigquery?p=basedosdados&d=br_ms_vacinacao_covid19&t=microdados_vacinacao&page=table


# dicionário de dados
# https://opendatasus.saude.gov.br/dataset/b772ee55-07cd-44d8-958f-b12edd004e0b/resource/38ead83d-b115-4219-852e-7244792bc311/download/dicionario-de-dados-vacinacao.pdf

# > quais são os ceps com o maior número de vacinados?
# [que território esses ceps representam? área central, periferia?]
# para responder a segunda parte é necessário lidar com outras bases.
# lembrete: os números totais devem também ser ponderados pela população.

# a consulta abaixo conta o total de pacientes por cep em toda base de dados.
# desafio extra para a turma: em quais ceps estão em maior e menor quantidade entre os vacinados, em um certo município?

select cep_endereco, count(paciente.id_paciente) as total
from `basedosdados.br_ms_vacinacao_covid19.microdados_vacinacao` as vacinacao
inner join `basedosdados.br_ms_vacinacao_covid19.microdados_paciente` as paciente
on vacinacao.id_paciente = paciente.id_paciente
group by cep_endereco
order by total desc

# > a partir desse filtro por cep do paciente,
# qual é a raça/cor imunizada em maior número?
# 1 branca; 2 preta; 3 parda ; 4 amarela; 99 sem info
# partindo do pressuposto que os ceps anonimizados suprimem o final da sequência

select paciente.raca_cor,count(paciente.id_paciente) as total
from `basedosdados.br_ms_vacinacao_covid19.microdados_vacinacao` as vacinacao
inner join `basedosdados.br_ms_vacinacao_covid19.microdados_paciente` as paciente
on vacinacao.id_paciente = paciente.id_paciente
where paciente.cep_endereco like '20021%'
group by paciente.raca_cor

# outras perguntas que podem ser respondidas
## > qual é a velocidade da vacinação no município? [relação de tempo de aplicação entre 1ª e 2ª dose]
## e qual é a faixa etária mais imunizada no município
# peça ajuda e use o fórum: forum.jornalismodedados.org
