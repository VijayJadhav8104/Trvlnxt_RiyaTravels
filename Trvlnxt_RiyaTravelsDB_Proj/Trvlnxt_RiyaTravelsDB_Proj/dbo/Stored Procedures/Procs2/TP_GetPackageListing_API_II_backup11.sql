create PROCEDURE [dbo].[TP_GetPackageListing_API_II_backup11]  --[dbo].[TP_GetPackageListing_API_IIBackup] 'in',7,'198*183'
(
--@ActionId varchar(100)=0,
--@P_ID int,
@Country nvarchar(500), 
@ToutType int=0,
@DefaultCard nvarchar(500)=''
)
 

AS
BEGIN

declare @CurCode nvarchar(500)
   
   --  if @Country='ae'
   --  set @Country='ua'


   IF @Country = 'In'
  BEGIN

    SET @CurCode = 'INR'
  END


  IF @Country = 'Us'
  BEGIN

    SET @CurCode = 'USD'
  END

  IF @Country = 'Ca'
  BEGIN

    SET @CurCode = 'CAD'
  END


    IF @Country = 'ae'
  BEGIN

    SET @CurCode = 'AED'
  END


  SET NOCOUNT ON;

  ---------Retrieves Data against RegionID,Themes ID,Duration,Price---------	 

  ;
  WITH PackageCTE (P_ID)
  AS (SELECT
  DISTINCT
    pp.P_ID
  FROM Packages pp
  LEFT JOIN RegionMaster r
    ON r.RegionId = pp.P_Region_Id

  LEFT JOIN TourCategory tc
    ON tc.id = pp.P_Category
  LEFT JOIN Theme t
    ON t.PKID_int IN (SELECT
      *
    FROM dbo.fn_split_Data(pp.P_Theme_Id, ','))
  WHERE pp.P_status = 'Y'
  --AND pp.Country = @Country
  and  pp.Country=@Country and pp.P_Category=@ToutType)

  SELECT
    *,

    CASE
      WHEN ShortDesc1 = '0' THEN ''
 ELSE CASE
          WHEN P_TourCategory = 'D' and @ToutType!=7 THEN CASE
              WHEN EXISTS (SELECT
                  *
                FROM tour_ratecards tr
                WHERE tr.P_Id = data.P_ID
                AND occupytype_ch = 'Twin ( Min. 4 Adults )'
                AND tr.basicprice_int <> '') THEN 'Starting from ' + Currency1 + ' ' + cast( CEILING( cast(ShortDesc1 as float)) as nvarchar(500))  + '* only ( Min. 4 Adults )'
              ELSE 'Starting from ' + Currency1 + ' ' +  cast( CEILING( cast(ShortDesc1 as float)) as nvarchar(500))  + '* only'
            END

          ELSE 'Starting from ' + Currency1 + ' ' + cast( CEILING( cast(ShortDesc1 as float)) as nvarchar(500))  + '* only'
 END
    END
    ShortDesc

  FROM (SELECT
    P_TourCategory,
    pp.P_ID,
    pp1.p_name P_name,
    pp1.P_Title Title,

    ISNULL((SELECT TOP 1
      PG_Path
    FROM PictureGallery pg
    WHERE stype = 'Default'
    AND Status = 'y'
    AND pg.P_ID = pp1.P_ID), '/images/packages/no_image.jpg') ImgPath,

    CAST(CASE
      WHEN P_TourCategory = 'D' THEN CASE
          WHEN EXISTS (SELECT
              *
            FROM tour_ratecards tr
            WHERE tr.P_Id = pp.P_ID
            AND occupytype_ch = 'Twin ( Min. 4 Adults )'
            AND tr.basicprice_int <> '') THEN


(


SELECT top 1
             (  CASE
 	WHEN @ToutType=7 THEN CEILING(MIN(CAST(tr.basicprice_int AS float)))

WHEN Currency <> @CurCode THEN CEILING( MIN(CAST(tr.basicprice_int AS float))) * ((SELECT TOP 1
                ROUND(roe, 2)
              FROM roe
              WHERE fromcur = Currency
              AND tocur = @CurCode
              AND isactive = 1)
              )
            ELSE CEILING(MIN(CAST(tr.basicprice_int AS float)))
          END)
            FROM tour_ratecards tr
            WHERE tr.P_Id =  pp.P_ID
            AND occupytype_ch = 'Twin ( Min. 4 Adults )'
            GROUP BY Currency)
          ELSE (
 
 
 SELECT top 1
             (CASE
 	WHEN @ToutType=7 THEN CEILING(MIN(CAST(tr.basicprice_int AS float)))
            WHEN Currency <> @CurCode THEN CEILING(MIN(CAST(tr.basicprice_int AS float))) * ((SELECT TOP 1
                ROUND(roe, 2)
              FROM roe
              WHERE fromcur = Currency
              AND tocur = @CurCode
              AND isactive = 1)
              )
            ELSE CEILING(MIN(CAST(tr.basicprice_int AS float)))
          END)
            FROM tour_ratecards tr
            WHERE tr.P_Id =  pp.P_ID
      AND occupytype_ch = 'Twin'
            AND tr.basicprice_int <> ''
            GROUP BY Currency)
        END


      ELSE (SELECT
 top 1

          (CASE
 	WHEN @ToutType=7 THEN CEILING(MIN(CAST(tr.basicprice_int AS float)))
            WHEN Currency <> @CurCode THEN CEILING(MIN(CAST(tr.basicprice_int AS float))) * ((SELECT TOP 1
                ROUND(roe, 2)
              FROM roe
              WHERE fromcur = Currency
              AND tocur = @CurCode
              AND isactive = 1)
              )
            ELSE CEILING(MIN(CAST(tr.basicprice_int AS float)))
          END)

        FROM tour_ratecards tr
        WHERE tr.P_Id = pp.P_ID
        AND occupytype_ch = 'TW-Twin Sharing'
        AND tr.basicprice_int <> ''
        GROUP BY Currency)


    END
    AS nvarchar(30))
    ShortDesc1,
CAST(CASE
      WHEN P_TourCategory = 'D' THEN CASE
          WHEN EXISTS (SELECT
              *
            FROM tour_ratecards tr
            WHERE tr.P_Id = pp.P_ID
            AND occupytype_ch = 'Twin ( Min. 4 Adults )'
            AND tr.basicprice_int <> '') THEN


(


SELECT top 1
             (  CASE
 	WHEN @ToutType=7 THEN Currency


            ELSE @CurCode
          END)
            FROM tour_ratecards tr
            WHERE tr.P_Id =  pp.P_ID
            AND occupytype_ch = 'Twin ( Min. 4 Adults )'
            GROUP BY Currency)
          ELSE (
 
 
 SELECT
            top 1 (CASE
 	WHEN @ToutType=7 THEN Currency
            
            ELSE @CurCode
          END)
            FROM tour_ratecards tr
            WHERE tr.P_Id =  pp.P_ID
      AND occupytype_ch = 'Twin'
            AND tr.basicprice_int <> ''
            GROUP BY Currency)
        END


      ELSE (SELECT

 top 1
          (CASE
 	WHEN @ToutType=7 THEN  Currency
           
            ELSE @CurCode
          END)

        FROM tour_ratecards tr
        WHERE tr.P_Id = pp.P_ID
        AND occupytype_ch = 'TW-Twin Sharing'
        AND tr.basicprice_int <> ''
        GROUP BY Currency)


    END
    AS nvarchar(30))
    Currency1,
    (CAST((CAST(pp1.p_duration AS int) - 1) AS nvarchar(500)) + ' Night / ' + pp1.p_duration + ' Days') Duration,
    ISNULL(P_Tnc, '') Cancellation,
    ISNULL(P_itenary, '') Itenary,
    ISNULL(P_Inclusions, '') Inclusions,
    ISNULL(P_Exclusions, '') Exclusions,
    ISNULL(P_Hotels, '') Accomdation,
    ISNULL(P_TransType_Id, '') P_TransType,
    ISNULL(P_TransType_Title, '') P_TransType_Title,
    P_Themes Themes,
    P_Theme_Id TheamId,
    P_DisplayPrice Budget,
    P_Region_Id RegionId,
    (SELECT
      PG_Path + '*' + Caption + ',' AS [text()]
    FROM dbo.PictureGallery PG1
    WHERE PG1.P_ID = pp.p_id
    AND stype = 'galary'
    AND Status = 'y'
    ORDER BY PG1.PG_ID
    FOR xml PATH (''))
    PhotoGallary
  FROM PackageCTE pp
  INNER JOIN Packages pp1
    ON pp.P_ID = pp1.P_ID) data

  select  RegionId PKID_int, Name name_vc  from RegionMaster 
 where RegionId in ( select p.P_Region_Id from Packages p  where p.P_status='Y'  and Country=@Country and p.P_Category=@ToutType)
 and IsActive=1
 --1 Theam 
 select PKID_int  ,name_vc       from Theme
 where PKID_int in (
 select   PKID_int from Theme p
 inner join Packages pp on p.PKID_int in (
  select *  from dbo.fn_split_Data(pp.P_Theme_Id,',')   
 ) 
 where pp.P_status='Y' and  pp.Country=@Country and pp.P_Category=@ToutType


 )
 and isactive=1

 -- 2 Duration

 select max(cast(p_duration as int)) MaxD, min(cast(p_duration as int)) MinD from Packages
 where P_status='Y' and   Country=@Country and  P_Category=@ToutType

  -- 3 Budget

 select max(P_DisplayPrice) MaxB, min(P_DisplayPrice) MinB from Packages
 where P_status='Y'  and   Country=@Country and  P_Category=@ToutType

 END
 

 


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[TP_GetPackageListing_API_II_backup11] TO [rt_read]
    AS [dbo];

