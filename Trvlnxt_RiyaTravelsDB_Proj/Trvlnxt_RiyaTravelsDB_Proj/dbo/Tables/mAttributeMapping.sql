CREATE TABLE [dbo].[mAttributeMapping] (
    [ID]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]    VARCHAR (10)  NULL,
    [Country]     VARCHAR (10)  NULL,
    [AirportType] VARCHAR (10)  NULL,
    [AirlineName] VARCHAR (MAX) NULL,
    [AgencyId]    VARCHAR (MAX) NULL,
    [AgencyNames] VARCHAR (MAX) NULL,
    [GDSType]     VARCHAR (10)  NULL,
    [CreatedBy]   INT           NOT NULL,
    [CreatedOn]   DATETIME2 (7) CONSTRAINT [DF_mAttributeMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]  INT           NULL,
    [ModifiedOn]  DATETIME2 (7) CONSTRAINT [DF_mAttributeMapping_ModifiedOn] DEFAULT (getdate()) NULL,
    [IsActive]    BIT           CONSTRAINT [DF_mAttributeMapping_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mAttributeMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

