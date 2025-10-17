CREATE TABLE [dbo].[mactionAccess_19Dec2024] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [ActionName]      VARCHAR (100) NULL,
    [MenuID]          INT           NULL,
    [isActive]        BIT           NOT NULL,
    [ActionControlID] VARCHAR (100) NULL,
    [IsColumn]        BIT           NULL
);

