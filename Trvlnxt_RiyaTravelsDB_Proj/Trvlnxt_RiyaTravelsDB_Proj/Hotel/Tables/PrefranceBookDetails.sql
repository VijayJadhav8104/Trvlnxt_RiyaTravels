CREATE TABLE [Hotel].[PrefranceBookDetails] (
    [Id]                 INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingId]          VARCHAR (200)   NULL,
    [RoomName]           VARCHAR (500)   NULL,
    [CancellationPolicy] VARCHAR (MAX)   NULL,
    [Refundable]         BIT             NULL,
    [Refundability]      VARCHAR (150)   NULL,
    [Meal]               VARCHAR (300)   NULL,
    [Inclusion]          VARCHAR (MAX)   NULL,
    [ExpiryDate]         VARCHAR (150)   NULL,
    [SupplierName]       VARCHAR (150)   NULL,
    [SupplierRHID]       VARCHAR (200)   NULL,
    [IsActive]           BIT             CONSTRAINT [DF_PrefranceBookDetails_IsActive] DEFAULT ((1)) NULL,
    [InsertDate]         DATETIME        NULL,
    [Rate]               DECIMAL (18, 2) NULL,
    [RoomNumber]         VARCHAR (200)   NULL,
    CONSTRAINT [PK_PrefranceBookDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

