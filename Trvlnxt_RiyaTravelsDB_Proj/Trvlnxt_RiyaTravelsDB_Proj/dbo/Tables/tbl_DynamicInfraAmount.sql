CREATE TABLE [dbo].[tbl_DynamicInfraAmount] (
    [ID]              BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]        VARCHAR (20)    NOT NULL,
    [Country]         VARCHAR (20)    NOT NULL,
    [AirportType]     VARCHAR (10)    NOT NULL,
    [Amount]          DECIMAL (18, 2) CONSTRAINT [DF__tbl_Dynam__Amoun__69141B8C] DEFAULT ((0)) NULL,
    [Airline]         VARCHAR (10)    NOT NULL,
    [CheckFormSector] VARCHAR (20)    CONSTRAINT [DF__tbl_Dynam__Check__6A083FC5] DEFAULT (NULL) NULL,
    [isActive]        BIT             NULL,
    CONSTRAINT [PK_tbl_DynamicInfraAmount] PRIMARY KEY CLUSTERED ([ID] ASC)
);

