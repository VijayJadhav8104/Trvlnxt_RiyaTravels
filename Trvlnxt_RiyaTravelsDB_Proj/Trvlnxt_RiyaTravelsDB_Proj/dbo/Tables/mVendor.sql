CREATE TABLE [dbo].[mVendor] (
    [ID]                INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Product]           VARCHAR (10)  NULL,
    [VendorName]        VARCHAR (500) NULL,
    [PersonName]        VARCHAR (200) NULL,
    [ContactNo]         VARCHAR (50)  NULL,
    [EmailId]           VARCHAR (50)  NULL,
    [Fields]            VARCHAR (MAX) NULL,
    [AirlineCode]       VARCHAR (MAX) NULL,
    [OfficeId]          VARCHAR (MAX) NULL,
    [IsMultipleAirline] BIT           NULL,
    [Username]          VARCHAR (200) NULL,
    [Password]          VARCHAR (200) NULL,
    [Commission_Net]    VARCHAR (50)  NULL,
    [CreatedOn]         DATETIME2 (7) CONSTRAINT [DF_mVendor_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         INT           NOT NULL,
    [ModifiedOn]        DATETIME2 (7) NULL,
    [ModifiedBy]        INT           NULL,
    [IsActive]          BIT           CONSTRAINT [DF_mVendor_IsActive] DEFAULT ((1)) NOT NULL,
    [IsDeleted]         BIT           CONSTRAINT [DF_mVendor_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_mVendor] PRIMARY KEY CLUSTERED ([ID] ASC)
);

