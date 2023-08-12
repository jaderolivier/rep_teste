-- Criando o banco de dados
CREATE DATABASE ExemploDB;

-- Setando o banco para uso
USE ExemploDB;

CREATE TABLE Clientes (
    ID INT PRIMARY KEY identity(1,1),
    Nome VARCHAR(100),
    Email VARCHAR(100),
	GastoAcumulado DECIMAL(10, 2)
);

CREATE TABLE Pedidos (
    ID INT PRIMARY KEY,
    ClienteID INT,
    DataPedido DATE,
    ValorTotal DECIMAL(10, 2),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ID)
);

------------
-- Inserir dados na tabela Clientes
INSERT INTO Clientes (Nome, Email, GastoAcumulado)
VALUES
    ('João Silva', 'joao@example.com', 0),
    ('Maria Santos', 'maria@example.com', 0),
    ('Carlos Ferreira', 'carlos@example.com', 0),
    ('Ana Oliveira', 'ana@example.com', 0),
    ('Rafael Souza', 'rafael@example.com', 0),
    ('Lúcia Rodrigues', 'lucia@example.com', 0),
    ('Pedro Alves', 'pedro@example.com',0),
    ('Isabela Costa', 'isabela@example.com',0),
    ('Gustavo Pereira', 'gustavo@example.com',0),
    ('Sara Martins', 'sara@example.com',0)
;

-- Inserir dados na tabela Pedidos
INSERT INTO Pedidos (ID, ClienteID, DataPedido, ValorTotal)
VALUES
    (1, 1, '2023-08-09', 150.00),
    (2, 2, '2023-08-09', 230.50),
    (3, 1, '2023-08-08', 75.20),
    (4, 3, '2023-08-08', 420.75),
    (5, 4, '2023-08-07', 89.99),
    (6, 2, '2023-08-06', 550.20),
    (7, 5, '2023-08-05', 312.80),
    (8, 6, '2023-08-04', 178.50),
    (9, 7, '2023-08-03', 750.30),
    (10, 1, '2023-08-02', 960.00)
;

------------
-- Consulta para listar todos os clientes
SELECT * FROM Clientes;

-- Consulta para listar os pedidos de um cliente específico
SELECT * FROM Pedidos WHERE ClienteID = 1;

-- Ser sempre o mais específico possível
SELECT ID, ClienteID  -- em coluna
  FROM Pedidos 
 WHERE ClienteID = 1; -- em linhas
 
------------
-- Criando uma view para mostrar detalhes dos pedidos de um cliente
CREATE VIEW DetalhesPedidosCliente AS
SELECT c.Nome, p.DataPedido, p.ValorTotal
FROM Clientes c
INNER JOIN Pedidos p ON c.ID = p.ClienteID;

SELECT * FROM DetalhesPedidosCliente;

------------
-- Criando uma função que calcula o total de pedidos de um cliente
CREATE FUNCTION CalcularTotalPedidos(@clienteID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total DECIMAL(10, 2);
    SELECT @total = SUM(ValorTotal)
    FROM Pedidos
    WHERE ClienteID = @clienteID;
    RETURN @total;
END;

-- Selecionando o total de pedidos de um cliente usando a função
SELECT
    ID AS ClienteID,
    Nome,
    Email,
    dbo.CalcularTotalPedidos(ID) AS TotalPedidos
FROM Clientes;

------------
-- Criando uma procedure para inserir um novo cliente
CREATE PROCEDURE InserirCliente
    @nome VARCHAR(100),
    @email VARCHAR(100),
	@gasto DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Clientes (Nome, Email, GastoAcumulado)
    VALUES (@nome, @email, @gasto);
END;

-- Executar a Procedure para inserir um novo cliente
EXEC InserirCliente
    @nome = 'Alex Souza \aiiuyoiui',
    @email = '89809809@gmail.com',
	@gasto = 10;

SELECT * FROM Clientes;

------------
-- Criando uma trigger para atualizar o valor total quando um novo pedido é inserido
CREATE TRIGGER AtualizarGastoAcumulado
ON Pedidos
AFTER INSERT
AS
BEGIN
    DECLARE @ClienteID INT, @ValorTotal DECIMAL(10, 2);
    
    -- Obter o ClienteID e ValorTotal do novo pedido inserido
    SELECT @ClienteID = i.ClienteID, @ValorTotal = i.ValorTotal
    FROM inserted i;

    -- Atualizar o GastoAcumulado do cliente correspondente
    UPDATE Clientes
    SET GastoAcumulado = GastoAcumulado + @ValorTotal
    WHERE ID = @ClienteID;
END;


-- Consultando antes
select * from Pedidos;
select * from Clientes;

-- Inserindo dados em pedido
INSERT INTO Pedidos VALUES (11, 1, '2023-08-10', 150.50);
INSERT INTO Pedidos VALUES (12, 2, '2023-08-10', 200.00);
INSERT INTO Pedidos VALUES (13, 1, '2023-08-10', 49.50);
INSERT INTO Pedidos VALUES (14, 4, '2023-08-09', 20.50);

-- Consultando depois
select * from Pedidos;
select * from Clientes;