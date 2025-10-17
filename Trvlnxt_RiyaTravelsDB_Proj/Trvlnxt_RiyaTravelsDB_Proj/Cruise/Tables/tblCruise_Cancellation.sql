CREATE TABLE [Cruise].[tblCruise_Cancellation] (
    [Pkid]                 INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Policy]               VARCHAR (300)   NULL,
    [ChargesType]          VARCHAR (100)   NULL,
    [Cancellation_charges] DECIMAL (18, 2) NULL,
    [Cancellation_Hours]   DECIMAL (18, 2) NULL,
    [CreatedDate]          DATE            NULL,
    [IsActive]             BIT             NULL,
    [SupplierId]           VARCHAR (50)    NULL,
    [Fromdate]             DATE            NULL,
    [ToDate]               DATE            NULL,
    [ServiceType]          VARCHAR (50)    NULL,
    [CreatedBy]            NVARCHAR (50)   NULL,
    CONSTRAINT [PK_tblCruise_Cancellation] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

