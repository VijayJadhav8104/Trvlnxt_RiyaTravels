CREATE TABLE [dbo].[tbl_ForesightData] (
    [ForesightId]            BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Title]                  VARCHAR (50) NULL,
    [FirstName]              VARCHAR (50) NULL,
    [MiddleName]             VARCHAR (50) NULL,
    [LastName]               VARCHAR (50) NULL,
    [DOB]                    DATETIME     NULL,
    [Frequentflyer]          VARCHAR (50) NULL,
    [PassportNumber]         VARCHAR (50) NULL,
    [ExpiryDateofPassport]   DATETIME     NULL,
    [PassportIssuingCountry] VARCHAR (50) NULL,
    [Nationality]            VARCHAR (50) NULL,
    [EMPNO]                  VARCHAR (50) NULL,
    [InsertDateTime]         DATETIME     NULL,
    CONSTRAINT [PK_tbl_ForesightData] PRIMARY KEY CLUSTERED ([ForesightId] ASC)
);

