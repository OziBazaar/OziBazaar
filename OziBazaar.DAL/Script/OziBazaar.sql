USE [master]
GO
/****** Object:  Database [OziBazaar]    Script Date: 12/04/2015 9:16:23 PM ******/
CREATE DATABASE [OziBazaar]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OziBazaar', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLSERVER2012\MSSQL\DATA\OziBazaar.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'OziBazaar_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLSERVER2012\MSSQL\DATA\OziBazaar_log.ldf' , SIZE = 1344KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [OziBazaar] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OziBazaar].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [OziBazaar] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OziBazaar] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OziBazaar] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OziBazaar] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OziBazaar] SET ARITHABORT OFF 
GO
ALTER DATABASE [OziBazaar] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OziBazaar] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [OziBazaar] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OziBazaar] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OziBazaar] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OziBazaar] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OziBazaar] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OziBazaar] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OziBazaar] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OziBazaar] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OziBazaar] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OziBazaar] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OziBazaar] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OziBazaar] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OziBazaar] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [OziBazaar] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OziBazaar] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [OziBazaar] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OziBazaar] SET RECOVERY FULL 
GO
ALTER DATABASE [OziBazaar] SET  MULTI_USER 
GO
ALTER DATABASE [OziBazaar] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OziBazaar] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OziBazaar] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OziBazaar] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'OziBazaar', N'ON'
GO
USE [OziBazaar]
GO
/****** Object:  StoredProcedure [dbo].[AddNewCategory]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE  PROC [dbo].[AddNewCategory](
       @ID       INT,
       @ParentId INT=NULL,
       @Name VARCHAR(100),
       @EditorId  INT =NULL
)
AS
BEGIN
   DECLARE @mOrgNode hierarchyid, @lc hierarchyid
   SELECT @mOrgNode = [HierarchyId]
   FROM dbo.[Category]
   WHERE Id = @ParentId
 
   SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
   BEGIN TRANSACTION
      SELECT @lc = max([HierarchyId])
      FROM dbo.[Category]
      WHERE [HierarchyId].GetAncestor(1) =@mOrgNode ;
 
         INSERT INTO [dbo].[Category]
           ( Id
                 ,ParentId
                 ,[Name]
           ,[HierarchyId]
           ,[EditorId])
     VALUES
           (@ID
                 ,@ParentId
                 ,@Name
           ,@mOrgNode.GetDescendant(@lc, NULL)
           ,@EditorId)
   COMMIT
END ;


GO
/****** Object:  UserDefinedFunction [dbo].[IsValidLookupType]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsValidLookupType](@type nvarchar(50))
	
	RETURNs bit AS

	BEGIN
	IF EXists (select [LookupID] from [dbo].[Lookup]  where [Type]=@type)
	REturn 1
	
	REturn 0
	END

GO
/****** Object:  Table [dbo].[Advertisement]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advertisement](
	[AdvertisementID] [int] IDENTITY(1,1) NOT NULL,
	[AdvertisementCode] [nchar](10) NULL,
	[ProductID] [int] NOT NULL,
	[Title] [nvarchar](200) NULL,
	[Price] [money] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[OwnerID] [int] NOT NULL,
	[IsActive] [bit] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Advertisement] PRIMARY KEY CLUSTERED 
(
	[AdvertisementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Category](
	[ID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[HierarchyId] [hierarchyid] NOT NULL,
	[EditorId] [int] NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nchar](10) NULL,
	[Description] [nvarchar](50) NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Lookup]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lookup](
	[LookupID] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[ParentID] [int] NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Lookup] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NotificationAudit]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationAudit](
	[NotificationAuditID] [int] IDENTITY(1,1) NOT NULL,
	[NotificationConfigurationID] [int] NULL,
	[Sender] [nvarchar](50) NULL,
	[Receiver] [nvarchar](50) NULL,
	[Date] [datetime] NULL,
	[Version] [timestamp] NULL,
 CONSTRAINT [PK_EmailAudit] PRIMARY KEY CLUSTERED 
(
	[NotificationAuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NotificationTemplate]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationTemplate](
	[NotificationTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[TemplatePath] [nvarchar](500) NULL,
	[NotificationTypeID] [int] NULL,
	[Subject] [nvarchar](50) NULL,
	[Version] [timestamp] NULL,
 CONSTRAINT [PK_EmailConfiguration] PRIMARY KEY CLUSTERED 
(
	[NotificationTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NotificationType]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationType](
	[NotificationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Version] [timestamp] NULL,
 CONSTRAINT [PK_EmailType] PRIMARY KEY CLUSTERED 
(
	[NotificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[ProductGroupID] [int] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductGroup]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductGroup](
	[ProductGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[ViewTemplate] [nvarchar](100) NULL,
	[EditTemplate] [nvarchar](100) NULL,
	[CategoryID] [int] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductGroup] PRIMARY KEY CLUSTERED 
(
	[ProductGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductGroupProperty]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductGroupProperty](
	[ProductGroupPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ProductGroupID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[InitialValue] [nvarchar](500) NULL,
	[TabOrder] [int] NULL,
	[IsMandatory] [bit] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductGroupProperty] PRIMARY KEY CLUSTERED 
(
	[ProductGroupPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductImage]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductImage](
	[ProductImageID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ImagePath] [nvarchar](500) NULL,
	[ImageType] [nvarchar](50) NULL,
	[MimeType] [nvarchar](100) NULL,
	[Description] [nvarchar](500) NULL,
	[ImageOrder] [smallint] NULL,
	[IsThumbnail] [bit] NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductImage] PRIMARY KEY CLUSTERED 
(
	[ProductImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductProperty]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductProperty](
	[ProductPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductGroupPropertyID] [int] NOT NULL,
	[Value] [nvarchar](1000) NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_ProductProperty] PRIMARY KEY CLUSTERED 
(
	[ProductPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Property]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Property](
	[PropertyID] [int] IDENTITY(1,1) NOT NULL,
	[KeyName] [nvarchar](250) NOT NULL,
	[Title] [nvarchar](250) NULL,
	[ControlType] [nvarchar](50) NULL,
	[DataType] [nvarchar](100) NULL,
	[LookupType] [nvarchar](150) NULL,
	[DependsOn] [nvarchar](150) NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfile](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[FullName] [nvarchar](50) NULL,
	[CountryID] [int] NULL,
	[Address1] [nvarchar](200) NULL,
	[Address2] [nvarchar](200) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Activated] [bit] NULL,
	[ActivationDate] [date] NULL,
	[Version] [timestamp] NULL,
 CONSTRAINT [PK_UserProfile] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_Membership]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Membership](
	[UserId] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[ConfirmationToken] [nvarchar](128) NULL,
	[IsConfirmed] [bit] NULL,
	[LastPasswordFailureDate] [datetime] NULL,
	[PasswordFailuresSinceLastSuccess] [int] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordChangedDate] [datetime] NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[PasswordVerificationToken] [nvarchar](128) NULL,
	[PasswordVerificationTokenExpirationDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_OAuthMembership]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_OAuthMembership](
	[Provider] [nvarchar](30) NOT NULL,
	[ProviderUserId] [nvarchar](100) NOT NULL,
	[UserId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Provider] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_Roles]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_Roles](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[webpages_UsersInRoles]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[webpages_UsersInRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WishList]    Script Date: 12/04/2015 9:16:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WishList](
	[WishListID] [int] IDENTITY(1,1) NOT NULL,
	[AdvertizementID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Version] [timestamp] NOT NULL,
 CONSTRAINT [PK_WishList] PRIMARY KEY CLUSTERED 
(
	[WishListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Advertisement] ON 

INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (1, NULL, 1, N'yy', 1000.0000, CAST(0x0000A36400A1AEC4 AS DateTime), CAST(0x0000A38300A1AEC4 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (2, NULL, 2, N'hh', 1000.0000, CAST(0x0000A36400A52945 AS DateTime), CAST(0x0000A38300A52945 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (3, NULL, 3, N'test ing something new', 1000.0000, CAST(0x0000A37400E5DED0 AS DateTime), CAST(0x0000A39300E5DED0 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (6, NULL, 6, N'Another test', 22.0000, CAST(0x0000A37B00000000 AS DateTime), CAST(0x0000A3D200000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (8, NULL, 8, N'Mazda', 34000.0000, CAST(0x0000A38100000000 AS DateTime), CAST(0x0000A39700000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (10, NULL, 10, N'test', 3.0000, CAST(0x0000A37A00000000 AS DateTime), CAST(0x0000A39800000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (14, NULL, 14, N'nokia', 100.0000, CAST(0x0000A38800000000 AS DateTime), CAST(0x0000A39600000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (26, NULL, 26, N'rest', 22.0000, CAST(0x0000A38000000000 AS DateTime), CAST(0x0000A39800000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (1025, NULL, 1025, N'ttt', 55.0000, CAST(0x0000A38C00000000 AS DateTime), CAST(0x0000A39800000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (1026, NULL, 1026, N'testi', 10.0000, CAST(0x0000A39400000000 AS DateTime), CAST(0x0000A39600000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (1027, NULL, 1027, N'test2', 10.0000, CAST(0x0000A39600000000 AS DateTime), CAST(0x0000A39800000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (1028, NULL, 1028, N'gh', 1.0000, CAST(0x0000A3A200000000 AS DateTime), CAST(0x0000A3AE00000000 AS DateTime), 3, 1)
INSERT [dbo].[Advertisement] ([AdvertisementID], [AdvertisementCode], [ProductID], [Title], [Price], [StartDate], [EndDate], [OwnerID], [IsActive]) VALUES (1029, NULL, 1029, N'job1', 100.0000, CAST(0x0000A3A100000000 AS DateTime), CAST(0x0000A3AE00000000 AS DateTime), 3, 1)
SET IDENTITY_INSERT [dbo].[Advertisement] OFF
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (0, N'Root', N'/', NULL, NULL)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1, N'Automotive', N'/1/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2, N'Home & Garden', N'/2/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3, N'Clothes & Footwear', N'/3/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (4, N'Baby & Children', N'/4/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (5, N'Books & Magazine', N'/5/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (6, N'Computers & Games', N'/6/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (7, N'Electronics', N'/7/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (8, N'Camera', N'/8/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (9, N'Jobs', N'/9/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10, N'Pets', N'/10/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (11, N'Art & Jewellery', N'/11/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (12, N'Properties', N'/12/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (13, N'Boats & Jetskies', N'/13/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (14, N'Business Services', N'/14/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (15, N'Travel & Tickets', N'/15/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (16, N'Health & Beauty', N'/16/', NULL, 0)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (20, N'Living Room', N'/2/1/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (21, N'Bedroom', N'/2/2/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (22, N'Bathroom', N'/2/3/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (23, N'Kitchen', N'/2/4/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (24, N'Home Appliance', N'/2/5/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (25, N'Garden', N'/2/6/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (26, N'Tools & DIY', N'/2/7/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (27, N'Power Tools', N'/2/8/', NULL, 2)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (30, N'Women', N'/3/1/', NULL, 3)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (31, N'Men', N'/3/2/', NULL, 3)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (40, N'Baby Clothes', N'/4/1/', NULL, 4)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (41, N'Baby Furniture', N'/4/2/', NULL, 4)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (42, N'Baby Stuff', N'/4/3/', NULL, 4)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (43, N'Kids Clothes', N'/4/4/', NULL, 4)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (44, N'Kids Furniture', N'/4/5/', NULL, 4)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (45, N'Toys', N'/4/6/', NULL, 4)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (46, N'Accessories', N'/4/7/', NULL, 4)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (50, N'Children Books', N'/5/1/', NULL, 5)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (51, N'Comic Books', N'/5/2/', NULL, 5)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (52, N'Fiction Books', N'/5/3/', NULL, 5)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (53, N'EBooks', N'/5/4/', NULL, 5)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (54, N'Educational Books', N'/5/5/', NULL, 5)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (55, N'Magazines', N'/5/6/', NULL, 5)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (56, N'Other Books & Magazines', N'/5/7/', NULL, 5)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (70, N'Audio', N'/7/1/', NULL, 7)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (71, N'Phones & Mobile Phones', N'/7/2/', NULL, 7)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (72, N'TV', N'/7/3/', NULL, 7)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (73, N'TV Accessories', N'/7/4/', NULL, 7)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (74, N'Home theatre', N'/7/5/', NULL, 7)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (75, N'DVD & CD Player', N'/7/6/', NULL, 7)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (76, N'Other Electronics', N'/7/7/', NULL, 7)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (80, N'Compact Camera', N'/8/1/', NULL, 8)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (81, N'Digital SLR Camera', N'/8/2/', NULL, 8)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (82, N'Camcorders & Video Camera', N'/8/3/', NULL, 8)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (83, N'Digital Frames', N'/8/4/', NULL, 8)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (84, N'Camera Accessories', N'/8/5/', NULL, 8)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (85, N'Other Camera', N'/8/6/', NULL, 8)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (100, N'Birds', N'/10/1/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (101, N'Cats & Kitten', N'/10/2/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (102, N'Dogs & Puppies', N'/10/3/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (103, N'Fish', N'/10/4/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (104, N'Horses', N'/10/5/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (105, N'Hamsters', N'/10/6/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (106, N'Lost & Found Pets', N'/10/7/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (107, N'Pets Food & Suppliers', N'/10/8/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (108, N'Pets Accessories', N'/10/9/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (109, N'Other Pets', N'/10/10/', NULL, 10)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (110, N'Antiques', N'/11/1/', NULL, 11)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (111, N'Arts', N'/11/2/', NULL, 11)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (112, N'Men''s Jewellery', N'/11/3/', NULL, 11)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (113, N'Women''s Jewellery', N'/11/4/', NULL, 11)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (114, N'Watches', N'/11/5/', NULL, 11)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (115, N'Other Jewellery', N'/11/6/', NULL, 11)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (120, N'Accomodation', N'/12/1/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (121, N'Office Space & Commercial', N'/12/2/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (122, N'Property For Sale', N'/12/3/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (123, N'Property For Rent', N'/12/4/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (124, N'Land For Sale', N'/12/5/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (125, N'Flatshare', N'/12/6/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (126, N'Parking', N'/12/7/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (127, N'Storage Space', N'/12/8/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (128, N'Short Term', N'/12/9/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (129, N'Other Properties', N'/12/10/', NULL, 12)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (130, N'Power Boat', N'/13/1/', NULL, 13)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (131, N'Sailing Boat', N'/13/2/', NULL, 13)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (132, N'Inflatables', N'/13/3/', NULL, 13)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (133, N'Boat Parts & Accessories', N'/13/4/', NULL, 13)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (134, N'Jet Skies', N'/13/5/', NULL, 13)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (135, N'Other Boat & Jet Skies', N'/13/6/', NULL, 13)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (150, N'Accommodation', N'/15/1/', NULL, 15)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (151, N'Flights', N'/15/2/', NULL, 15)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (152, N'Cruises', N'/15/3/', NULL, 15)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (153, N'Cinema & Theater Tickets', N'/15/4/', NULL, 15)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (154, N'Concert Tickets', N'/15/5/', NULL, 15)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (155, N'Travel Agents', N'/15/6/', NULL, 15)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (156, N'Others', N'/15/7/', NULL, 15)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (160, N'Bath & Body', N'/16/1/', NULL, 16)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (161, N'Dental Care', N'/16/2/', NULL, 16)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (162, N'Hair Care', N'/16/3/', NULL, 16)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (163, N'Skin Care', N'/16/4/', NULL, 16)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (164, N'Fragnance', N'/16/5/', NULL, 16)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (165, N'Make up', N'/16/6/', NULL, 16)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (166, N'Other', N'/16/7/', NULL, 16)
GO
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (200, N'CoffeeTable', N'/2/1/1/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (201, N'Carpet & Rugs', N'/2/1/2/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (202, N'Bar Furniture', N'/2/1/3/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (203, N'Dinning Set', N'/2/1/4/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (204, N'TV Unit', N'/2/1/5/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (205, N'Mirror', N'/2/1/6/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (206, N'Painting', N'/2/1/7/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (207, N'Decoration', N'/2/1/8/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (208, N'Curtain & Blinds', N'/2/1/9/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (209, N'Other Livingroom', N'/2/1/10/', NULL, 20)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (211, N'Mattresses & Pillows', N'/2/2/1/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (212, N'Sheets & Sheet Set', N'/2/2/2/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (213, N'Pillow Cases', N'/2/2/3/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (214, N'BedSpreads', N'/2/2/4/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (215, N'Blankets', N'/2/2/5/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (216, N'Doonas,Quilt,Covers', N'/2/2/6/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (217, N'Other Bedroom', N'/2/2/7/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (220, N'Shower Screen', N'/2/3/1/', NULL, 22)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (221, N'Taps & Shower Heads', N'/2/3/2/', NULL, 22)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (222, N'Vanities & Units', N'/2/3/3/', NULL, 22)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (223, N'Toilets & Bidets', N'/2/3/4/', NULL, 22)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (224, N'Towels & Mats', N'/2/3/5/', NULL, 22)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (225, N'Bathroom Accessories', N'/2/3/6/', NULL, 22)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (230, N'Small Appliance', N'/2/4/1/', NULL, 23)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (231, N'Dishwashes', N'/2/4/2/', NULL, 23)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (232, N'Microwaves', N'/2/4/3/', NULL, 23)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (233, N'Oven & Cootops', N'/2/4/4/', NULL, 23)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (234, N'Rangehoods', N'/2/4/5/', NULL, 23)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (235, N'Refrigrators & Freezers', N'/2/4/6/', NULL, 23)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (236, N'Other Kitchen', N'/2/4/7/', NULL, 23)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (240, N'Air Conditioning & Heaters', N'/2/5/1/', NULL, 24)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (241, N'Washing Machine & Dryers', N'/2/5/2/', NULL, 24)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (242, N'Vaccume Cleaners', N'/2/5/3/', NULL, 24)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (243, N'Irons', N'/2/5/4/', NULL, 24)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (244, N'Other Appliance', N'/2/5/5/', NULL, 24)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (250, N'Garden Furniture', N'/2/6/1/', NULL, 25)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (251, N'Plants', N'/2/6/2/', NULL, 25)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (252, N'Sheds', N'/2/6/3/', NULL, 25)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (253, N'Lawn Mowers', N'/2/6/4/', NULL, 25)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (254, N'Other Garden', N'/2/6/5/', NULL, 25)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (260, N'Air Tools', N'/2/7/1/', NULL, 26)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (261, N'Cordless Tools', N'/2/7/2/', NULL, 26)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (262, N'Ladders', N'/2/7/3/', NULL, 26)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (263, N'Hand Tools', N'/2/7/4/', NULL, 26)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (264, N'Power Tools', N'/2/7/5/', NULL, 26)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (300, N'Women''s Cloths', N'/3/1/1/', NULL, 30)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (301, N'Women''s Shoes', N'/3/1/2/', NULL, 30)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (302, N'Bags', N'/3/1/3/', NULL, 30)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (303, N'Women''s Accessories', N'/3/1/4/', NULL, 30)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (310, N'Men''s Cloths', N'/3/2/1/', NULL, 31)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (311, N'Men''s Shoes', N'/3/2/2/', NULL, 31)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (312, N'Men''s Accessories', N'/3/2/3/', NULL, 31)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (600, N'Descktop PCs', N'/6/1/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (601, N'Laptops & Notebooks', N'/6/2/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (602, N'Printers & Scanners', N'/6/3/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (603, N'Monitors', N'/6/4/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (604, N'Softwares', N'/6/5/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (605, N'Hardwares', N'/6/6/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (606, N'Computer Accessories', N'/6/7/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (607, N'Other Computers', N'/6/8/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (608, N'Game Consoles', N'/6/9/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (609, N'Games', N'/6/10/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (610, N'Game Accessories', N'/6/11/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (611, N'Other Games', N'/6/12/', NULL, 6)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (710, N'Phones', N'/7/2/1/', NULL, 71)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (711, N'Mobile Phones', N'/7/2/2/', NULL, 71)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (712, N'Mobile Phone Accessories', N'/7/2/3/', NULL, 71)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (713, N'Other Phones', N'/7/2/4/', NULL, 71)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (900, N'Administration & Office', N'/9/1/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (901, N'Art & Media', N'/9/2/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (902, N'Customer Service', N'/9/3/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (903, N'Construction', N'/9/4/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (904, N'Education', N'/9/5/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (905, N'Engineering', N'/9/6/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (906, N'Financial Service & Banking', N'/9/7/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (907, N'Graduate', N'/9/8/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (908, N'Healthcare & Medical', N'/9/9/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (909, N'Hospitality', N'/9/10/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (910, N'Human Resources', N'/9/11/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (911, N'IT', N'/9/12/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (912, N'Marketing', N'/9/13/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (913, N'Retail', N'/9/14/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (914, N'Sale', N'/9/15/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (915, N'Real Estate & Property', N'/9/16/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (916, N'Web Design', N'/9/17/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (917, N'Volunteer', N'/9/18/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (918, N'Other Jobs', N'/9/19/', NULL, 9)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1000, N'Cars,Utes & Vans', N'/1/1/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1001, N'Cars Spare Parts', N'/1/2/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1002, N'Carvan & MotorHomes', N'/1/3/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1003, N'Motorcycles', N'/1/4/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1004, N'Scooters ', N'/1/5/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1005, N'Trailers', N'/1/6/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1006, N'Other Automotive', N'/1/7/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1007, N'Accessories and Other Spare Parts', N'/1/8/', NULL, 1)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1400, N'Automotive', N'/14/1/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1401, N'Building', N'/14/2/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1402, N'Cleaning', N'/14/3/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1403, N'Computer & Network', N'/14/4/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1404, N'Courses & Training', N'/14/5/', NULL, 14)
GO
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1405, N'Financial Services', N'/14/6/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1406, N'Gardening', N'/14/7/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1407, N'Health & Beauty', N'/14/8/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1408, N'Party & Catering', N'/14/9/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1409, N'Personal Training', N'/14/10/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1410, N'Photography', N'/14/11/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1411, N'Pet Services', N'/14/12/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1412, N'Removal Services', N'/14/13/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1413, N'Real State', N'/14/14/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1414, N'Security Services', N'/14/15/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1415, N'Travel Agents', N'/14/16/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1416, N'Wedding Services', N'/14/17/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1417, N'Web Design', N'/14/18/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (1418, N'Other Services', N'/14/19/', NULL, 14)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2100, N'Bedroom Set', N'/2/2/8/', NULL, 21)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2300, N'Coffe Machines', N'/2/4/1/1/', NULL, 230)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2301, N'Food Processor', N'/2/4/1/2/', NULL, 230)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2302, N'Rice Cooker', N'/2/4/1/3/', NULL, 230)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2303, N'Kettles', N'/2/4/1/4/', NULL, 230)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2304, N'Glassware', N'/2/4/1/5/', NULL, 230)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2305, N'Appliance', N'/2/4/1/6/', NULL, 230)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2306, N'Accessories', N'/2/4/1/7/', NULL, 230)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2600, N'Air Compressors', N'/2/7/1/1/', NULL, 260)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2601, N'Air Drills', N'/2/7/1/2/', NULL, 260)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2602, N'Air Cutters', N'/2/7/1/3/', NULL, 260)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2603, N'Air Sanders', N'/2/7/1/4/', NULL, 260)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2604, N'Other Air Tools', N'/2/7/1/5/', NULL, 260)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2610, N'Cordless Drill', N'/2/7/2/1/', NULL, 261)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2611, N'Cordless Drivers', N'/2/7/2/2/', NULL, 261)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2612, N'Cordless Saws', N'/2/7/2/3/', NULL, 261)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2613, N'Cordless Grinders', N'/2/7/2/4/', NULL, 261)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2614, N'Other Cordless Tools', N'/2/7/2/5/', NULL, 261)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2630, N'Batteries', N'/2/7/4/1/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2631, N'Chisel Set', N'/2/7/4/2/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2632, N'Files', N'/2/7/4/3/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2633, N'Hammers', N'/2/7/4/4/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2634, N'Measuring Equipment', N'/2/7/4/5/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2635, N'Multi Tools', N'/2/7/4/6/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2636, N'Pliers', N'/2/7/4/7/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2637, N'Saw', N'/2/7/4/8/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2638, N'Other Hand Tools', N'/2/7/4/9/', NULL, 263)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2640, N'Grinders', N'/2/7/5/1/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2641, N'Drills', N'/2/7/5/2/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2642, N'Saws', N'/2/7/5/3/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2643, N'Screw Drivers', N'/2/7/5/4/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2644, N'Tile Cutter', N'/2/7/5/5/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2645, N'Vaccum', N'/2/7/5/6/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2646, N'Sanders', N'/2/7/5/7/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (2647, N'Other PowerTools', N'/2/7/5/8/', NULL, 264)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3000, N'Dresses', N'/3/1/1/1/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3001, N'Jackets & Coats', N'/3/1/1/2/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3002, N'Jeans & Pants', N'/3/1/1/3/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3003, N'Tops & T-shirts', N'/3/1/1/4/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3004, N'Skirts', N'/3/1/1/5/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3005, N'SwimWear', N'/3/1/1/6/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3006, N'SleepWear', N'/3/1/1/7/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3007, N'Other Women''s ...', N'/3/1/1/8/', NULL, 300)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3100, N'Jackets & Coats', N'/3/2/1/1/', NULL, 310)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3101, N'Jeans & Pants', N'/3/2/1/2/', NULL, 310)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3102, N'Shirts', N'/3/2/1/3/', NULL, 310)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3103, N'Suits', N'/3/2/1/4/', NULL, 310)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3104, N'SwimWear', N'/3/2/1/5/', NULL, 310)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (3105, N'Other Men''s ...', N'/3/2/1/6/', NULL, 310)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10010, N'Body Parts', N'/1/2/1/', NULL, 1001)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10011, N'Engin Parts', N'/1/2/2/', NULL, 1001)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10012, N'Wheels,Tyres', N'/1/2/3/', NULL, 1001)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10013, N'Wrecking', N'/1/2/4/', NULL, 1001)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10014, N'Other Parts', N'/1/2/5/', NULL, 1001)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10070, N'Audio', N'/1/8/1/', NULL, 1007)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10071, N'GPS', N'/1/8/2/', NULL, 1007)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10072, N'Spare Parts', N'/1/8/3/', NULL, 1007)
INSERT [dbo].[Category] ([ID], [Name], [HierarchyId], [EditorId], [ParentId]) VALUES (10073, N'Other Accessories', N'/1/8/4/', NULL, 1007)
SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (1, N'AD        ', N'Andorra')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (2, N'AE        ', N'United Arab Emirates')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (3, N'AF        ', N'Afghanistan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (4, N'AG        ', N'Antigua and Barbuda')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (5, N'AI        ', N'Anguilla')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (6, N'AL        ', N'Albania')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (7, N'AM        ', N'Armenia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (8, N'AO        ', N'Angola')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (9, N'AQ        ', N'Antarctica')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (10, N'AR        ', N'Argentina')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (11, N'AS        ', N'American Samoa')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (12, N'AT        ', N'Austria')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (13, N'AU        ', N'Australia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (14, N'AW        ', N'Aruba')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (15, N'AX        ', N'Åland Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (16, N'AZ        ', N'Azerbaijan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (17, N'BA        ', N'Bosnia and Herzegovina')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (18, N'BB        ', N'Barbados')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (19, N'BD        ', N'Bangladesh')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (20, N'BE        ', N'Belgium')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (21, N'BF        ', N'Burkina Faso')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (22, N'BG        ', N'Bulgaria')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (23, N'BH        ', N'Bahrain')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (24, N'BI        ', N'Burundi')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (25, N'BJ        ', N'Benin')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (26, N'BL        ', N'Saint Barthélemy')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (27, N'BM        ', N'Bermuda')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (28, N'BN        ', N'Brunei Darussalam')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (29, N'BO        ', N'Bolivia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (30, N'BQ        ', N'Caribbean Netherlands ')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (31, N'BR        ', N'Brazil')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (32, N'BS        ', N'Bahamas')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (33, N'BT        ', N'Bhutan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (34, N'BV        ', N'Bouvet Island')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (35, N'BW        ', N'Botswana')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (36, N'BY        ', N'Belarus')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (37, N'BZ        ', N'Belize')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (38, N'CA        ', N'Canada')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (39, N'CC        ', N'Cocos (Keeling) Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (40, N'CD        ', N'Congo, Democratic Republic of')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (41, N'CF        ', N'Central African Republic')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (42, N'CG        ', N'Congo')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (43, N'CH        ', N'Switzerland')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (44, N'CI        ', N'Côte d''Ivoire')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (45, N'CK        ', N'Cook Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (46, N'CL        ', N'Chile')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (47, N'CM        ', N'Cameroon')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (48, N'CN        ', N'China')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (49, N'CO        ', N'Colombia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (50, N'CR        ', N'Costa Rica')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (51, N'CU        ', N'Cuba')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (52, N'CV        ', N'Cape Verde')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (53, N'CW        ', N'Curaçao')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (54, N'CX        ', N'Christmas Island')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (55, N'CY        ', N'Cyprus')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (56, N'CZ        ', N'Czech Republic')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (57, N'DE        ', N'Germany')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (58, N'DJ        ', N'Djibouti')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (59, N'DK        ', N'Denmark')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (60, N'DM        ', N'Dominica')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (61, N'DO        ', N'Dominican Republic')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (62, N'DZ        ', N'Algeria')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (63, N'EC        ', N'Ecuador')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (64, N'EE        ', N'Estonia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (65, N'EG        ', N'Egypt')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (66, N'EH        ', N'Western Sahara')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (67, N'ER        ', N'Eritrea')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (68, N'ES        ', N'Spain')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (69, N'ET        ', N'Ethiopia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (70, N'FI        ', N'Finland')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (71, N'FJ        ', N'Fiji')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (72, N'FK        ', N'Falkland Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (73, N'FM        ', N'Micronesia, Federated States of')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (74, N'FO        ', N'Faroe Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (75, N'FR        ', N'France')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (76, N'GA        ', N'Gabon')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (77, N'GB        ', N'United Kingdom')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (78, N'GD        ', N'Grenada')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (79, N'GE        ', N'Georgia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (80, N'GF        ', N'French Guiana')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (81, N'GG        ', N'Guernsey')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (82, N'GH        ', N'Ghana')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (83, N'GI        ', N'Gibraltar')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (84, N'GL        ', N'Greenland')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (85, N'GM        ', N'Gambia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (86, N'GN        ', N'Guinea')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (87, N'GP        ', N'Guadeloupe')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (88, N'GQ        ', N'Equatorial Guinea')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (89, N'GR        ', N'Greece')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (90, N'GS        ', N'South Georgia and the South Sandwich Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (91, N'GT        ', N'Guatemala')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (92, N'GU        ', N'Guam')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (93, N'GW        ', N'Guinea-Bissau')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (94, N'GY        ', N'Guyana')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (95, N'HK        ', N'Hong Kong')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (96, N'HM        ', N'Heard and McDonald Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (97, N'HN        ', N'Honduras')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (98, N'HR        ', N'Croatia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (99, N'HT        ', N'Haiti')
GO
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (100, N'HU        ', N'Hungary')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (101, N'ID        ', N'Indonesia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (102, N'IE        ', N'Ireland')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (103, N'IL        ', N'Israel')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (104, N'IM        ', N'Isle of Man')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (105, N'IN        ', N'India')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (106, N'IO        ', N'British Indian Ocean Territory')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (107, N'IQ        ', N'Iraq')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (108, N'IR        ', N'Iran')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (109, N'IS        ', N'Iceland')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (110, N'IT        ', N'Italy')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (111, N'JE        ', N'Jersey')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (112, N'JM        ', N'Jamaica')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (113, N'JO        ', N'Jordan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (114, N'JP        ', N'Japan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (115, N'KE        ', N'Kenya')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (116, N'KG        ', N'Kyrgyzstan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (117, N'KH        ', N'Cambodia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (118, N'KI        ', N'Kiribati')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (119, N'KM        ', N'Comoros')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (120, N'KN        ', N'Saint Kitts and Nevis')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (121, N'KP        ', N'North Korea')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (122, N'KR        ', N'South Korea')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (123, N'KW        ', N'Kuwait')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (124, N'KY        ', N'Cayman Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (125, N'KZ        ', N'Kazakhstan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (126, N'LA        ', N'Lao People''s Democratic Republic')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (127, N'LB        ', N'Lebanon')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (128, N'LC        ', N'Saint Lucia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (129, N'LI        ', N'Liechtenstein')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (130, N'LK        ', N'Sri Lanka')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (131, N'LR        ', N'Liberia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (132, N'LS        ', N'Lesotho')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (133, N'LT        ', N'Lithuania')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (134, N'LU        ', N'Luxembourg')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (135, N'LV        ', N'Latvia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (136, N'LY        ', N'Libya')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (137, N'MA        ', N'Morocco')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (138, N'MC        ', N'Monaco')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (139, N'MD        ', N'Moldova')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (140, N'ME        ', N'Montenegro')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (141, N'MF        ', N'Saint-Martin (France)')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (142, N'MG        ', N'Madagascar')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (143, N'MH        ', N'Marshall Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (144, N'MK        ', N'Macedonia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (145, N'ML        ', N'Mali')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (146, N'MM        ', N'Myanmar')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (147, N'MN        ', N'Mongolia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (148, N'MO        ', N'Macau')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (149, N'MP        ', N'Northern Mariana Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (150, N'MQ        ', N'Martinique')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (151, N'MR        ', N'Mauritania')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (152, N'MS        ', N'Montserrat')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (153, N'MT        ', N'Malta')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (154, N'MU        ', N'Mauritius')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (155, N'MV        ', N'Maldives')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (156, N'MW        ', N'Malawi')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (157, N'MX        ', N'Mexico')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (158, N'MY        ', N'Malaysia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (159, N'MZ        ', N'Mozambique')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (160, N'NA        ', N'Namibia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (161, N'NC        ', N'New Caledonia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (162, N'NE        ', N'Niger')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (163, N'NF        ', N'Norfolk Island')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (164, N'NG        ', N'Nigeria')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (165, N'NI        ', N'Nicaragua')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (166, N'NL        ', N'The Netherlands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (167, N'NO        ', N'Norway')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (168, N'NP        ', N'Nepal')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (169, N'NR        ', N'Nauru')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (170, N'NU        ', N'Niue')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (171, N'NZ        ', N'New Zealand')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (172, N'OM        ', N'Oman')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (173, N'PA        ', N'Panama')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (174, N'PE        ', N'Peru')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (175, N'PF        ', N'French Polynesia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (176, N'PG        ', N'Papua New Guinea')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (177, N'PH        ', N'Philippines')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (178, N'PK        ', N'Pakistan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (179, N'PL        ', N'Poland')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (180, N'PM        ', N'St. Pierre and Miquelon')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (181, N'PN        ', N'Pitcairn')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (182, N'PR        ', N'Puerto Rico')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (183, N'PS        ', N'Palestine, State of')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (184, N'PT        ', N'Portugal')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (185, N'PW        ', N'Palau')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (186, N'PY        ', N'Paraguay')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (187, N'QA        ', N'Qatar')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (188, N'RE        ', N'Réunion')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (189, N'RO        ', N'Romania')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (190, N'RS        ', N'Serbia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (191, N'RU        ', N'Russian Federation')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (192, N'RW        ', N'Rwanda')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (193, N'SA        ', N'Saudi Arabia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (194, N'SB        ', N'Solomon Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (195, N'SC        ', N'Seychelles')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (196, N'SD        ', N'Sudan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (197, N'SE        ', N'Sweden')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (198, N'SG        ', N'Singapore')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (199, N'SH        ', N'Saint Helena')
GO
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (200, N'SI        ', N'Slovenia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (201, N'SJ        ', N'Svalbard and Jan Mayen Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (202, N'SK        ', N'Slovakia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (203, N'SL        ', N'Sierra Leone')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (204, N'SM        ', N'San Marino')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (205, N'SN        ', N'Senegal')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (206, N'SO        ', N'Somalia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (207, N'SR        ', N'Suriname')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (208, N'SS        ', N'South Sudan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (209, N'ST        ', N'Sao Tome and Principe')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (210, N'SV        ', N'El Salvador')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (211, N'SX        ', N'Sint Maarten (Dutch part)')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (212, N'SY        ', N'Syria')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (213, N'SZ        ', N'Swaziland')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (214, N'TC        ', N'Turks and Caicos Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (215, N'TD        ', N'Chad')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (216, N'TF        ', N'French Southern Territories')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (217, N'TG        ', N'Togo')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (218, N'TH        ', N'Thailand')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (219, N'TJ        ', N'Tajikistan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (220, N'TK        ', N'Tokelau')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (221, N'TL        ', N'Timor-Leste')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (222, N'TM        ', N'Turkmenistan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (223, N'TN        ', N'Tunisia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (224, N'TO        ', N'Tonga')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (225, N'TR        ', N'Turkey')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (226, N'TT        ', N'Trinidad and Tobago')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (227, N'TV        ', N'Tuvalu')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (228, N'TW        ', N'Taiwan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (229, N'TZ        ', N'Tanzania')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (230, N'UA        ', N'Ukraine')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (231, N'UG        ', N'Uganda')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (232, N'UM        ', N'United States Minor Outlying Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (233, N'US        ', N'United States')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (234, N'UY        ', N'Uruguay')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (235, N'UZ        ', N'Uzbekistan')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (236, N'VA        ', N'Vatican')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (237, N'VC        ', N'Saint Vincent and the Grenadines')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (238, N'VE        ', N'Venezuela')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (239, N'VG        ', N'Virgin Islands (British)')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (240, N'VI        ', N'Virgin Islands (U.S.)')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (241, N'VN        ', N'Vietnam')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (242, N'VU        ', N'Vanuatu')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (243, N'WF        ', N'Wallis and Futuna Islands')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (244, N'WS        ', N'Samoa')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (245, N'YE        ', N'Yemen')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (246, N'YT        ', N'Mayotte')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (247, N'ZA        ', N'South Africa')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (248, N'ZM        ', N'Zambia')
INSERT [dbo].[Country] ([CountryID], [Code], [Description]) VALUES (249, N'ZW        ', N'Zimbabwe')
SET IDENTITY_INSERT [dbo].[Country] OFF
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (9, N'Coffee Table', NULL, N'TableType')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (10, N'Dinning Table', NULL, N'TableType')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (11, N'Wood', NULL, N'MaterialType')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (12, N'Glass', NULL, N'MaterialType')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (13, N'Nokia', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (14, N'Samsung', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (15, N'Sony', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (16, N'HTC', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (17, N'Huawei', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (18, N'LG', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (19, N'Alcatel', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (20, N'Motorola', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (21, N'Iphone', NULL, N'MobileBrand')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (22, N'TouchScreen', NULL, N'MobileStyle')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (23, N'KeyPad', NULL, N'MobileStyle')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (24, N'New', NULL, N'Condition')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (25, N'Used', NULL, N'Condition')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (26, N'1.3MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (27, N'2MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (28, N'3.15MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (29, N'4MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (30, N'5MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (31, N'8MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (32, N'13MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (33, N'13.1MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (34, N'16MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (35, N'20MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (36, N'20.7MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (37, N'41MP', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (38, N'VGA 640x480 Pixel', NULL, N'Camera')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (39, N'Unlock', NULL, N'Carrier')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (40, N'Optus', NULL, N'Carrier')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (41, N'Vodafone', NULL, N'Carrier')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (42, N'Telstra', NULL, N'Carrier')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (43, N'Android', NULL, N'OperatingSystem')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (44, N'WindowsPhone8', NULL, N'OperatingSystem')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (45, N'IOS', NULL, N'OperatingSystem')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (46, N'BlackBerry', NULL, N'OperatingSystem')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (47, N'LED-LCD TVs', NULL, N'TVtype')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (48, N'Plasma TVs', NULL, N'TVtype')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (49, N'0-32 in', 47, N'ScreenSize')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (50, N'32-61 in', 47, N'ScreenSize')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (51, N'62-68 in', 47, N'ScreenSize')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (52, N'68+ in', 47, N'ScreenSize')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (53, N'Lumia 925', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (54, N'Lumia 625', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (55, N'Lumia 1020', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (56, N'Lumia 930', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (57, N'Lumia 630', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (58, N'Lumia 1320', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (59, N'Lumia 520', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (60, N'208', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (61, N'Asha 230', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (62, N'Asha 210', 13, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (63, N'Manhatan E3300', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (64, N'Galaxy S5', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (65, N'Galaxy Note3', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (66, N'Galaxy S4', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (67, N'Galaxy S3?', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (68, N'Galaxy Ace3', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (69, N'Galaxy Kzoom', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (70, N'Galaxy S Duos', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (71, N'Galaxy Y Duos', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (72, N'Galaxy S4 Mini', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (73, N'Galaxy C3520', 14, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (74, N'XPeria Z2', 15, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (75, N'XPeria Z', 15, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (76, N'XPeria Z1', 15, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (77, N'XPeria T2', 15, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (78, N'One', 16, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (79, N'One M8', 16, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (80, N'Desire 310', 16, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (81, N'Ascend G6', 17, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (82, N'Ascend Y300', 17, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (83, N'Ascend G526', 17, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (84, N'G2', 18, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (85, N'L80', 18, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (86, N'F70', 18, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (87, N'G Flex', 18, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (88, N'Optimus F5', 18, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (89, N'Nexus 5', 18, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (90, N'One Touch', 19, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (91, N'Moto E', 20, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (92, N'Moto G', 20, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (93, N'4S', 21, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (94, N'5', 21, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (95, N'5S', 21, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (96, N'5C', 21, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (97, N'6', 21, N'MobileModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (98, N'2.5 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (99, N'3 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (100, N'3.5 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (101, N'4 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (102, N'4.5 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (103, N'5 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (104, N'5.5 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (105, N'6 Star', 47, N'EnergyRating')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (106, N'HD', 47, N'ScreenDefinition')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (107, N'FullHD', 47, N'ScreenDefinition')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (108, N'UltraHighDefinition', 47, N'ScreenDefinition')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (109, N'Alfa Romeo', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (110, N'Auston Martin', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (111, N'Audi', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (112, N'Bentley', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (113, N'Austin Healey', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (114, N'BMW', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (115, N'Buick', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (116, N'Cadillac', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (117, N'Chevrolet', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (118, N'Chrysler', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (119, N'Citroen', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (120, N'Daewoo', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (121, N'Daihatsu', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (122, N'Bugatti', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (123, N'Dodge', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (124, N'Ferrari', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (125, N'Fiat', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (126, N'Ford', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (127, N'FPV', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (128, N'Great Wall', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (129, N'Holden', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (130, N'Honda', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (131, N'HSV', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (132, N'Hummer', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (133, N'Hyundai', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (134, N'Isuzu', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (135, N'Jaguar', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (136, N'Jeep', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (137, N'Kia', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (138, N'Lamborghini', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (139, N'Land Rover', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (140, N'Lexus', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (141, N'M.G', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (142, N'Maserati', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (143, N'Mazda', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (144, N'Mercedes', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (145, N'Mini', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (146, N'Mitsubishi', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (147, N'Nissan', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (148, N'Opel', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (149, N'Peugeot', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (150, N'Porsche', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (151, N'Proton', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (152, N'Renault', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (153, N'Rolls Royce', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (154, N'Rover', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (155, N'Saab', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (156, N'Seat', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (157, N'Skoda', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (158, N'Subaru', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (159, N'Suzuki', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (160, N'Toyota', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (161, N'Volkswagon', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (162, N'Volvo', NULL, N'CarMake')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (163, N'147', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (164, N'156', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (165, N'159', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (166, N'164', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (167, N'166', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (168, N'1300', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (169, N'1600', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (170, N'1750', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (171, N'2000', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (172, N'Alfa33', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (173, N'Alfa75', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (174, N'Alfetta', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (175, N'Brera', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (176, N'Giulia', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (177, N'Giulietta', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (178, N'GT', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (179, N'GTV', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (180, N'Mito', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (181, N'Montreal', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (182, N'Spider', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (183, N'Sprint', 109, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (184, N'V8 Vantage', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (185, N'V12 Vantage', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (186, N'V12 Zagato', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (187, N'DB4', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (188, N'DB5', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (189, N'DB6', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (190, N'DB7', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (191, N'DB9', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (192, N'DBS', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (193, N'Cygnet', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (194, N'Lagonda', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (195, N'Rapide', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (196, N'Vanquish', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (197, N'Virage', 110, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (198, N'200T', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (199, N'80', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (200, N'90', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (201, N'A1', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (202, N'A3', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (203, N'A4', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (204, N'A5', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (205, N'A6', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (206, N'A7', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (207, N'A8', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (208, N'S3', 111, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (209, N'S4', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (210, N'S5', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (211, N'RS4', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (212, N'RS5', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (213, N'RS6', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (214, N'S6', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (215, N'S7', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (216, N'S8', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (217, N'R8', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (218, N'V8', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (219, N'Q3', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (220, N'Q5', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (221, N'Q7', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (222, N'Allroad', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (223, N'Cabriolet', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (224, N'TT', 111, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (225, N'Arnage', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (226, N'Azura', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (227, N'Brooklands', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (228, N'Continental', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (229, N'Eight', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (230, N'Mulsanne', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (231, N'S [type]', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (232, N'T', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (233, N'T2', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (234, N'Turbo', 112, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (235, N'100', 113, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (236, N'3000', 113, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (237, N'Sprite', 113, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (238, N'1 Series', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (239, N'116I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (240, N'118D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (241, N'118I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (242, N'120D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (243, N'120I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (244, N'123D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (245, N'125I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (246, N'130I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (247, N'135I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (248, N'M135I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (249, N'3 Series', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (250, N'316I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (251, N'316TI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (252, N'318CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (253, N'318D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (254, N'318I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (255, N'318IS', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (256, N'318TI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (257, N'320CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (258, N'320D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (259, N'320I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (260, N'323CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (261, N'323I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (262, N'325CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (263, N'325E', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (264, N'325I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (265, N'325IS', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (266, N'325TI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (267, N'328CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (268, N'328I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (269, N'330CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (270, N'330D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (271, N'330I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (272, N'335I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (273, N'Alpina', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (274, N'M3', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (275, N'5 Series', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (276, N'520D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (277, N'520I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (278, N'523I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (279, N'525E', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (280, N'525I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (281, N'528I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (282, N'530D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (283, N'530I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (284, N'535D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (285, N'535I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (286, N'540I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (287, N'545I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (288, N'550I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (289, N'Activehy Brid 5', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (290, N'M535I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (291, N'6 Series', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (292, N'633CSI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (293, N'635CSI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (294, N'640I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (295, N'645CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (296, N'650I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (297, N'M635CSI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (298, N'7 Series', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (299, N'730D', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (300, N'730I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (301, N'730IL', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (302, N'733I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (303, N'735I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (304, N'735IL', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (305, N'735LI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (306, N'740I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (307, N'740IL', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (308, N'740LI', 114, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (309, N'745I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (310, N'750I', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (311, N'750IL', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (312, N'750LI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (313, N'760LI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (314, N'8 Series', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (315, N'840CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (316, N'850CI', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (317, N'M Models', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (318, N'1 Series M', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (319, N'M', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (320, N'M3', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (321, N'M5', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (322, N'M6', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (323, N'X Models', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (324, N'X1', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (325, N'X3', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (326, N'X5', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (327, N'X6', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (328, N'Z Models', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (329, N'Z3', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (330, N'Z4', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (331, N'2000', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (332, N'2002', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (333, N'3', 114, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (334, N'Century', 115, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (335, N'Electra', 115, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (336, N'Lesabre', 115, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (337, N'Riviera', 115, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (338, N'Skylark', 115, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (339, N'Super', 115, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (340, N'Calais', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (341, N'CTS', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (342, N'De Ville', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (343, N'Eldorado', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (344, N'Escalade', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (345, N'Fleetwood', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (346, N'Lasalle', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (347, N'Series 62', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (348, N'Series 6200', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (349, N'Seville', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (350, N'20B ATS', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (351, N'20B XTS', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (352, N'20B CTS', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (353, N'20B CTS-V', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (354, N'20B SRX', 116, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (355, N'Spark', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (356, N'Sonic', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (357, N'Cruze', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (358, N'Coorado', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (359, N'Malibu', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (360, N'Camaro', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (361, N'Silverado', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (362, N'Equino X', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (363, N'Express', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (364, N'Impala', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (365, N'Traverse', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (366, N'Black Diamond', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (367, N'Volt', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (368, N'Tahoe', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (369, N'Suburban', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (370, N'Corvette', 117, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (371, N'200', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (372, N'300', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (373, N'300C', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (374, N'Centura', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (375, N'Chrysler', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (376, N'Crossfire', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (377, N'Galant', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (378, N'Grand Voyager', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (379, N'Imperial', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (380, N'Lancer', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (381, N'Le Baron', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (382, N'Neon', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (383, N'New Yorker', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (384, N'Pt Cruiser', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (385, N'Sebring', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (386, N'Bel Air', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (387, N'Blazer', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (388, N'C 10', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (389, N'C 20', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (390, N'C 30', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (391, N'Chevelle', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (392, N'Corvette', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (393, N'Empala', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (394, N'El Camino', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (395, N'Valiant', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (396, N'Valiant Charger', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (397, N'Valiant Regal', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (398, N'Vip', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (399, N'Voyager', 118, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (400, N'ID-19', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (401, N'2CG', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (402, N'Berlingo', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (403, N'C2', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (404, N'C3', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (405, N'C4', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (406, N'C4 Aircross', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (407, N'C5 Saloon', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (408, N'C5 Tourer', 119, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (409, N'Grand C4 Picasso', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (410, N'C6', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (411, N'CX 2500', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (412, N'Dispatch', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (413, N'DS-21', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (414, N'DS3', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (415, N'DS9', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (416, N'DS5', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (417, N'SM', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (418, N'Xantia', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (419, N'XM', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (420, N'Xsara', 119, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (421, N'Cielo', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (422, N'Espero', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (423, N'Kalos', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (424, N'Korando', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (425, N'Lacetti', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (426, N'Lanos', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (427, N'Leganza', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (428, N'Matiz', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (429, N'Musso', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (430, N'Nubira', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (431, N'Tacuma', 120, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (432, N'Applause', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (433, N'Charade', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (434, N'Charade Centro', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (435, N'Copen', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (436, N'Cuore', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (437, N'Delta', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (438, N'Feroza', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (439, N'Feroza II', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (440, N'Gran Max', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (441, N'Handivan', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (442, N'Hi-Jet', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (443, N'Mira', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (444, N'Pyzar', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (445, N'Rocky', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (446, N'Sirion', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (447, N'Terios', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (448, N'YRV', 121, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (449, N'Veyron', 122, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (450, N'Journey', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (451, N'Caliber', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (452, N'Avenger', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (453, N'Chanllenger', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (454, N'Charger', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (455, N'Nitro', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (456, N'Ram', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (457, N'Phoenix', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (458, N'Pelara', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (459, N'Six', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (460, N'Viper', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (461, N'Four', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (462, N'Dakota', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (463, N'Customer Royal', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (464, N'Coronet', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (465, N'Kingsway', 123, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (466, N'GT', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (467, N'F12 Berlinetta', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (468, N'FF', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (469, N'F58 Spider', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (470, N'F58 Italia', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (471, N'California', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (472, N'Enzo', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (473, N'550 Maranello', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (474, N'575 Maranello', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (475, N'F40', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (476, N'599 Fiorano', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (477, N'612 Scaglietti', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (478, N'F430', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (479, N'F355', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (480, N'Testarossa', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (481, N'Mondial', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (482, N'250', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (483, N'308', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (484, N'328', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (485, N'348', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (486, N'360', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (487, N'365', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (488, N'458', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (489, N'458 Italia', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (490, N'512 TR', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (491, N'Dino', 124, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (492, N'124', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (493, N'127', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (494, N'128', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (495, N'130', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (496, N'132', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (497, N'500', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (498, N'600', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (499, N'850', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (500, N'1500', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (501, N'Bravo/Brava', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (502, N'Coupe', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (503, N'Croma', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (504, N'Ducato', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (505, N'Lancia Delta', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (506, N'Punto', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (507, N'Ritmo', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (508, N'Scudo', 125, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (509, N'S.P.A', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (510, N'Tipo', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (511, N'Uno', 125, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (512, N'Escape', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (513, N'Fusion', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (514, N'Focus', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (515, N'Fiesta', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (516, N'Mustang', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (517, N'C-Max', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (518, N'Taurus', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (519, N'Fiesta', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (520, N'EDG E', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (521, N'Flex', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (522, N'Explorer', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (523, N'Expedition', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (524, N'Superduty', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (525, N'E-Series Wagon', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (526, N'Bronco', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (527, N'Capri', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (528, N'Corsair', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (529, N'Cortina', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (530, N'Cougar', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (531, N'Courier', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (532, N'Customline', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (533, N'Econovan', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (534, N'Edsel', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (535, N'E Scort', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (536, N'F-1', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (537, N'F100', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (538, N'F150', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (539, N'F250', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (540, N'F350', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (541, N'F450', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (542, N'F650', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (543, N'Fiarland', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (544, N'Fairmont', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (545, N'Falcon', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (546, N'Falcon UTE', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (547, N'Festive', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (548, N'Fiesta', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (549, N'Galaxie', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (550, N'Galaxy', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (551, N'GT40', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (552, N'KA', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (553, N'Kuga', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (554, N'Landau', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (555, N'Laser', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (556, N'LTD', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (557, N'Mainline', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (558, N'Maverick', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (559, N'Meteor', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (560, N'Model A', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (561, N'Model B', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (562, N'Model T', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (563, N'Mondeo', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (564, N'Mustang', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (565, N'Probe', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (566, N'Raider', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (567, N'Ranchero', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (568, N'Ranger', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (569, N'Shelby', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (570, N'Sierra', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (571, N'Taurus', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (572, N'TE50', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (573, N'Telstar', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (574, N'Telstar TX5', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (575, N'Territory', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (576, N'Thunderbird', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (577, N'TL50', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (578, N'Torino', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (579, N'Trader', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (580, N'Transit', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (581, N'TS50', 126, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (582, N'GS', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (583, N'F6', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (584, N'F6E', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (585, N'F6 Tornado', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (586, N'F6 Typhoon', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (587, N'F6x', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (588, N'Force6', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (589, N'Force8', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (590, N'GT', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (591, N'GT-E', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (592, N'GT-P', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (593, N'Pursuit', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (594, N'Super Pursuit', 127, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (595, N'SA220', 128, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (596, N'V200', 128, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (597, N'V240', 128, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (598, N'X200', 128, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (599, N'X240', 128, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (600, N'1 Tonne', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (601, N'Adventra', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (602, N'Apollo', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (603, N'Astra', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (604, N'Barina', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (605, N'Barina Spark', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (606, N'Belmont', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (607, N'Berlina', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (608, N'Brock', 129, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (609, N'Brougham', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (610, N'Calais', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (611, N'Calibra', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (612, N'Caprice', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (613, N'Captiva', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (614, N'Colorado', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (615, N'Colorado 7', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (616, N'Combo', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (617, N'Commodore', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (618, N'Crewman', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (619, N'Cruze', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (620, N'Drover', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (621, N'EH', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (622, N'EJ', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (623, N'EK', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (624, N'Epica', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (625, N'FB', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (626, N'FC', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (627, N'FJ', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (628, N'Frontera', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (629, N'FX', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (630, N'Gemini', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (631, N'HD', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (632, N'HR', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (633, N'Jackaroo', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (634, N'Kingswood', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (635, N'Monaro', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (636, N'Monterey', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (637, N'Nova', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (638, N'One Tonner', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (639, N'Premier', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (640, N'Rodeo', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (641, N'Sandman', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (642, N'Statesman', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (643, N'Suburban', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (644, N'Tigra', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (645, N'Torana', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (646, N'UTE', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (647, N'Vectra', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (648, N'Viva', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (649, N'Volt', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (650, N'WB', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (651, N'Zafira', 129, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (652, N'CR-Z', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (653, N'Jazz', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (654, N'City', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (655, N'Insight', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (656, N'Civic', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (657, N'CR-V', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (658, N'Accord', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (659, N'Odyssey', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (660, N'Legend', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (661, N'Accord Euro', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (662, N'Concerto', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (663, N'CRX', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (664, N'HR-V', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (665, N'Integra', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (666, N'MOX', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (667, N'NSX', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (668, N'Prelude', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (669, N'S2000', 130, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (670, N'Avalanche', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (671, N'Calais', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (672, N'Clubsport', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (673, N'Commodor', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (674, N'Coupe', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (675, N'Grange', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (676, N'GTS', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (677, N'LS', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (678, N'Maloo', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (679, N'Manta', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (680, N'Nitron', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (681, N'Senator', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (682, N'Statesman', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (683, N'SV Clubsport', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (684, N'SV 300', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (685, N'SV 91', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (686, N'SV 99', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (687, N'VXR', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (688, N'W 427', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (689, N'XU6', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (690, N'XU8', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (691, N'R8 Clubsport', 131, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (692, N'H3', 132, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (693, N'H3T', 132, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (694, N'H3X', 132, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (695, N'H3 Alpha', 132, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (696, N'H2', 132, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (697, N'H2 Sut', 132, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (698, N'i20', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (699, N'i30', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (700, N'Accent', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (701, N'Elantra', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (702, N'i30 Tourer', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (703, N'i40', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (704, N'i45', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (705, N'Veloster', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (706, N'ix35', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (707, N'Santafe', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (708, N'imax', 133, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (709, N'iLoad', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (710, N'HD', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (711, N'Coupe', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (712, N'Elantra Lavita', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (713, N'Excel', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (714, N'Getz', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (715, N'Grandeur', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (716, N'Elantra', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (717, N'S Coup', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (718, N'Sonata', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (719, N'Terracan', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (720, N'Tibaron', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (721, N'Traget', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (722, N'Tucson', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (723, N'Veloster', 133, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (724, N'D-MAN', 134, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (725, N'MU-7', 134, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (726, N'Panther', 134, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (727, N'420', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (728, N'420 G', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (729, N'E [type]', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (730, N'Mark II', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (731, N'Mark IV', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (732, N'Mark V', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (733, N'Mark VII', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (734, N'Mark X', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (735, N'S-[type]', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (736, N'Sovereign', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (737, N'X-[type]', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (738, N'XF', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (739, N'XFR', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (740, N'XFS', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (741, N'XJ', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (742, N'F-[type]', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (743, N'XJ 6', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (744, N'XJ 8', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (745, N'XJR', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (746, N'XJS', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (747, N'XK', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (748, N'XKR', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (749, N'XKR-5', 135, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (750, N'Cherokee', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (751, N'CJ 6', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (752, N'CJ 7', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (753, N'CJ 8', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (754, N'Commander', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (755, N'Compass', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (756, N'Grand Cherokee', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (757, N'J 10', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (758, N'J 20', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (759, N'Patriot', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (760, N'Wagoneer', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (761, N'Wrangler', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (762, N'Liberty', 136, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (763, N'Rio Reborn', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (764, N'Cerato', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (765, N'Soul', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (766, N'Optima', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (767, N'Sportage', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (768, N'Rondo 7', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (769, N'Grand Carnival', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (770, N'Carens ', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (771, N'Carnival', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (772, N'K 2700', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (773, N'K 2900', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (774, N'Magentis', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (775, N'Mentor', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (776, N'Pregio', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (777, N'Sorento', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (778, N'Spectra', 137, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (779, N'Aventador', 138, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (780, N'Diablo', 138, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (781, N'Gallardo', 138, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (782, N'Murcielago', 138, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (783, N'Defender', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (784, N'Freelander 2', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (785, N'Rangrover Evoque', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (786, N'Discovery 4', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (787, N'Rangrover Sport', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (788, N'110', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (789, N'Discovery 3', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (790, N'Discovery', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (791, N'Free Lander', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (792, N'Rangrover Vogue', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (793, N'Rover', 139, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (794, N'LS', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (795, N'GS', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (796, N'ES', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (797, N'HS', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (798, N'I S', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (799, N'I SC', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (800, N'CT', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (801, N'LX', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (802, N'GX', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (803, N'RX', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (804, N'LFA', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (805, N'I SF', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (806, N'LF-CC', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (807, N'LF-LC', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (808, N'LF-Gh', 140, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (809, N'LS', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (810, N'SC', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (811, N'Others', 140, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (812, N'MG6 GT', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (813, N'MG6 Magenta', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (814, N'MG6 BTCC', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (815, N'MG3', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (816, N'MG5', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (817, N'A', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (818, N'B', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (819, N'C', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (820, N'F', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (821, N'Midget', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (822, N'RV8', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (823, N'TC', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (824, N'TD', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (825, N'TF', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (826, N'ZR', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (827, N'ZT', 141, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (828, N'222', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (829, N'228', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (830, N'3200 GT', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (831, N'BI Turbo', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (832, N'Coupe', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (833, N'Ghibli', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (834, N'Gran Cabrio', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (835, N'Gran Sport', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (836, N'Gran Turismo', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (837, N'Indy', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (838, N'Kyalami', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (839, N'Merak', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (840, N'Quattroporte', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (841, N'Spyder', 142, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (842, N'1000', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (843, N'121', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (844, N'1300', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (845, N'1500', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (846, N'2', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (847, N'3', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (848, N'323', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (849, N'6', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (850, N'626', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (851, N'808', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (852, N'929', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (853, N'B2200', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (854, N'B2600', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (855, N'Bongo', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (856, N'Bravo', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (857, N'BT-50', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (858, N'Capella RX-2', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (859, N'Cosmo', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (860, N'CX-5', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (861, N'CX-7', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (862, N'CX-9', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (863, N'E 1800', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (864, N'E 2000', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (865, N'E 2200', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (866, N'E 2500', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (867, N'Eunos 30X', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (868, N'Eunos 800', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (869, N'Familia', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (870, N'Millenia', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (871, N'MPV', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (872, N'MX-5', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (873, N'MX-6', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (874, N'Premacy', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (875, N'R100', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (876, N'RX-3', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (877, N'RX-4', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (878, N'RX-7', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (879, N'RX-8', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (880, N'T3000', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (881, N'T 3500', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (882, N'T 4600', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (883, N'Tribute', 143, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (884, N'A Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (885, N'B Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (886, N'C Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (887, N'CLK Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (888, N'E Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (889, N'M Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (890, N'S Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (891, N'SL Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (892, N'SLK Class', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (893, N'180', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (894, N'190 C', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (895, N'190 D', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (896, N'220', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (897, N'220 S', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (898, N'220 SE', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (899, N'230', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (900, N'230 CE', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (901, N'230 TE', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (902, N'240 D', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (903, N'250', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (904, N'250 C', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (905, N'250 CE', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (906, N'250 S', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (907, N'280 CE', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (908, N'280 TE', 144, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (909, N'300 D', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (910, N'300 TD', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (911, N'300 TE', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (912, N'320 CE', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (913, N'320 E', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (914, N'350SLC', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (915, N'450SLC', 144, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (916, N'Ray', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (917, N'Cooper', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (918, N'Bayswater', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (919, N'Baker Street', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (920, N'Cabrio', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (921, N'Clubman', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (922, N'Countryman', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (923, N'Paceman', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (924, N'Coupe', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (925, N'Roadster', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (926, N'Malism', 145, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (927, N'Mirage', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (928, N'Minicab', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (929, N'Outlander', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (930, N'Outlander EX', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (931, N'Outlander XL', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (932, N'Outlander ASX', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (933, N'Outlander RVR', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (934, N'Outlander Sport', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (935, N'I- Miev', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (936, N'Triton', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (937, N'Lancer', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (938, N'Colt', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (939, N'Pajero', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (940, N'Toppo', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (941, N'Minicab', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (942, N'Delsca', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (943, N'Montero', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (944, N'EK', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (945, N'Eclipse', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (946, N'Grandis', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (947, N'Galant', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (948, N'Endeavor', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (949, N'L 300', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (950, N'ASX', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (951, N'L200', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (952, N'3000 GT', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (953, N'380', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (954, N'Canter', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (955, N'Chanlenger', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (956, N'Cordia', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (957, N'Express', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (958, N'Fighter', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (959, N'FTO', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (960, N'Galant', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (961, N'Grandis', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (962, N'GTO', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (963, N'I- Car', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (964, N'Legnum', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (965, N'Magna', 146, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (966, N'1200', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (967, N'180 SX', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (968, N'200 SX', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (969, N'200 ZR', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (970, N'200 ZX', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (971, N'350 Z', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (972, N'30 Z', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (973, N'720', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (974, N'Almera', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (975, N'Bluebird', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (976, N'Caravan', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (977, N'Cedric', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (978, N'Cefiro', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (979, N'Cima', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (980, N'Civilian', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (981, N'Cube', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (982, N'Dualis', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (983, N'Elgrand', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (984, N'EXA', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (985, N'Gloria', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (986, N'GT-R', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (987, N'Infiniti', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (988, N'Laurel', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (989, N'Leaf', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (990, N'Maxima', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (991, N'Micra', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (992, N'Murano', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (993, N'Navara', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (994, N'Nomad', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (995, N'NX', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (996, N'Pathfinder', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (997, N'Patrol', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (998, N'Pintara', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (999, N'Prairie', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1000, N'Pulsar', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1001, N'Scargo', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1002, N'Serena', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1003, N'Silvia', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1004, N'Skyline', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1005, N'Stadea', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1006, N'Terrano II', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1007, N'Tiida', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1008, N'Urvan', 147, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1009, N'X- Trail', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1010, N'NV 350', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1011, N'Note', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1012, N'Versa HB', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1013, N'Sunny', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1014, N'Latio', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1015, N'Tsuru', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1016, N'Sentra', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1017, N'Sylphy', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1018, N'Altima', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1019, N'Maxima', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1020, N'Teena', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1021, N'Livina', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1022, N'Grand Livina', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1023, N'GT- R', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1024, N'Fairlady Z', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1025, N'Wingroad', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1026, N'Lefeeta', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1027, N'Serena', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1028, N'Quest', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1029, N'Jake', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1030, N'Qashqai', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1031, N'Rogue', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1032, N'X-Trail', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1033, N'XTrerra', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1034, N'Armada', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1035, N'Patrol', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1036, N'Navara', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1037, N'Titan', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1038, N'AD', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1039, N'NP 200', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1040, N'NP 300', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1041, N'NV 200', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1042, N'NV 350', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1043, N'Caravan', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1044, N'NV 400', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1045, N'Primastar', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1046, N'NV 1500', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1047, N'Atlas', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1048, N'Atleon', 147, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1049, N'Corsa 3', 148, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1050, N'Corsa 5', 148, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1051, N'Astra', 148, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1052, N'Insgnia', 148, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1053, N'205', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1054, N'206', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1055, N'207', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1056, N'208', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1057, N'306', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1058, N'307', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1059, N'308', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1060, N'309', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1061, N'405', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1062, N'406', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1063, N'407', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1064, N'505', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1065, N'508', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1066, N'607', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1067, N'3008', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1068, N'4007', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1069, N'4008', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1070, N'Expert', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1071, N'Partner', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1072, N'RCZ', 149, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1073, N'356', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1074, N'356 A', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1075, N'356 B', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1076, N'356 C', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1077, N'356 SC', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1078, N'911', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1079, N'911 Carrera', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1080, N'911 Targa', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1081, N'912', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1082, N'914', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1083, N'918 Spyder', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1084, N'924', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1085, N'928', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1086, N'930', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1087, N'944', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1088, N'959', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1089, N'968', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1090, N'Boxster', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1091, N'Carrera', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1092, N'Cayman', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1093, N'Cayenne', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1094, N'Macan Sux', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1095, N'Panamera', 150, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1096, N'S16 FLX', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1097, N'GEN 2', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1098, N'Exora', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1099, N'Persona Elegance', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1100, N'Jumbuck', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1101, N'M 21', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1102, N'Satra', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1103, N'Savvy', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1104, N'Wira', 151, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1105, N'Clio', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1106, N'Fluence', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1107, N'Kangoo', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1108, N'Koleos', 152, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1109, N'Laguna', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1110, N'Latitude', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1111, N'Master', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1112, N'Megane', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1113, N'Scenic', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1114, N'Trafic', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1115, N'5', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1116, N'Floride', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1117, N'Dauphine', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1118, N'Twingo', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1119, N'Espace', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1120, N'Duster', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1121, N'Talisman', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1122, N'Dacia Dokker', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1123, N'Dacia Sandero', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1124, N'Dacia Lagan', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1125, N'Dacia Lodgy', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1126, N'Dacia Duster', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1127, N'Scala', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1128, N'Symbol', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1129, N'Modus', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1130, N'Fluence', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1131, N'Pulse', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1132, N'Sandero', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1133, N'Wind', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1134, N'Zoe', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1135, N'Twizy', 152, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1136, N'Phantom', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1137, N'20125', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1138, N'Camargue', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1139, N'Corniche', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1140, N'Flying Spur', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1141, N'Ghost', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1142, N'Silver Shadow', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1143, N'Silver Spirit', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1144, N'Silver Spur', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1145, N'Silver Wraiih', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1146, N'Silver Cloud', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1147, N'Silver Seraph', 153, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1148, N'2000', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1149, N'3 Litre', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1150, N'3.5 LT', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1151, N'3500', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1152, N'416 I', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1153, N'75', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1154, N'827', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1155, N'Mini', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1156, N'P3', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1157, N'P4', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1158, N'Quintet', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1159, N'75', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1160, N'Noble M12', 154, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1161, N'41707', 155, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1162, N'41768', 155, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1163, N'900', 155, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1164, N'9000', 155, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1165, N'900 I', 155, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1166, N'99', 155, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1167, N'MII', 156, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1168, N'Ibiza', 156, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1169, N'Leon', 156, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1170, N'Altea', 156, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1171, N'Exeo', 156, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1172, N'Alhambra', 156, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1173, N'Cordoba', 156, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1174, N'Citigo', 157, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1175, N'Fabia', 157, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1176, N'Octavia', 157, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1177, N'Superb', 157, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1178, N'Roomster', 157, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1179, N'Praktik', 157, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1180, N'Yeti', 157, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1181, N'Tribeca', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1182, N'Legacy', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1183, N'Outback', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1184, N'Impreza', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1185, N'XV', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1186, N'WRX', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1187, N'Forester', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1188, N'BRZ', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1189, N'Bumby', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1190, N'L Series', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1191, N'Liberty', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1192, N'Sportswagon', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1193, N'SVX', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1194, N'Tribeca', 158, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1195, N'Swift', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1196, N'Alto/Celerio', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1197, N'Splash', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1198, N'SX 4', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1199, N'Jimmy', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1200, N'Grand Vitara', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1201, N'Kizashi', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1202, N'APV', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1203, N'Alto', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1204, N'Baleno', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1205, N'Cappuccino', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1206, N'Carry', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1207, N'Cultus', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1208, N'Hatch', 159, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1209, N'Ignis', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1210, N'Kizashi', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1211, N'Liana', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1212, N'LJ 80V', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1213, N'LJ 81K', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1214, N'Mighty Boy', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1215, N'Sierra', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1216, N'X- 90', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1217, N'XL- 7', 159, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1218, N'86', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1219, N'Aurion', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1220, N'Avalon', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1221, N'Avanza', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1222, N'Avensis', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1223, N'Aygo', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1224, N'Camry', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1225, N'Corolla', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1226, N'Crown', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1227, N'Prius', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1228, N'Prius- C', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1229, N'RAV4', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1230, N'Vios', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1231, N'Yaris', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1232, N'Zelas', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1233, N'Alphard', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1234, N'Fortuner', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1235, N'Innova', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1236, N'Previa', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1237, N'Sienna', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1238, N'Verso', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1239, N'Verso- S', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1240, N'4 Runner', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1241, N'FJ Cruiser', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1242, N'Hilux', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1243, N'Land Cruz 200', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1244, N'Land Cruz 70', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1245, N'Land Cruz Prado', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1246, N'Equoia', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1247, N'Tacoma', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1248, N'Tundra', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1249, N'Urban Cruiser', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1250, N'Prius', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1251, N'Prius C', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1252, N'Prius V', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1253, N'Regius', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1254, N'Rukus', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1255, N'Sera', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1256, N'Soarer', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1257, N'Spacia', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1258, N'Sprinter', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1259, N'Starlet', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1260, N'Stout', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1261, N'Supra', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1262, N'Tarago', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1263, N'Townace', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1264, N'Tundra', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1265, N'Vanguard', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1266, N'Vellfire', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1267, N'Vienta', 160, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1268, N'1500', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1269, N'1600', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1270, N'Amarok', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1271, N'Beetle', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1272, N'Bora', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1273, N'Caddy', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1274, N'Caravelle', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1275, N'CC', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1276, N'Crafter', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1277, N'EOS', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1278, N'Golf', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1279, N'Jetta', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1280, N'Karmann Ghia', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1281, N'Kombi', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1282, N'Kombi Transporter', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1283, N'LT', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1284, N'Multivan', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1285, N'Passat', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1286, N'Polo', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1287, N'Scirocco', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1288, N'Superbug', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1289, N'Tiguan', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1290, N'Touareg', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1291, N'Transporter', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1292, N'UP', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1293, N'Vento', 161, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1294, N'122', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1295, N'144', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1296, N'164', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1297, N'240', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1298, N'242', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1299, N'244', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1300, N'440', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1301, N'740', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1302, N'760', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1303, N'850', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1304, N'940', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1305, N'960', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1306, N'C 30', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1307, N'C 70', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1308, N'Cross Country', 162, N'CarModel')
GO
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1309, N'FL 10', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1310, N'P 1800', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1311, N'S 40', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1312, N'S 60', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1313, N'S 70', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1314, N'S 80', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1315, N'S 90', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1316, N'V 40', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1317, N'V 50', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1318, N'V 60', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1319, N'V 70', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1320, N'XC 60', 162, N'CarModel')
INSERT [dbo].[Lookup] ([LookupID], [Description], [ParentID], [Type]) VALUES (1321, N'XC 70', 162, N'CarModel')
SET IDENTITY_INSERT [dbo].[NotificationTemplate] ON 

INSERT [dbo].[NotificationTemplate] ([NotificationTemplateID], [Description], [TemplatePath], [NotificationTypeID], [Subject]) VALUES (1, N'AccountDisable', N'C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\AccountDisable.xslt', 1, N'Account Disable')
INSERT [dbo].[NotificationTemplate] ([NotificationTemplateID], [Description], [TemplatePath], [NotificationTypeID], [Subject]) VALUES (2, N'ActivationEmail', N'C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\ActivationEmail.xslt', 1, N'Activation Email')
INSERT [dbo].[NotificationTemplate] ([NotificationTemplateID], [Description], [TemplatePath], [NotificationTypeID], [Subject]) VALUES (5, N'AdvertisementInsert', N'C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\AdvertisementInsert.xslt', 1, N'Advertisement Added')
INSERT [dbo].[NotificationTemplate] ([NotificationTemplateID], [Description], [TemplatePath], [NotificationTypeID], [Subject]) VALUES (6, N'AdvertisementSuspend', N'C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\AdvertisementSuspend.xslt', 1, N'Advertisement Suspend')
INSERT [dbo].[NotificationTemplate] ([NotificationTemplateID], [Description], [TemplatePath], [NotificationTypeID], [Subject]) VALUES (7, N'ResetPassword', N'C:\Data\OziBazaar\OziBazaar\OziBazaar.Notification\Templates\ResetPassword.xslt', 1, N'Reset Password')
SET IDENTITY_INSERT [dbo].[NotificationTemplate] OFF
SET IDENTITY_INSERT [dbo].[NotificationType] ON 

INSERT [dbo].[NotificationType] ([NotificationTypeID], [Description]) VALUES (1, N'Email')
INSERT [dbo].[NotificationType] ([NotificationTypeID], [Description]) VALUES (2, N'Sms')
SET IDENTITY_INSERT [dbo].[NotificationType] OFF
SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (1, N'yy', 1)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (2, N'hh', 1)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (3, N'test ing something new', 1)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (5, N'csdfsd', 1)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (6, N'Another test', 1)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (8, N'Mazda', 2)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (10, N'test', 4)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (14, N'nokia', 1)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (26, N'rest', 1)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (1025, N'ttt', 12)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (1026, N'testi', 16)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (1027, N'test2', 16)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (1028, N'gh', 29)
INSERT [dbo].[Product] ([ProductID], [Description], [ProductGroupID]) VALUES (1029, N'job1', 35)
SET IDENTITY_INSERT [dbo].[Product] OFF
SET IDENTITY_INSERT [dbo].[ProductGroup] ON 

INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (1, N'Mobile', N'~/Templates/DefaultProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (2, N'Car', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (3, N'TVs', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (4, N'Tables', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (5, N'LivingRoomFurniture', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (6, N'Lounge Furniture', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (7, N'Bed & Suites', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (8, N'Taps&ShowerHeads', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (9, N'Vanities & Units', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (10, N'Toilets & Bidets', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (11, N'Coffee Machines', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (12, N'Kettles', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (13, N'Food Processors', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (14, N'Rice Cooker', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (15, N'Toaster', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (16, N'Microwaves', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (17, N'Dishwashers', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (18, N'Ovens,Cooktops And Rangehoods', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (19, N'Refrigerators & Freezers', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (20, N'Air Conditioners & Heaters', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (21, N'Washing Machine & Dryers', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (22, N'Vaccume Cleaners', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (23, N'Outdoor Furniture', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (24, N'Air Tools', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (25, N'Cordless Tools', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (26, N'Hand Tools', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (27, N'Power Tools', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (28, N'Women Cloths', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (29, N'Women Shoes', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (30, N'Women Accessories', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (31, N'Men Cloths', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (32, N'Men Shoes', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (33, N'Men Accessories', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (34, N'Bags', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
INSERT [dbo].[ProductGroup] ([ProductGroupID], [Description], [ViewTemplate], [EditTemplate], [CategoryID]) VALUES (35, N'Job', N'~/Templates/TwoColumnsProduct.xslt', NULL, NULL)
SET IDENTITY_INSERT [dbo].[ProductGroup] OFF
SET IDENTITY_INSERT [dbo].[ProductGroupProperty] ON 

INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (2, 1, 2, NULL, 2, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (4, 1, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 3, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (5, 2, 4, NULL, 4, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (6, 2, 5, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 5, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (7, 2, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 6, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (8, 2, 2, NULL, 7, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (9, 1, 6, NULL, 4, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (10, 2, 6, NULL, 8, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (11, 2, 7, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (12, 2, 8, NULL, 2, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (15, 4, 11, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (16, 4, 12, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (17, 1, 13, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (18, 1, 25, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (19, 1, 26, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (20, 1, 27, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (21, 1, 28, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (22, 1, 29, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (30, 3, 31, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (31, 3, 34, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (32, 6, 35, N'Fabric;Leather;Polyurethane;Suede;Vinyl', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (33, 6, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (34, 7, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (35, 7, 36, N'Single;Double;King Single;Queen;King', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (36, 1, 37, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (37, 3, 38, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (38, 3, 39, N'Yes;No', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (39, 3, 40, NULL, 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (44, 3, 44, N'Samsung;LG;Panasonic;Hisense;Sony;TCL;GVA;Teac;Sharp;Philips;Palsonic', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (45, 7, 46, N'MDF;Metal;Stainless Steel;Timber;Leather', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (46, 8, 47, N'Shower Head;Basin Mixers & Sets;Bath Mixers & Sets;Shower Mixers', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (47, 8, 48, N'Chrome;Satin Chrome;Brass,Copper,Bronze;Stainless Steel;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (48, 9, 49, N'Oval;Square;Rectangular;Round', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (49, 9, 35, N'Ceramic & Stone;Glass', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (50, 10, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (51, 10, 51, N'Free Standing;Wall Mounted', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (52, 10, 35, N'China;Procelain;Granite/Marble;Stainless Steel', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (53, 10, 49, N'Oval;Round', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (54, 11, 44, N'Breville;Delonghi;Dolce Gusta;Jura;Lavazza;Miele;Smeg;Sunbeam;Philips;Bosch', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (55, 11, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (56, 12, 44, N'Breville;Delonghi;Kenwood;Sunbeam;Morphy Richards', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (57, 12, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (58, 13, 44, N'Sunbeam;Kenwood;Breville;Kambrook;Philips;Russell Hobbs;Electrolux;GVA;Tefal', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (59, 14, 44, N'Breville;Kambrook;Philips;George Foreman;Sunbeam;GVA;Tefal', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (60, 15, 44, N'Breville;Kambrook;Russell Hobbs;Kenwood;Sunbeam;Tefal', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (61, 16, 44, N'AEG;Bosch;Electrolux;Hillmark;LG;Panasonic;Samsung;Sharp;Smeg;Westinghouse;Whirlpool', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (62, 16, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (63, 16, 52, N'China;Germany;Korea;Thailand', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (64, 16, 53, N'20L;23L;26L;27L;28L;30L;32L;34L;36L;38L;40L', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (65, 17, 44, N'AEG;Ariston;Asko;Blanco;Bosch;Dishlex;Fisher & Paykel;Glem;LG;Miele;Smeg;Westinghouse', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (66, 17, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (67, 17, 52, N'China;Poland;Germany', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (68, 17, 54, N'2.5 Stars;3 Stars;3.5 Stars;4 Stars;4.5 Stars', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (69, 18, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (70, 18, 44, N'Delonghi;Westinghouse;Smeg;Bosch;Chef;Technika;Fisher & Pykel;Electrolux;Blanco;Omega;Asko;Euromaid;Emilia;Abey;Baumatic', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (71, 18, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (72, 19, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (73, 19, 44, N'Samsung;Westinghouse;Fisher & Pykel;Hisense;LG;Electrolux;GVA;Kelvinator;Panasonic;Haier;Sharp', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (74, 19, 54, N'1 Star;1.5 Star;2 Star;2.5 Star;3 Star;3.5 Star;4 Star;N/A', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (75, 20, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (76, 20, 44, N'Fujitsu;Panasonic;Samsung;Convair;Mitsubishi;Aircon Off;LG', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (77, 21, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (78, 21, 44, N'Samsung;LG;Fisher & Paykel;Simpson;Bosch;Asko;Hoover;Electrolux;Hisense;Euromaid;Haier', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (79, 21, 54, N'1.5 Stars;2 Stars;2.5 Stars;3 Stars;3.5 Stars;4 Stars;4.5 Stars;5 Stars', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (80, 22, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (81, 22, 44, N'Dyson;Bissell;Electrolux;Miele;Vax;Black & Decker;Samsung;Volta;Kenwood;LG', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (82, 23, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (83, 24, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (84, 25, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (85, 26, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (86, 27, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (87, 28, 50, N'Dresses;Coats;Jackets;Jeans & Pants;Tops & T-Shirts;Skirts;Swimwears;Sleepwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (88, 28, 3, N'Black;Blue;Brown;Charcoal;Cream;Dark Gray;Gold;Green;Gray;Multi;Natural;Orange;Pattern;Pink;Purple;Red;Silver;Skin;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (89, 28, 36, N'6;8;10;12;14;16;18;20;22;24;26;XXS;XS;S;M;L;XL;XXL', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (90, 29, 50, N'Boots;Casuals;Flats;Heels;Runners;Sandals;Slippers;Thongs;Other Shoes', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (91, 29, 3, N'Black;Blue;Brown;Cream;Gold;Green;Gray;Metalic;Orange;Pink;Purple;Red;Silver;White;Yellow;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (92, 29, 36, N'5;5 1/2;6;6 1/2;7;7 1/2;8;8 1/2;9;9 1/2;10;10 1/2;11;11 1/2;12;12 1/2;35;36;37;38;39;40;41;42;43;44', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (93, 30, 50, N'Belts;Gloves;Hair Accessories;Hats;Sunglasses;Umbrellas;Wallets & Purses;Watches;Other Accessories', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (94, 31, 50, N'Shirts;T-Shirts;Pants & Shorts;Coats & Jackets;Underwears & Socks;Sleepwears;Knitwears;Other Cloths', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (95, 31, 3, N'Black;Blue;Coral;Green;Gray;Navy;Pink;Purple;Red;Raspberry;Silver;White;Other Colour', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (96, 31, 36, N'36;37;38;39;40;41;42;43;44;45;46;XS;S;M;L;XL;XXL', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (97, 32, 50, N'Boots;Business Shoes;Casual Shoes;Other Shoes', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (98, 32, 3, N'Beige;Black;Blue;Brown;Green;Gray;Navy;Red;Tan;White;Yellow', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (99, 32, 36, N'6;7;8;9;10;11;12;13;14;15;30;31;32;33;34;35;36;37;38;39;40;41;42;43;44;45;46;47', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (100, 33, 50, N'Belts;Hats;Gloves;Scarves;Men Grooming;Sunglasses;Ties;Watches;Other Accessories', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (101, 34, 50, N'Women Bags;Men Bags', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (102, 35, 55, N'Administration & Office;Art & Media;Customer Services;Construction;Education;Engineering;Financial Service;Banking;Graduate;HealthCare;Hospitality;Human Resources;IT;Marketing;Retail;Sales;Real State & Property;Web Design;Volunteer;Other Job ', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (103, 35, 56, N'0-30K;30K-50K;50K-70K;70K-100K;100K-150K;150K-200K', 1, 1)
INSERT [dbo].[ProductGroupProperty] ([ProductGroupPropertyID], [ProductGroupID], [PropertyID], [InitialValue], [TabOrder], [IsMandatory]) VALUES (104, 35, 50, N'Full Time;Part Time;Contract;Casual', 1, 1)
SET IDENTITY_INSERT [dbo].[ProductGroupProperty] OFF
SET IDENTITY_INSERT [dbo].[ProductImage] ON 

INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (5, 1, N'/Content/Image/button.png', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (6, 1, N'/Content/Image/buyicon2.png', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (7, 1, N'/Content/Image/Cancel.png', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (8, 1, N'/Content/Image/changecategory.png', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (9, 1, N'/Content/Image/homepage01.jpg', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (10, 1, N'/Content/Image/homepage03.jpg', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (11, 1, N'/Content/Image/homepage05.png', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (12, 3, N'/Content/Image/mazda1.jpg', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (13, 8, N'/Content/Image/mazda2.jpg', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (14, 8, N'/Content/Image/mazda1.jpg', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (19, 14, N'/Content/Image/shopping (1).jpg', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (21, 14, N'/Content/Image/shopping.jpg', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (26, 6, N'/Content/Image/mazda2.jpg', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (27, 26, N'/Content/Image/mobile2.jpg', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (28, 26, N'/Content/Image/mobile1.jpg', N'Image', N'image', N'Description', 1, NULL)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (1026, 1025, N'/Content/Image/exporttoPdf.png', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (1027, 1026, N'/Content/Image/Chrysanthemum.jpg', N'Image', N'image', N'Description', 1, 1)
INSERT [dbo].[ProductImage] ([ProductImageID], [ProductID], [ImagePath], [ImageType], [MimeType], [Description], [ImageOrder], [IsThumbnail]) VALUES (1028, 1028, N'/Content/Image/magnifier.gif', N'Image', N'image', N'Description', 1, 1)
SET IDENTITY_INSERT [dbo].[ProductImage] OFF
SET IDENTITY_INSERT [dbo].[ProductProperty] ON 

INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (2, 1, 2, N'yyyyyy')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (3, 1, 4, N'Red')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (5, 2, 2, N'uuu')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (6, 2, 4, N'Green')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (9, 3, 2, N'test')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (10, 3, 4, N'Green')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (17, 5, 2, N'sdfsdf')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (18, 5, 4, N'Red')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (93, 8, 11, N'Mazda')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (94, 8, 12, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (96, 8, 5, N'IsAutomatic')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (97, 8, 6, N'Manual')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (98, 8, 7, N'Green')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (99, 8, 8, N'in a very good condition')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (115, 10, 15, N'Dinning Table')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (116, 10, 16, N'Glass')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (299, 6, 17, N'Samsung')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (300, 6, 18, N'KeyPad')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (301, 6, 19, N'Used')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (302, 6, 20, N'8MP')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (303, 6, 21, N'Vodafone')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (304, 6, 22, N'WindowsPhone8')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (305, 6, 36, N'Manhatan E3300')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (306, 6, 2, N'dddd')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (307, 6, 4, N'Green')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (323, 14, 17, N'Samsung')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (324, 14, 18, N'KeyPad')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (325, 14, 19, N'Used')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (326, 14, 20, N'4MP')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (327, 14, 21, N'Optus')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (328, 14, 22, N'WindowsPhone8')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (329, 14, 36, N'Galaxy S4')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (330, 14, 2, N'good')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (331, 14, 4, N'Red')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (333, 26, 17, N'Samsung')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (334, 26, 18, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (335, 26, 19, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (336, 26, 20, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (337, 26, 21, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (338, 26, 22, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (339, 26, 36, N'Manhatan E3300')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (340, 26, 2, N'test')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (341, 26, 4, N'White')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1332, 1025, 56, N'Kenwood')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1342, 1026, 61, N'Bosch')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1343, 1026, 62, N'Stainless Steel')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1344, 1026, 63, N'Germany')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1345, 1026, 64, N'30L')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1346, 1027, 61, N'Electrolux')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1347, 1027, 62, N'Stainless Steel')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1348, 1027, 63, N'Korea')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1349, 1027, 64, N'40L')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1350, 1028, 90, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1351, 1028, 91, N'Green')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1352, 1028, 92, N'')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1353, 1029, 102, N'Education')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1354, 1029, 103, N'100K-150K')
INSERT [dbo].[ProductProperty] ([ProductPropertyID], [ProductID], [ProductGroupPropertyID], [Value]) VALUES (1355, 1029, 104, N'Contract')
SET IDENTITY_INSERT [dbo].[ProductProperty] OFF
SET IDENTITY_INSERT [dbo].[Property] ON 

INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (2, N'Description', N'Description', N'TextArea', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (3, N'Color', N'Color', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (4, N'IsAutomatic', N'Handling Type', N'CheckBox', N'bool', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (5, N'EnginType', N'Engine Type', N'RadioButton', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (6, N'Image', N'Image', N'Image', N'Image', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (7, N'CarMake', N'Car Make', N'DropDown', N'Lookup', N'CarMake', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (8, N'CarModel', N'Car Model', N'DropDown', N'Lookup', N'CarModel', N'CarMake')
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (11, N'TableType', N'Table type', N'DropDown', N'Lookup', N'TableType', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (12, N'Material', N'Material', N'DropDown', N'Lookup', N'MaterialType', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (13, N'MobileBrand', N'Mobile Brand', N'DropDown', N'Lookup', N'MobileBrand', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (25, N'MobileStyle', N'Mobile Style', N'DropDown', N'Lookup', N'MobileStyle', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (26, N'Condition', N'Condition', N'DropDown', N'Lookup', N'Condition', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (27, N'Camera', N'Camera', N'DropDown', N'Lookup', N'Camera', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (28, N'Carrier', N'Carrier', N'DropDown', N'Lookup', N'Carrier', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (29, N'OperatingSystem', N'Operating System', N'DropDown', N'Lookup', N'OperatingSystem', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (31, N'TVtype', N'TV Type', N'DropDown', N'Lookup', N'TVtype', NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (34, N'ScreenSize', N'Screen Size', N'DropDown', N'Lookup', N'ScreenSize', N'TVtype')
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (35, N'Material', N'Material', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (36, N'Size', N'Size', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (37, N'MobileModel', N'Mobile Model', N'DropDown', N'Lookup', N'MobileModel', N'MobileBrand')
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (38, N'EnergyRating', N'Energy rating', N'DropDown', N'Lookup', N'EnergyRating', N'TVtype')
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (39, N'Smart TV', N'Smart TV', N'RadioButton', N'String', NULL, N'TVtype')
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (40, N'ScreenDefinition', N'Screen Definition', N'DropDown', N'Lookup', N'ScreenDefinition', N'TVtype')
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (44, N'Brand', N'Brand', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (46, N'FrameMaterial', N'Frame Material', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (47, N'TapsType', N'Taps Type', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (48, N'Tapeware Mounting', N'Tapeware Mounting', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (49, N'Bowl Shape', N'Bowl Shape', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (50, N'Type', N'Type', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (51, N'Mounting', N'Mounting', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (52, N'MadeIn', N'Made In', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (53, N'Capacity', N'Capacity', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (54, N'EnergyRating', N'Energy Rating', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (55, N'Categories', N'Categories', N'DropDown', N'String', NULL, NULL)
INSERT [dbo].[Property] ([PropertyID], [KeyName], [Title], [ControlType], [DataType], [LookupType], [DependsOn]) VALUES (56, N'Salary', N'Salary', N'DropDown', N'String', NULL, NULL)
SET IDENTITY_INSERT [dbo].[Property] OFF
SET IDENTITY_INSERT [dbo].[UserProfile] ON 

INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (1, N'Administrator', N'admin@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (2, N'sami', N'behtash2@gmail.com', N'sami', NULL, NULL, NULL, NULL, N'098', 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (3, N'behtash', N'behtash@gmail.com', N'behtash', 7, N'Romsey street', N'Waitara', N'2070', N'09', 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (4, N'asghar', N'asghar@gmail.com', N'asghar', NULL, NULL, NULL, NULL, N'09', 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (5, N'asghar2', N'asghar2@gmail.com', N'asghar', NULL, NULL, NULL, NULL, N'09', 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (6, N'test', N'mryas81@yahoo.com', N'test', NULL, NULL, NULL, NULL, N'22222', 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (7, N'behtash1', N'asghar7@gmail.com', N'behtash', NULL, NULL, NULL, NULL, N'gg', 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (9, N'Maryam', N'blueyas81@yahoo.com', N'Maryam', NULL, NULL, NULL, NULL, N'0423271416', 1, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (10, N'ali', N'sami_bh20001@yahoo.com', N'Ali Soltani', NULL, NULL, NULL, NULL, N'0430311104', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (11, N'ali1', N'sami_bh20009@yahoo.com', N'Ali ', NULL, NULL, NULL, NULL, N'0487634576', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (12, N'ali3', N'sami_bh20003@yahoo.com', N'ali3', 13, N'Romsey', N'Waitara', N'1234', N'0432398756', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (13, N'ali4', N'sami_bh20004@yahoo.com', N'ali4', 13, N'Romsey', N'Waitara', N'9876', N'042312980', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (14, N'ali5', N'sami_bh200012@yahoo.com', N'ali5', 13, N'Leonard', N'Waitara', N'2014', N'0459812345', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (1013, N'ali6', N'sami_bh200014@yahoo.com', N'ali6', 13, N'Romsey', N'Waitara', N'1234', N'0456798712', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (2013, N'ali10', N'sami_bh200015@yahoo.com', N'ali10', 13, N'Romsey', N'Waitara', N'1234', N'0432389712', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (2014, N'ali11', N'sami_bh20040@yahoo.com', N'ali11', 13, N'Romsey', N'Waitara', N'1234', N'12345678', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (2015, N'ali13', N'sami_bh20500@yahoo.com', N'ali13', 13, N'Romsey', N'Waitara', N'1234', N'12345678', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (2016, N'ali16', N'sami_bh22000@yahoo.com', N'ali16', 13, N'sami_bh2000@yahoo.com', N'Romsey', N'1234', N'12345678', 0, NULL)
INSERT [dbo].[UserProfile] ([UserId], [UserName], [EmailAddress], [FullName], [CountryID], [Address1], [Address2], [PostCode], [Phone], [Activated], [ActivationDate]) VALUES (2017, N'ali18', N'sami_bh2000@yahoo.com', N'ali18', 13, N'Romsey', N'Waitara', N'2345', N'12345678', 1, NULL)
SET IDENTITY_INSERT [dbo].[UserProfile] OFF
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (1, CAST(0x0000A36300E6B9B5 AS DateTime), NULL, 1, NULL, 0, N'AHbTeVY6h4cnlZoshThRl0z29El2VNipOMxUWamubJ3BhBtxgWK1CUCUBh98nyGFew==', CAST(0x0000A36300E6B9B5 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (2, CAST(0x0000A36300E96131 AS DateTime), NULL, 1, CAST(0x0000A415000E965E AS DateTime), 2, N'AHbTeVY6h4cnlZoshThRl0z29El2VNipOMxUWamubJ3BhBtxgWK1CUCUBh98nyGFew==', CAST(0x0000A36300E96131 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (3, CAST(0x0000A36300EC0CD9 AS DateTime), NULL, 1, CAST(0x0000A453002C62BC AS DateTime), 0, N'AJ1DbM+c0JbttwOf/1jliwjguKqEQZEmnhXZ2szBzA0MK+VSmbIN+V5OFRlf0gWr7Q==', CAST(0x0000A453002C9173 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (4, CAST(0x0000A36300F0C12C AS DateTime), NULL, 1, NULL, 0, N'AHbTeVY6h4cnlZoshThRl0z29El2VNipOMxUWamubJ3BhBtxgWK1CUCUBh98nyGFew==', CAST(0x0000A36300F0C12C AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (5, CAST(0x0000A36300F24291 AS DateTime), NULL, 1, NULL, 0, N'AHbTeVY6h4cnlZoshThRl0z29El2VNipOMxUWamubJ3BhBtxgWK1CUCUBh98nyGFew==', CAST(0x0000A36300F24291 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (6, CAST(0x0000A36400A07206 AS DateTime), NULL, 1, NULL, 0, N'AAAICp+Op6CikOaNzzln7DC5Hf1q3KctUtU7ZJwwd0ZyaUvx/3N19CCFcNePpIri8g==', CAST(0x0000A36400A07206 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (7, CAST(0x0000A37400E545F8 AS DateTime), NULL, 1, NULL, 0, N'APATiuPEa496/leNWI46x9T71c+ELqEbmkLGBYuQ0Mc38+cYjpn4rl9EvodMz9M7dw==', CAST(0x0000A37400E545F8 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (9, CAST(0x0000A387000C8FA6 AS DateTime), NULL, 1, CAST(0x0000A38E00352189 AS DateTime), 0, N'AHptLWWyJegmZWI34MikmIUJ1SLO8lzv9ozSRJibwDdmRAghlJlX/cx16psZrSGotQ==', CAST(0x0000A387000C8FA6 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (10, CAST(0x0000A43600BF1ED0 AS DateTime), NULL, 1, NULL, 0, N'AN9Om3DeoeNgfOBOYDrzwFlrJiCm48sq/1HEDz8HzYc85BONfJnUzH3Z3D5SpQEiPw==', CAST(0x0000A43600BF1ED0 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (11, CAST(0x0000A437009DCC30 AS DateTime), NULL, 1, NULL, 0, N'AI5GoONH6zz5nkkaj+8ZaSKVjunR/juQMyQz1P6MxYjHYDF7xUApEUOCV9ncsHzTDw==', CAST(0x0000A437009DCC30 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (12, CAST(0x0000A43900078C1A AS DateTime), NULL, 1, NULL, 0, N'ABo7QzpcHsJRQSb3X9pbXDoliyivnSIpDcPr74CjMqF7rkaBr9afc6y2lmfJ4I0gMw==', CAST(0x0000A43900078C1A AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (13, CAST(0x0000A439000BD86A AS DateTime), NULL, 1, NULL, 0, N'AJ5Jmf85hG+DvoxUzCKtitYSdgwOBqZjgGPll8l4T95Q3IQuw0xVznKIJ7YEwN6CCQ==', CAST(0x0000A439000BD86A AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (14, CAST(0x0000A4390048F3EF AS DateTime), NULL, 1, NULL, 0, N'AJug+/h2n99iQxXl0qLeU4DsEmnc01pyQQTlKRs6gFbqK6aVBQ7vrT75JEmLvmnR2w==', CAST(0x0000A4390048F3EF AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (1013, CAST(0x0000A439009A821C AS DateTime), NULL, 1, NULL, 0, N'ANHv4b6Vz4qQzaNEpljhzMC7jn2DzKAoSjvJz5f+nEKLVHkXRYXigYiMndUpUZb9VQ==', CAST(0x0000A439009A821C AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (2013, CAST(0x0000A43B00A9B6FB AS DateTime), NULL, 1, NULL, 0, N'AGViTO1utVdlQJ10+7PXlSX59etQ+pjhRLG0nLEeGl8P3H+oGlX9SbxvTDptEbVy6Q==', CAST(0x0000A43B00A9B6FB AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (2014, CAST(0x0000A43B00AB505A AS DateTime), NULL, 1, NULL, 0, N'ADJhFu+IkM3TMRvGzMsYllX+EtCR4TyehYuJwu0lXkJeToBmgH9ci7JKusda27X7CQ==', CAST(0x0000A43B00AB505A AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (2015, CAST(0x0000A43B00AF67E5 AS DateTime), NULL, 1, NULL, 0, N'AOZdsG/N3l3Bc4mK49L37cR3II3q+rIyac9p8haCMgcQS1MlAmZLfC8MDDM7ALWA+Q==', CAST(0x0000A43B00AF67E5 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (2016, CAST(0x0000A43B00B134E1 AS DateTime), NULL, 1, NULL, 0, N'AKIC482JfxC2f4v1FYjV1rsDdMfw+3CL+H0vKXIv/42rDa1JItwwmFKFi3j/H49K/w==', CAST(0x0000A43B00B134E1 AS DateTime), N'', NULL, NULL)
INSERT [dbo].[webpages_Membership] ([UserId], [CreateDate], [ConfirmationToken], [IsConfirmed], [LastPasswordFailureDate], [PasswordFailuresSinceLastSuccess], [Password], [PasswordChangedDate], [PasswordSalt], [PasswordVerificationToken], [PasswordVerificationTokenExpirationDate]) VALUES (2017, CAST(0x0000A43B00BF4850 AS DateTime), NULL, 1, CAST(0x0000A43B00C3D7B1 AS DateTime), 0, N'AF4CPFAs77bwrWTJyu2U1FIT7AgCZ1aRTewKI2vzL6SgTLGxb6xQXcDNfqcO4JsNXA==', CAST(0x0000A43B00CC6B5C AS DateTime), N'', NULL, NULL)
SET IDENTITY_INSERT [dbo].[webpages_Roles] ON 

INSERT [dbo].[webpages_Roles] ([RoleId], [RoleName]) VALUES (1, N'Admin')
INSERT [dbo].[webpages_Roles] ([RoleId], [RoleName]) VALUES (2, N'Sales')
SET IDENTITY_INSERT [dbo].[webpages_Roles] OFF
INSERT [dbo].[webpages_UsersInRoles] ([UserId], [RoleId]) VALUES (1, 1)
SET IDENTITY_INSERT [dbo].[WishList] ON 

INSERT [dbo].[WishList] ([WishListID], [AdvertizementID], [UserID]) VALUES (7, 2, 7)
INSERT [dbo].[WishList] ([WishListID], [AdvertizementID], [UserID]) VALUES (8, 3, 3)
INSERT [dbo].[WishList] ([WishListID], [AdvertizementID], [UserID]) VALUES (9, 6, 3)
INSERT [dbo].[WishList] ([WishListID], [AdvertizementID], [UserID]) VALUES (10, 8, 3)
INSERT [dbo].[WishList] ([WishListID], [AdvertizementID], [UserID]) VALUES (11, 10, 7)
INSERT [dbo].[WishList] ([WishListID], [AdvertizementID], [UserID]) VALUES (12, 14, 3)
INSERT [dbo].[WishList] ([WishListID], [AdvertizementID], [UserID]) VALUES (15, 26, 3)
SET IDENTITY_INSERT [dbo].[WishList] OFF
/****** Object:  Index [UK_Property]    Script Date: 12/04/2015 9:16:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UK_Property] ON [dbo].[Property]
(
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserProfile]    Script Date: 12/04/2015 9:16:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserProfile] ON [dbo].[UserProfile]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserProfile_UniqueEmail]    Script Date: 12/04/2015 9:16:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserProfile_UniqueEmail] ON [dbo].[UserProfile]
(
	[EmailAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__webpages__8A2B61605E042A84]    Script Date: 12/04/2015 9:16:37 PM ******/
