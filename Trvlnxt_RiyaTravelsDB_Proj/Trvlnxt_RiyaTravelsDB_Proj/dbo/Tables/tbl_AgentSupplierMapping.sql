CREATE TABLE [dbo].[tbl_AgentSupplierMapping] (
    [Id]                  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]            NVARCHAR (50) NULL,
    [Country]             NVARCHAR (50) NULL,
    [AgentId]             VARCHAR (MAX) NULL,
    [AgencyName]          VARCHAR (MAX) NULL,
    [VendorId]            VARCHAR (MAX) NULL,
    [IsActive]            BIT           NULL,
    [Product]             VARCHAR (50)  NULL,
    [SupplierId]          VARCHAR (MAX) NULL,
    [ProfileId]           INT           NULL,
    [CancellationHours]   VARCHAR (MAX) CONSTRAINT [DF_tbl_AgentSupplierMapping_CancellationHours] DEFAULT ((0)) NULL,
    [PriceOptimizationOn] VARCHAR (100) NULL,
    [CreatedDate]         DATETIME      NULL,
    [CreatedBy]           VARCHAR (50)  NULL,
    [ModifiedBy]          VARCHAR (50)  NULL,
    [ModifiedDate]        DATETIME      NULL,
    CONSTRAINT [PK_tbl_AgentSupplierMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);

