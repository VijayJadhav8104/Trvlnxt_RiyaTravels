CREATE TABLE [dbo].[Hotel_Room_master] (
    [Room_Id]                       BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RoomTypeDescription]           VARCHAR (500)   NULL,
    [NumberOfRoom]                  VARCHAR (10)    NULL,
    [book_fk_id]                    BIGINT          NULL,
    [orderId]                       VARCHAR (30)    NULL,
    [IsCancelled]                   INT             NULL,
    [IsBooked]                      INT             NULL,
    [inserteddate]                  DATETIME        NULL,
    [room_class_id]                 VARCHAR (100)   NULL,
    [room_no]                       INT             NULL,
    [numOfAdults]                   INT             NULL,
    [numOfChildren]                 INT             NULL,
    [RoomMealBasis]                 VARCHAR (500)   NULL,
    [RateId]                        VARCHAR (100)   NULL,
    [RoomRate]                      FLOAT (53)      NULL,
    [Supplierid]                    VARCHAR (200)   NULL,
    [baseRate]                      FLOAT (53)      NULL,
    [publishedBaseRate]             FLOAT (53)      NULL,
    [totalRate]                     FLOAT (53)      NULL,
    [supplierCurrency]              VARCHAR (50)    NULL,
    [publishedRate]                 FLOAT (53)      NULL,
    [supplierRateNew]               FLOAT (53)      NULL,
    [SupplierCommission]            FLOAT (53)      NULL,
    [RpublishedRate]                FLOAT (53)      NULL,
    [RbaseRate]                     FLOAT (53)      NULL,
    [Rfees]                         FLOAT (53)      NULL,
    [Rdiscounts]                    FLOAT (53)      NULL,
    [RFinalPrice]                   DECIMAL (18, 2) NULL,
    [Rmarkup]                       FLOAT (53)      NULL,
    [Staxes]                        FLOAT (53)      NULL,
    [GstOnServiceCharges]           DECIMAL (18, 2) NULL,
    [ServiceCharges]                DECIMAL (18, 2) NULL,
    [TotalServiceCharges]           DECIMAL (18, 2) NULL,
    [GstAmountOnServiceChagres]     DECIMAL (18, 2) NULL,
    [SupplierRateInBookingCurrency] DECIMAL (18, 2) NULL,
    [IsActiveRoom]                  BIT             CONSTRAINT [DF_Hotel_Room_master_IsActiveRoom] DEFAULT ((1)) NULL,
    [RoomDiscription]               VARCHAR (MAX)   NULL,
    CONSTRAINT [PK_Hotel_Room_master] PRIMARY KEY CLUSTERED ([Room_Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_book_fk_id]
    ON [dbo].[Hotel_Room_master]([book_fk_id] ASC);