ALTER TABLE [dbo].[webpages_Roles] ADD UNIQUE NONCLUSTERED 
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Advertisement] ADD  CONSTRAINT [DF_Advertisement_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ProductGroupProperty] ADD  CONSTRAINT [DF_ProductGroupProperty_IsMandatory]  DEFAULT ((1)) FOR [IsMandatory]
GO
ALTER TABLE [dbo].[webpages_Membership] ADD  DEFAULT ((0)) FOR [IsConfirmed]
GO
ALTER TABLE [dbo].[webpages_Membership] ADD  DEFAULT ((0)) FOR [PasswordFailuresSinceLastSuccess]
GO
ALTER TABLE [dbo].[Advertisement]  WITH CHECK ADD  CONSTRAINT [FK_Advertizement_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Advertisement] CHECK CONSTRAINT [FK_Advertizement_Product]
GO
ALTER TABLE [dbo].[NotificationAudit]  WITH CHECK ADD  CONSTRAINT [FK_NotificationAudit_EmailConfiguration] FOREIGN KEY([NotificationConfigurationID])
REFERENCES [dbo].[NotificationTemplate] ([NotificationTemplateID])
GO
ALTER TABLE [dbo].[NotificationAudit] CHECK CONSTRAINT [FK_NotificationAudit_EmailConfiguration]
GO
ALTER TABLE [dbo].[NotificationTemplate]  WITH CHECK ADD  CONSTRAINT [FK_NotificationConfiguration_EmailType] FOREIGN KEY([NotificationTypeID])
REFERENCES [dbo].[NotificationType] ([NotificationTypeID])
GO
ALTER TABLE [dbo].[NotificationTemplate] CHECK CONSTRAINT [FK_NotificationConfiguration_EmailType]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductGroup] FOREIGN KEY([ProductGroupID])
REFERENCES [dbo].[ProductGroup] ([ProductGroupID])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ProductGroup]
GO
ALTER TABLE [dbo].[ProductGroupProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductGroupProperty_ProductGroup] FOREIGN KEY([ProductGroupID])
REFERENCES [dbo].[ProductGroup] ([ProductGroupID])
GO
ALTER TABLE [dbo].[ProductGroupProperty] CHECK CONSTRAINT [FK_ProductGroupProperty_ProductGroup]
GO
ALTER TABLE [dbo].[ProductGroupProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductGroupProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[ProductGroupProperty] CHECK CONSTRAINT [FK_ProductGroupProperty_Property]
GO
ALTER TABLE [dbo].[ProductImage]  WITH CHECK ADD  CONSTRAINT [FK_ProductImage_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductImage] CHECK CONSTRAINT [FK_ProductImage_Product]
GO
ALTER TABLE [dbo].[ProductProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductProperty_Product1] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductProperty] CHECK CONSTRAINT [FK_ProductProperty_Product1]
GO
ALTER TABLE [dbo].[ProductProperty]  WITH CHECK ADD  CONSTRAINT [FK_ProductProperty_ProductGroupProperty] FOREIGN KEY([ProductGroupPropertyID])
REFERENCES [dbo].[ProductGroupProperty] ([ProductGroupPropertyID])
GO
ALTER TABLE [dbo].[ProductProperty] CHECK CONSTRAINT [FK_ProductProperty_ProductGroupProperty]
GO
ALTER TABLE [dbo].[UserProfile]  WITH CHECK ADD  CONSTRAINT [FK_UserProfile_Country] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[UserProfile] CHECK CONSTRAINT [FK_UserProfile_Country]
GO
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[webpages_Roles] ([RoleId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_RoleId]
GO
ALTER TABLE [dbo].[webpages_UsersInRoles]  WITH CHECK ADD  CONSTRAINT [fk_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserProfile] ([UserId])
GO
ALTER TABLE [dbo].[webpages_UsersInRoles] CHECK CONSTRAINT [fk_UserId]
GO
ALTER TABLE [dbo].[WishList]  WITH CHECK ADD  CONSTRAINT [FK_WishList_Advertisement] FOREIGN KEY([AdvertizementID])
REFERENCES [dbo].[Advertisement] ([AdvertisementID])
GO
ALTER TABLE [dbo].[WishList] CHECK CONSTRAINT [FK_WishList_Advertisement]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [CK_ControlType] CHECK  (([ControlType]='Image' OR [ControlType]='RadioButton' OR [ControlType]='CheckBox' OR [ControlType]='DropDown' OR [ControlType]='TextArea' OR [ControlType]='TextBox'))
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [CK_ControlType]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [CK_DataType] CHECK  (([DataType]='Image' OR [DataType]='Lookup' OR [DataType]='bool' OR [DataType]='String'))
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [CK_DataType]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [CK_ValidLookupType] CHECK  (([lookupType] IS NULL OR [dbo].[IsValidLookupType]([lookupType])=(1)))
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [CK_ValidLookupType]
GO
USE [master]
GO
ALTER DATABASE [OziBazaar] SET  READ_WRITE 
GO
