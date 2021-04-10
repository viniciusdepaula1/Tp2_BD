CREATE DOMAIN TipoCPF AS VARCHAR(12);
CREATE DOMAIN TipoNome AS VARCHAR(30);
CREATE DOMAIN TipoEndereco AS VARCHAR (40);
CREATE DOMAIN TipoCodigo AS CHAR(10);

CREATE TABLE Medico (
	CPF 		TipoCPF 		NOT NULL, 
	CRM 		VARCHAR(6) 		NOT NULL, 
	Nome		TipoNome		NOT NULL,
	Endereço    TipoEndereco	NOT NULL,
	Sexo		CHAR,
	DataDeNascimento	DATE,

	CONSTRAINT PK_Medico PRIMARY KEY (CPF),
	CONSTRAINT CK_Sexo CHECK (Sexo = 'M' or Sexo = 'F')
);

CREATE TABLE Enfermeiro (
	CPF 		TipoCPF 		NOT NULL, 
	COREN 		VARCHAR(8) 		NOT NULL, 
	Nome		TipoNome		NOT NULL, 
	Endereço	TipoEndereco	NOT NULL, 
	Sexo		CHAR,
	DataDeNascimento	DATE,

	CONSTRAINT CK_Sexo CHECK (Sexo = 'M' or Sexo = 'F'),
	CONSTRAINT PK_Enfermeiro PRIMARY KEY (CPF)
); 

CREATE TABLE Paciente (
	CNS			      CHAR(32)     NOT NULL,
	Nome			  TipoNome	   NOT NULL,
 	DataDeNascimento  DATE         NOT NULL,
 	Altura			  FLOAT        NOT NULL,
 	Peso			  FLOAT	       NOT NULL,
	
	CONSTRAINT PK_Paciente PRIMARY KEY (CNS)
);

CREATE TABLE Triagem(
	CNS_Paciente		CHAR(32)	NOT NULL	unique,
	CPF_Enfermeiro		TipoCPF		NOT NULL	unique,
	T_Data				DATE		NOT NULL	unique,

	CONSTRAINT PK_Triagem PRIMARY KEY (CNS_Paciente, CPF_Enfermeiro, T_Data),
	CONSTRAINT FK_CNS_Paciente FOREIGN KEY (CNS_Paciente)
		REFERENCES Paciente (CNS),
	CONSTRAINT FK_CPF_Enfermeiro FOREIGN KEY (CPF_Enfermeiro)
		REFERENCES Enfermeiro (CPF)
);

CREATE TABLE Consulta (
	Codigo			TipoCodigo	   NOT NULL,
	C_Data			DATE		   NOT NULL,
	CNS_Paciente	CHAR(32)       NOT NULL,
	CPF_Enfermeiro 	TipoCPF        NOT NULL,
	T_Data			DATE		   NOT NULL,

	CONSTRAINT PK_Consulta PRIMARY KEY (Codigo),
	CONSTRAINT FK_CNS_Paciente FOREIGN KEY (CNS_Paciente)
		REFERENCES Triagem(CNS_Paciente),
	CONSTRAINT FK_CPF_Enfermeiro FOREIGN KEY (CPF_Enfermeiro)
		REFERENCES Triagem(CPF_Enfermeiro),
	CONSTRAINT FK_T_Data FOREIGN KEY (T_Data)
		REFERENCES Triagem(T_Data)
);

CREATE TABLE Realiza (
	Codigo_Consulta	TipoCodigo	  NOT NULL	unique,
	CPF_Medico		TipoCPF	  	  NOT NULL	unique,

	CONSTRAINT PK_Realiza PRIMARY KEY (Codigo_Consulta, CPF_Medico),
	CONSTRAINT FK_Código_Consulta FOREIGN KEY (Codigo_Consulta)
		REFERENCES Consulta (Codigo),
	CONSTRAINT FK_CPF_Medico FOREIGN KEY (CPF_Medico)
		REFERENCES Medico (CPF)
);

CREATE TABLE TipoDeTratamento (
	Codigo                      TipoCodigo          NOT NULL,
	Objetivo                    VARCHAR(30)   	 	NOT NULL,
	Nome				    	TipoNome            NOT NULL,
	DataDeInícioDoTratamento	DATE                NOT NULL,
	Codigo_Consulta	            TipoCodigo          NOT NULL,
	CPF_Medico		            TipoCPF	        	NOT NULL,

	CONSTRAINT PK_TipoDeTratamento PRIMARY KEY (Codigo),
	CONSTRAINT FK_Codigo_Consulta FOREIGN KEY (Codigo_Consulta)
		REFERENCES Realiza (Codigo_Consulta),
	CONSTRAINT FK_CPF_Medico FOREIGN KEY (CPF_Medico)
		REFERENCES Realiza (CPF_Medico)
);

