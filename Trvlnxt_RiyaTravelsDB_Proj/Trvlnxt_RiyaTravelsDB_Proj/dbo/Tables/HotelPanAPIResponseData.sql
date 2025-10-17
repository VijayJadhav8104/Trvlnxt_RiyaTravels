CREATE TABLE [dbo].[HotelPanAPIResponseData] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [PanAPIResponse] VARCHAR (MAX) NULL,
    [InsertedDate]   DATETIME      NULL,
    CONSTRAINT [PK_HotelPanAPIResponseData] PRIMARY KEY CLUSTERED ([Id] ASC)
);

