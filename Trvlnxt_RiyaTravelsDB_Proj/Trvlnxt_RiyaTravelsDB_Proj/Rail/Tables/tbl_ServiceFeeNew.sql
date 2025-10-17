CREATE TABLE [Rail].[tbl_ServiceFeeNew] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [MarketPoint]         VARCHAR (30)   NULL,
    [UserType]            VARCHAR (30)   NULL,
    [IssuanceFrom]        DATETIME       NULL,
    [IssuanceTo]          DATETIME       NULL,
    [Origin]              VARCHAR (30)   NULL,
    [Destination]         VARCHAR (30)   NULL,
    [GST]                 VARCHAR (30)   NULL,
    [ServiceType]         VARCHAR (50)   NULL,
    [isActive]            BIT            NULL,
    [CreatedDate]         DATETIME       NULL,
    [ModifiedDate]        DATETIME       NULL,
    [CreatedBy]           VARCHAR (50)   NULL,
    [ModifyBy]            VARCHAR (50)   NULL,
    [AgentId]             VARCHAR (300)  NULL,
    [Fk_SupplierMasterId] VARCHAR (20)   NULL,
    [ServiceFeesType]     VARCHAR (50)   NULL,
    [FixedServiceFeesAmt] DECIMAL (8, 2) NULL,
    [AgencyName]          VARCHAR (200)  NULL,
    [GSTServiceFees]      VARCHAR (50)   NULL
);