CREATE TABLE RecursoTratamento (
	Recurso					VARCHAR(20)		NOT NULL,
	Codigo_TipoDeTratamento	TipoCodigo		NOT NULL,

	CONSTRAINT PK_RecursoTratamento PRIMARY KEY (Recurso, Codigo_TipoDeTratamento),
	CONSTRAINT FK_Codigo_TipoDeTramento FOREIGN KEY (Codigo_TipoDeTratamento)
		REFERENCES TipoDeTratamento (Codigo)
		ON DELETE CASCADE
);

CREATE TABLE Fabricante(
	Endereço       TipoEndereco         NOT NULL,
	CNPJ	       CHAR(14)             NOT NULL,
	
	CONSTRAINT PK_Fabricante PRIMARY KEY (CNPJ)
);

CREATE TABLE TipoDeVacina (
	Codigo             TipoCodigo       NOT NULL,
	Eficácia           VARCHAR(4),      
	Metodo_adm         VARCHAR(20)   	NOT NULL,
	Objetivo           VARCHAR(40)   	NOT NULL,
	Temperatura	       FLOAT            NOT NULL,
	
	CONSTRAINT PK_TipoDeVacina PRIMARY KEY (Codigo)
);

CREATE TABLE Fabrica (
	CNPJ_Fabricante       CHAR(14)         NOT NULL,
	CodigoVacina          TipoCodigo       NOT NULL,
	
	CONSTRAINT PK_Fabrica PRIMARY KEY (CNPJ_Fabricante, CodigoVacina),
	CONSTRAINT FK_CNPJ_Fabricante  FOREIGN KEY (CNPJ_Fabricante)
		REFERENCES Fabricante(CNPJ),
	CONSTRAINT PK_CodigoVacina FOREIGN KEY (CodigoVacina)
		REFERENCES TipoDeVacina(codigo)
		ON DELETE CASCADE
);

CREATE TABLE Refrigerador (
	Codigo                 TipoCodigo         NOT NULL,
	Capacidade             FLOAT              NOT NULL,
	TemperaturaMínima      FLOAT              NOT NULL,
	TemperaturaMáxima      FLOAT              NOT NULL,
	
	CONSTRAINT PK_Refrigerador PRIMARY KEY (Codigo)
);

CREATE TABLE Lote (
	Codigo                TipoCodigo        NOT NULL,
	QuantidadeAtual	   	  INT               NOT NULL,
	Validade              DATE              NOT NULL,
	DataDeRecebimento     DATE              NOT NULL,
	Codigo_Tipo         TipoCodigo        NOT NULL,
	
	CONSTRAINT PK_Lote  PRIMARY KEY (Codigo),
	CONSTRAINT FK_Codigo_Tipo  FOREIGN KEY (Codigo_Tipo)
		REFERENCES TipoDeVacina(codigo)
		ON DELETE CASCADE
);

CREATE TABLE Vacina (
	Codigo                 TipoCodigo          NOT NULL,
	Codigo_Lote		       TipoCodigo          NOT NULL,
	Codigo_Refrigerador    TipoCodigo          NOT NULL,
	CNS_Paciente           CHAR(32)            NOT NULL,
	CPF_Enfermeiro	       TipoCPF             NOT NULL,
	Dose_Aplicada	       INT,
	T_Data				   DATE 			   NOT NULL,

	CONSTRAINT PK_Vacina PRIMARY KEY (Codigo),     

	CONSTRAINT FK_Codigo_Lote  FOREIGN KEY (Codigo_Lote)
		REFERENCES Lote(Codigo),

	CONSTRAINT FK_Codigo_Refrigerador  FOREIGN KEY (Codigo_Refrigerador)
		REFERENCES Refrigerador(Codigo),

	CONSTRAINT FK_CNS_Paciente FOREIGN KEY (CNS_Paciente)
		REFERENCES Triagem (CNS_Paciente),

	CONSTRAINT FK_CPF_Enfermeiro FOREIGN KEY (CPF_Enfermeiro)
		REFERENCES Triagem (CPF_Enfermeiro),

	CONSTRAINT FK_T_Data FOREIGN KEY (T_Data)
		REFERENCES Triagem (T_Data) 
);

INSERT INTO Medico
VALUES ('3051569305', '090201', 'Jose da Silva', 'Rua da Bahia - Centro - BH - MG', 'M', '05/03/1992');
INSERT INTO Medico
VALUES ('71613971036', '235472', 'Maria de Jesus', 'Rua Espirito Santo - Centro - BH - MG', 'F', '18/03/1983');
INSERT INTO Medico
VALUES ('43139136021', '267224', 'Joao Ribeiro', 'Rua Rio de Janeiro - Centro - BH - MG', 'M', '29/06/1992');

