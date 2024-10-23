select * from empregado; 
-- Relatório 1 - Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por data de admissão decrescente;
select cpf, nome, sexo, dataAdm, salario, Departamento_idDepartamento
from empregado
where dataAdm between '2023-01-01' and '2023-04-01';

-- Relatorio 2- Relatório 2 - Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por nome do empregado;
select cpf as "CPF", nome "Funcionário", sexo "Gênero", email "E-mail", comissao "Comissão", dataAdm "Data de Admissão" from empregado;
select avg(salario) as "Salário" from empregado
where salario < 3360
			order by nome;

-- Relatório 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, trazendo também a média salarial dos funcionários do departamento e a média de comissão recebida pelos empregados do departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comissão), ordenado por nome do departamento;
select
    dep.nome as "Nome Departamento", 
    COUNT(emp.Departamento_idDepartamento) as "Quantidade de Empregados", 
    avg(emp.salario) as "Media Salarial", 
    avg(emp.comissao) as "Media da Comissao"
from departamento as dep
left join empregado as emp on dep.idDepartamento = emp.Departamento_idDepartamento
group by dep.nome
order by dep.nome
limit 0, 500;

-- Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma do valor total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas;
select
    e.nome as "Nome do Empregado", 
    e.cpf as "CPF do Empregado", 
    e.sexo as "Gênero", 
    e.salario as "Salário", 
    count(v.idVenda) as "Quantidade Vendas", 
    sum(v.valor) as "Renda Bruta em Vendas", 
    sum(v.comissao) as "Comissão Total"
from
    empregado as e
inner join
    vendas as v on e.cpf = v.Empregado_cpf  
group by
    e.cpf, e.nome, e.sexo, e.salario  
order by
    COUNT(v.idVenda) desc;  
    
-- Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço), ordenado por quantidade total de vendas realizadas;
select * 
from
    servico as serv
left join 
    venda as vend on serv.idServico = vend.idVenda  
left join
    empregado as emp on vend.Empregado_cpf = emp.cpf
order by
    emp.cpf;  
    
-- Relatório 6 - Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do serviço da mais recente a mais antiga;

select 
pet.nome as "Nome do Pet",
v.data as "Data de Venda",
v.Cliente_cpf as "CPF do Cliente",
v.Empregado_cpf as 'CPF do Empregado', 
v.valor as 'Valor do Serviço'
from pet 
left join venda as v on pet.Cliente_cpf = v.Cliente_Cpf
where pet.nome = 'teo'
order by v.data desc;

-- Relatório 7 - Lista das vendas já realizados para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que realizou a venda), ordenado por data do serviço da mais recente a mais antiga;
select
    v.data as "Data da Venda", 
    v.valor as "Valor", 
    v.desconto as "Desconto", 
    (v.valor - v.desconto) as "Valor Final",  
    emp.nome as "Empregado que Realizou a Venda"
from
    venda as v
inner join 
    empregado as emp on v.Empregado_cpf = emp.cpf  
order by
    v.data desc;  
    
-- Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total dos valores de serviço vendido, trazendo as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;
select quantidade, servico_idServico, valor
from itensservico
order by quantidade desc
limit 10;

-- Relatório 9 - Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;
select
    tipo as "Forma de Pagamento", 
    count(Venda_idVenda) as "Quantidade de Vendas",
    concat("R$ ", FORMAT(SUM(valorPago), 2, 'de_DE')) as "Valor Total Vendido"
from
    formapgvenda
group by 
    tipo
order by
    count(Venda_idVenda) desc;  

-- Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas, Valor Total Venda), ordenado por Data Venda da mais recente a mais antiga;    
select 
    count(idVenda) as "quantidade de vendas do dia", 
    sum(valor) as "renda bruta", 
    data as "data"
from 
    venda
group by 
    data
order by 
    data desc;

-- Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas (Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto;
select 
    pro.nome as "nome produto", 
    concat('R$ ', format(sum(pro.valorVenda), 2, 'de_DE')) as "valor produto", 
    pro.marca as "categoria do produto",
    coalesce(max(frn.nome), 'sem registro') as "nome fornecedor", 
    coalesce(max(frn.email), 'sem registro') as "email fornecedor", 
    coalesce(max(tel.numero), 'sem registro') as "telefone fornecedor"
from 
    produtos pro
left join 
    itenscompra itc on itc.Produtos_idProduto = pro.idProduto
left join 
    compras com on com.idCompra = itc.Compras_idCompra
left join 
    fornecedor frn on frn.cpf_cnpj = com.Fornecedor_cpf_cnpj
left join 
    telefone tel on tel.Fornecedor_cpf_cnpj = frn.cpf_cnpj
group by 
    pro.idProduto
order by 
    pro.nome;  -- Ordenando por nome do produto
  
-- Relatório 12 - Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, Valor Total Recebido pela Venda do Produto), ordenado por quantidade de vezes que o produto participou em vendas;
select 
    pro.nome as "nome produto", 
    count(ivp.quantidade) as "quantidade (total) vendas", 
    concat('R$ ', format(sum(ivp.valor), 2, 'de_DE')) as "valor total recebido pela venda do produto"
from 
    produtos pro
join 
    itensvendaprod ivp on ivp.Produto_idProduto = pro.idProduto
group by 
    pro.nome
order by 
    count(ivp.quantidade) desc;  -- Ordenando pela quantidade total de vendas, da maior para a menor


