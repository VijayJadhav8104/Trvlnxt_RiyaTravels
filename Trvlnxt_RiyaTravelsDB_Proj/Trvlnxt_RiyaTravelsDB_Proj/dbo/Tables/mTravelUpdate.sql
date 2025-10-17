CREATE TABLE [dbo].[mTravelUpdate] (
    [ID]                  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [JoiningCountry]      VARCHAR (50)  NULL,
    [RepatriationCountry] VARCHAR (50)  NULL,
    [TransitCountry1]     VARCHAR (50)  NULL,
    [TransitCountry2]     VARCHAR (50)  NULL,
    [DisplayText]         VARCHAR (MAX) NOT NULL,
    [UserTypeId]          INT           NULL,
    [Country]             VARCHAR (10)  NULL,
    [CreatedOn]           DATETIME2 (7) NOT NULL,
    [CreatedBy]           INT           NOT NULL,
    [ModifiedOn]          DATETIME2 (7) NULL,
    [ModifiedBy]          INT           NULL,
    [IsActive]            BIT           CONSTRAINT [DF_mTravelUpdate_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mTravelUpdate] PRIMARY KEY CLUSTERED ([ID] ASC)
);