INSERT INTO Enfermeiro
VALUES ('59469542029', '67224', 'Luiz Inacio', 'Rua Sao Paulo - Centro - BH - MG', 'M', '20/02/1992');
INSERT INTO Enfermeiro
VALUES ('08899837040', '32324', 'Reinaldo Azevedo', 'Rua Curitiba - Centro - BH - MG', 'M', '03/03/1992');
INSERT INTO Enfermeiro
VALUES ('16295286097', '43243', 'Aecio Neves', 'Avenida Parana - Centro - BH - MG', 'M', '03/03/1992');

INSERT INTO Paciente
VALUES ('34512964502114567935423745693400',  'Bruno Pacheco', '03/08/1992', '1.72', '72.5' );
INSERT INTO Paciente
VALUES ('38552964582114567935423745693400',  'Rodrigo Luiz', '06/08/1982', '1.79', '89.4' );
INSERT INTO Paciente
VALUES ('94518967502614569935423745693400',  'Abert Magno', '12/01/1990', '1.74', '60.3' );

INSERT INTO Triagem
VALUES ('34512964502114567935423745693400',  '16295286097',  '02/01/2021' );
INSERT INTO Triagem
VALUES ('94518967502614569935423745693400',  '59469542029',  '16/02/2021');
INSERT INTO Triagem
VALUES ('38552964582114567935423745693400',  '08899837040',  '28/03/2021');

INSERT INTO Consulta
VALUES ('1', '01/04/2021', '38552964582114567935423745693400', '08899837040', '28/03/2021' );
INSERT INTO Consulta
VALUES ('2',  '29/03/2021',  '94518967502614569935423745693400', '59469542029', '16/02/2021'  );
INSERT INTO Consulta
VALUES ('3',  '30/03/2021',  '34512964502114567935423745693400', '16295286097', '02/01/2021');

INSERT INTO Realiza
VALUES ('3', '43139136021');
INSERT INTO Realiza
VALUES ('1', '71613971036');
INSERT INTO Realiza
VALUES ('2', '3051569305');

INSERT INTO TipoDeTratamento
VALUES ('1', 'COVID-19', 'Covid Vitaminas', '02/04/2021', '1', '3051569305');
INSERT INTO TipoDeTratamento
VALUES ('2', 'Amigdalite', 'Antibiotico Amigdalite', '30/03/2021', '3', '43139136021');

INSERT INTO RecursoTratamento
VALUES ('BIO-C', '1');
INSERT INTO RecursoTratamento
VALUES ('AderaD3', '1');
INSERT INTO RecursoTratamento
VALUES ('Amoxicilina', '2');

INSERT INTO Fabricante
VALUES ('Rua do Caetes', '76557849000122');
INSERT INTO Fabricante
VALUES ('Rua Guaicurus', '75037954000178');
INSERT INTO Fabricante
VALUES ('Avenida dos Andradas', '03792885000105');

INSERT INTO TipoDeVacina
VALUES ('19643', '85%', 'Aplicar no Braço', 'gripe', '-18.24' );
INSERT INTO TipoDeVacina
VALUES ('3843', '65%', 'Aplicar no Braço', 'coronavirus', '-18.24' );
INSERT INTO TipoDeVacina
VALUES ('38339', '72%', 'Aplicar no Braço', 'coronavirus', '-10.14' );

INSERT INTO Refrigerador
VALUES ('1', '500', '-100', '0');
INSERT INTO Refrigerador
VALUES ('2', '300', '-50', '10');
INSERT INTO Refrigerador
VALUES ('3', '200', '-30', '20');

INSERT INTO Lote
VALUES ('4545', '200', '03/12/2021', '03/12/2020', '3843 ' );
INSERT INTO Lote
VALUES ('4546', '200', '03/10/2021', '03/10/2020', '38339' );
INSERT INTO Lote
VALUES ('4547', '200', '03/06/2021', '03/01/2021', '19643' );

INSERT INTO Fabrica
VALUES ('76557849000122', '38339' );
INSERT INTO Fabrica
VALUES ('75037954000178', '3843' );
INSERT INTO Fabrica
VALUES ('03792885000105', '19643');

INSERT INTO Vacina
VALUES ('120', '4545', '1', '34512964502114567935423745693400',  '16295286097', '1', '02/01/2021');
INSERT INTO Vacina
VALUES ('121', '4546', '2', '94518967502614569935423745693400',  '59469542029', '1', '16/02/2021');
INSERT INTO Vacina
VALUES ('122', '4547', '3', '38552964582114567935423745693400',  '08899837040',  '1', '28/03/2021');