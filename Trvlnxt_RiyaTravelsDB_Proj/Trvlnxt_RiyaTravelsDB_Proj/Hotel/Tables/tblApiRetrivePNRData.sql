CREATE TABLE [Hotel].[tblApiRetrivePNRData] (
    [id]                INT             IDENTITY (1, 1) NOT NULL,
    [PNR]               VARCHAR (100)   NULL,
    [OfficeId]          VARCHAR (150)   NULL,
    [SSTS]              VARCHAR (MAX)   NULL,
    [AgentId]           VARCHAR (80)    NULL,
    [CreatedDate]       DATETIME        NULL,
    [UpdatedDate]       DATETIME        NULL,
    [Currency]          VARCHAR (100)   NULL,
    [Amount]            DECIMAL (18, 2) NULL,
    [CancellationToken] VARCHAR (100)   NULL
);

