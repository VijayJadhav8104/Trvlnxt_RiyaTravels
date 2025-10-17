CREATE TABLE [dbo].[tblAgentServiceFeeMapping] (
    [ID]               INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentID]          INT             NULL,
    [AirportType]      VARCHAR (10)    NULL,
    [AirlineCategory]  VARCHAR (50)    NULL,
    [AirlineName]      VARCHAR (100)   NULL,
    [AirlineCode]      VARCHAR (10)    NULL,
    [AdultServiceFee]  DECIMAL (18, 2) NULL,
    [ChildServiceFee]  DECIMAL (18, 2) NULL,
    [InfantServiceFee] DECIMAL (18, 2) NULL,
    [InsertedDate]     DATETIME        NULL,
    CONSTRAINT [PK_tblAgentServiceFeeMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

