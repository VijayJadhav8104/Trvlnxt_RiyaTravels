CREATE TABLE [dbo].[tblPromoCode_trvlnxt] (
    [PKID]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Carrier]            VARCHAR (50)  NULL,
    [Salesfrom]          DATE          NULL,
    [SalesTo]            DATE          NULL,
    [TrvlFrom]           DATE          NULL,
    [TrvlTo]             DATE          NULL,
    [PromoCode]          VARCHAR (50)  NULL,
    [SectorExFrom]       VARCHAR (50)  NULL,
    [SectorExTo]         VARCHAR (50)  NULL,
    [IsActive]           BIT           NULL,
    [OfficeId]           VARCHAR (50)  NULL,
    [AgentID]            VARCHAR (MAX) NULL,
    [GroupId]            INT           NULL,
    [IsAlwaysApplicable] BIT           CONSTRAINT [DF_tblPromoCode_trvlnxt_IsAlwaysApplicable] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblPromoCode_trvlnxt] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

