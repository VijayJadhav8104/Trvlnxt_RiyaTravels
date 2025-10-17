CREATE TABLE [dbo].[PromoHistory] (
    [PKID]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FromSector]   VARCHAR (50)  NULL,
    [ToSector]     VARCHAR (50)  NULL,
    [FromDate]     DATETIME      NULL,
    [ToDate]       DATETIME      NULL,
    [UserType]     INT           NULL,
    [TripType]     CHAR (1)      NULL,
    [Browser]      VARCHAR (50)  NULL,
    [Device]       VARCHAR (50)  NULL,
    [IP]           VARCHAR (50)  NULL,
    [PromoCode]    VARCHAR (50)  NULL,
    [SessionID]    VARCHAR (50)  NULL,
    [EmailID]      VARCHAR (50)  NULL,
    [Userid]       INT           NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_PromoHistory_InsertedDate] DEFAULT (getdate()) NULL,
    [Url]          VARCHAR (100) NULL,
    [Status]       INT           CONSTRAINT [DF_PromoHistory_Status] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_PromoHistory] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

