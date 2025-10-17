CREATE TABLE [Hotel].[LFSDetails] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [PKID]             INT             NULL,
    [LastCheckDate]    DATETIME        NULL,
    [BookingId]        VARCHAR (300)   NULL,
    [Remark]           VARCHAR (MAX)   NULL,
    [MethodCheck]      VARCHAR (300)   NULL,
    [TotalCheckCount]  INT             CONSTRAINT [DF_LFSDetails_Count] DEFAULT ((0)) NULL,
    [Rate]             VARCHAR (250)   NULL,
    [SupplierName]     VARCHAR (300)   NULL,
    [IsRateCompatible] BIT             NULL,
    [PreviousRate]     VARCHAR (250)   NULL,
    [Profit]           DECIMAL (18, 2) CONSTRAINT [DF_LFSDetails_Profit] DEFAULT ((0)) NULL,
    [LFSToken]         VARCHAR (300)   NULL,
    CONSTRAINT [PK_LFSDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

