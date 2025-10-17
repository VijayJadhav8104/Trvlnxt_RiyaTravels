CREATE TABLE [Invoice].[PagesVisited] (
    [ID]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [Module]      VARCHAR (50)  NULL,
    [Page]        VARCHAR (100) NULL,
    [Url]         VARCHAR (MAX) NULL,
    [UserId]      BIGINT        NULL,
    [IsStaff]     INT           NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_PagesVisited_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_PagesVisited] PRIMARY KEY CLUSTERED ([ID] ASC)
);

