CREATE TABLE [Hotel].[SupplierErrorMapping] (
    [Id]                 INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProviderMessage]    VARCHAR (1700) NULL,
    [ErrorCode]          VARCHAR (500)  NULL,
    [IsActive]           BIT            CONSTRAINT [DF_SupplierErrorMapping_IsActive] DEFAULT ((1)) NULL,
    [InsertedDate]       DATETIME       CONSTRAINT [DF_SupplierErrorMapping_InsertedDate] DEFAULT (getdate()) NULL,
    [ErrorMessage]       VARCHAR (1700) NULL,
    [UpdatedBy]          INT            NULL,
    [Provider]           VARCHAR (500)  NULL,
    [UpdatedDate]        DATETIME       NULL,
    [MethodName]         VARCHAR (200)  NULL,
    [CorrelationId]      VARCHAR (150)  NULL,
    [BookingReference]   VARCHAR (150)  NULL,
    [ActualErrorMessage] VARCHAR (1700) NULL,
    [HotelId]            VARCHAR (50)   NULL,
    CONSTRAINT [PK_SupplierErrorMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-composite_unique_Index]
    ON [Hotel].[SupplierErrorMapping]([ProviderMessage] ASC, [ErrorCode] ASC, [ErrorMessage] ASC, [Provider] ASC, [MethodName] ASC) WITH (FILLFACTOR = 95);

