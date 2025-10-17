CREATE TABLE [dbo].[GkSegmentOfficeID] (
    [PKID]        INT          IDENTITY (1, 1) NOT NULL,
    [OfficeID]    VARCHAR (50) NULL,
    [CountryCode] VARCHAR (50) NULL,
    [GroupID]     VARCHAR (50) NULL,
    CONSTRAINT [PK_GkSegmentOfficeID] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

