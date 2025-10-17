CREATE TABLE [Hotel].[HotelCountrySearch] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [City]      VARCHAR (100) NULL,
    [Country]   VARCHAR (100) NULL,
    [KM]        VARCHAR (100) NULL,
    [IsActive]  BIT           DEFAULT ((1)) NOT NULL,
    [CreatedOn] DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_City_Country_KM] UNIQUE NONCLUSTERED ([City] ASC, [Country] ASC, [KM] ASC)
);

