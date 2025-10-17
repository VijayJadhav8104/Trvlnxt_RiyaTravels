CREATE TABLE [dbo].[City_Hotels] (
    [Id]                   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Hotel_Name]           NVARCHAR (100) NULL,
    [Address]              NVARCHAR (MAX) NULL,
    [Strike_Price]         FLOAT (53)     NULL,
    [Price]                FLOAT (53)     NULL,
    [Star_Category]        NVARCHAR (100) NULL,
    [Inclusive]            VARCHAR (150)  NULL,
    [HotelUrl]             NVARCHAR (MAX) NULL,
    [HotelMTitle]          NVARCHAR (MAX) NULL,
    [HotelMDescription]    NVARCHAR (MAX) NULL,
    [HotelGoogleAnalytics] NVARCHAR (MAX) NULL,
    [Keywords]             NVARCHAR (MAX) NULL,
    [CurrentTimeStamp]     DATETIME       NULL,
    [U_id]                 INT            NULL,
    [City_Id]              INT            NULL,
    [HotelCity]            NVARCHAR (100) NULL,
    [HotelImage]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__City_Hot__3214EC0775851772] PRIMARY KEY CLUSTERED ([Id] ASC)
);

