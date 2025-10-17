CREATE TABLE [dbo].[Hotel_List_Master] (
    [ID]              BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [HotelName]       NVARCHAR (300) NULL,
    [CityCode]        NVARCHAR (255) NULL,
    [name]            NVARCHAR (255) NULL,
    [CountryCode]     NVARCHAR (255) NULL,
    [main_image]      NVARCHAR (255) NULL,
    [short_desc]      NVARCHAR (MAX) NULL,
    [latitude]        VARCHAR (255)  NULL,
    [longitude]       VARCHAR (255)  NULL,
    [rating]          VARCHAR (50)   NULL,
    [address]         NVARCHAR (200) NULL,
    [hotel_amenities] NVARCHAR (MAX) NULL,
    [phone]           VARCHAR (50)   NULL,
    [website]         NVARCHAR (MAX) NULL,
    [long_desc]       NVARCHAR (MAX) NULL,
    [Fax]             VARCHAR (50)   NULL,
    [EmailID]         VARCHAR (50)   NULL,
    [Optional_Image]  VARCHAR (255)  NULL,
    [Hotel_id]        VARCHAR (255)  NULL,
    [IsI2Space]       INT            NULL,
    CONSTRAINT [PK_Hotel_List_Master] PRIMARY KEY CLUSTERED ([ID] ASC)
);

