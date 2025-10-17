CREATE TABLE [dbo].[AirlineProductClass] (
    [ID]                    INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Airline]               VARCHAR (5)   NULL,
    [ProductName]           VARCHAR (50)  NULL,
    [ProductClass]          VARCHAR (5)   NULL,
    [ProductClassCombition] VARCHAR (100) NULL,
    [Status]                BIT           CONSTRAINT [DF_WS_AirlineProductClass_Status] DEFAULT ((1)) NULL,
    [InsertedOnDate]        DATETIME      CONSTRAINT [DF_Table_1_InsertedOnDateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_WS_AirlineProductClass] PRIMARY KEY CLUSTERED ([ID] ASC)
);

