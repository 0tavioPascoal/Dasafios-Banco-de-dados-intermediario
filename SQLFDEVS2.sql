-- Criando o banco de dados Loja

create database Loja;

-- Usando o banco de dados Loja

use Loja;

-- Criando as tabelas e seus relacionamentos

create table Categoria (
    Id int primary key identity(1,1),
    Nome varchar(100) NOT NULL
);


create table Produto (
    Id int primary key identity(1,1),
    Nome varchar(100) NOT NULL,
	ValorVenda int not null,
	ValorCusto int not null
);


create table ProdutoCategoria (
    ProdutoId int,
    CategoriaId int,
    foreign key (ProdutoId) references Produto(Id),
    foreign key (CategoriaId) references Categoria(Id)
);


create table ProdutoEstoque (
    ProdutoId int primary key,
    Quantidade int NOT NULL,
    foreign key (ProdutoId) references Produto(Id)
);

create table Cliente (
    Id int primary key identity(1,1),
    Titulo varchar(10),
    PrimeiroNome varchar(50) NOT NULL,
    MeioNome varchar(50),
    UltimoNome varchar(50) NOT NULL
);


-- Inserindo dados para podermos trabalhar...

insert into Categoria (Nome) 
	values ('Roupas'),('Eletronicos'),('Alimentos'); 

insert into Produto (Nome, ValorCusto, ValorVenda) 
	values ('Camiseta', 25.00, 50.00),
	('Notebook', 1500.00, 25000.00),
	('Arroz', 10.00, 40.00),
	('Calca', 20.00, 45.00);

insert into ProdutoCategoria (ProdutoId, CategoriaId) 
	values (1, 1),
	(2, 2),
	(3, 3),
	(4, 1);

insert into ProdutoEstoque (ProdutoId, Quantidade) 
	values (1, 50),
	(2, 10),
	(3, 100),
	(4, 30);

insert into Cliente (Titulo, PrimeiroNome, MeioNome, UltimoNome)
	values ('Sr.', 'Carlos', 'Henrique', 'Silva'),
	(NULL, 'Ana', NULL, 'Souza'),
	('Dra.', 'Beatriz', 'Fernanda', 'Lima'),
	(NULL, 'Jo�o', 'Pedro', 'Almeida');

-- conferir a insercao de dados

select * from Produto;
select * from ProdutoCategoria;
select * from ProdutoEstoque;
select * from Categoria;
select * from Cliente;

-- 1 => recuperar informacoes de produtos, categorias e estoque.

select p.nome NomeProduto, C.nome Categoria, pe.Quantidade QuantidadeEstoque
	from Produto p
	inner join ProdutoCategoria pc on p.Id = pc.ProdutoId
	inner join ProdutoEstoque pe on p.Id = pe.ProdutoId
	inner join Categoria c on pc.CategoriaId = c.Id;

-- 2 => Excluir todos os produtos da categoria 'Roupas'

-- Fazendo um select primeiro para poder ver quais dados serao apagados futuramente.
select p.Id, p.Nome, p.ValorCusto, p.ValorVenda
	from Produto p
	where Id in (
	 select pc.ProdutoId
	 from ProdutoCategoria pc
	 inner join Categoria c on pc.CategoriaId = c.Id
	 where c.Nome = 'Roupas'
	);

-- comando para apagar todos os produtos da categoria 'Roupas'
delete from ProdutoCategoria
where ProdutoId in (
    select PC.ProdutoId
    from ProdutoCategoria PC
    join Categoria C on PC.CategoriaId = C.Id
    where C.Nome = 'Roupas'
);


delete from Produto
	where Id in (
	select pc.ProdutoId
	from ProdutoCategoria pc
	join Categoria c on pc.CategoriaId = c.Id
	where c.Nome = 'Roupas'
	);

-- 3 => nomes completos de clientes com tratamento de nulos 


-- checar como esta os nomes
select cl.Titulo + ' ' +  cl.PrimeiroNome + ' ' + cl.MeioNome + ' ' + cl.UltimoNome as NomeCompleto
	from Cliente cl;
	

select distinct
    case
        when c.Titulo is null then ''
        else c.Titulo + ' '
    end +
    c.PrimeiroNome + ' ' +
    case 
        when c.MeioNome is null then ''
        else c.MeioNome + ' '
    end +
    c.UltimoNome as Nome_Completo
from 
    Cliente c;
