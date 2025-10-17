CREATE TYPE [dbo].[City_Hotels] AS TABLE (
    [Hotel_City]           NVARCHAR (100) NULL,
    [Hotel_Name]           NVARCHAR (100) NULL,
    [Address]              NVARCHAR (MAX) NULL,
    [Strike_Price]         FLOAT (53)     NULL,
    [Price]                FLOAT (53)     NULL,
    [Star_Category]        NVARCHAR (10)  NULL,
    [Inclusive]            NVARCHAR (150) NULL,
    [HotelUrl]             NVARCHAR (MAX) NULL,
    [HotelMTitle]          NVARCHAR (MAX) NULL,
    [HotelMDescription]    NVARCHAR (MAX) NULL,
    [HotelGoogleAnalytics] NVARCHAR (MAX) NULL,
    [Keywords]             NVARCHAR (MAX) NULL,
    [City_Id]              INT            NULL,
    [HotelImage]           NVARCHAR (MAX) NULL);

