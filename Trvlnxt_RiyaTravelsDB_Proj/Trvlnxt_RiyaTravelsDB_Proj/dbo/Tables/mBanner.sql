CREATE TABLE [dbo].[mBanner] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserType]     INT           NULL,
    [Country]      VARCHAR (10)  NULL,
    [StateId]      VARCHAR (MAX) NULL,
    [BranchId]     VARCHAR (MAX) NULL,
    [AgencyId]     VARCHAR (MAX) NULL,
    [Product]      VARCHAR (10)  NULL,
    [FromDateTime] DATETIME2 (7) NULL,
    [ToDateTime]   DATETIME2 (7) NULL,
    [CreatedBy]    INT           NULL,
    [CreatedOn]    DATETIME2 (7) CONSTRAINT [DF_mBanner_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [ModifiedOn]   DATETIME2 (7) NULL,
    [ModifiedBy]   INT           NULL,
    [IsActive]     BIT           CONSTRAINT [DF_mBanner_IsActive] DEFAULT ((1)) NOT NULL,
    [IsRiyaStaff]  BIT           NULL,
    [AgencyNames]  VARCHAR (MAX) NULL,
    CONSTRAINT [PK_mBanner] PRIMARY KEY CLUSTERED ([ID] ASC)
);

