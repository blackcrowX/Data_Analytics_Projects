DROP TABLE IF EXISTS nashville_housing;
CREATE TABLE nashville_housing(
	UniqueID INT,
	ParcelID VARCHAR(255),
	LandUse	VARCHAR(255),
	PropertyAddress	VARCHAR(255),
	SaleDate DATE,
	SalePrice VARCHAR(255),
	LegalReference VARCHAR(255),
	SoldAsVacant VARCHAR(255),
	OwnerName VARCHAR(255),
	OwnerAddress VARCHAR(255),
	Acreage NUMERIC,
	TaxDistrict VARCHAR(255),
	LandValue INT,
	BuildingValue NUMERIC,
	TotalValue INT,
	YearBuilt INT,
	Bedrooms INT,
	FullBath INT,
	HalfBath INT
);

-- Cleaning Data in SQL Queries --

SELECT *
FROM nashville_housing;


-- Standardise Date Format --

ALTER TABLE nashville_housing
ADD saledate_converted DATE;

UPDATE nashville_housing
SET saledate_converted = CAST(saledate AS date);


-- Populate Property Address data --

SELECT *
FROM nashville_housing
--WHERE propertyadress IS null
ORDER BY parcelid;

SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, 
COALESCE (a.propertyaddress,b.propertyaddress) AS propertyadress_filled
FROM nashville_housing a
JOIN nashville_housing b
	ON a.parcelid = b.parcelid
	AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS null;

UPDATE nashville_housing
SET propertyaddress = COALESCE (a.propertyaddress,b.propertyaddress)
From nashville_housing a
JOIN nashville_housing b
	ON a.parcelid = b.parcelid
	AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS null;


-- Breaking out Property Address into Individual Columns (Address, City)

SELECT propertyaddress
FROM nashville_housing
--ORDER BY parcelid
;

SELECT
SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1 ) AS address,
SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) + 1 , LENGTH(propertyaddress)) AS city
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD propertyaddress_converted varchar(255);

UPDATE nashville_housing
SET propertyaddress_converted = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress) -1 );

ALTER TABLE nashville_housing
ADD propertycity_converted varchar(255);

UPDATE nashville_housing
SET propertycity_converted = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) + 1 , LENGTH(propertyaddress));

SELECT *
FROM nashville_housing;


-- Breaking out Owner Address into Individual Columns (Address, City, State)

SELECT owneraddress
FROM nashville_housing;

SELECT
SPLIT_PART(TRANSLATE(owneraddress::text, ',', '.'), '.', 3),
SPLIT_PART(TRANSLATE(owneraddress::text, ',', '.'), '.', 2),
SPLIT_PART(TRANSLATE(owneraddress::text, ',', '.'), '.', 1)
FROM nashville_housing

ALTER TABLE nashville_housing
ADD owneraddress_converted varchar(255);

UPDATE nashville_housing
SET owneraddress_converted = SPLIT_PART(TRANSLATE(owneraddress::text, ',', '.'), '.', 3);

ALTER TABLE nashville_housing
ADD ownercity_converted varchar(255);

UPDATE nashville_housing
SET ownercity_converted = SPLIT_PART(TRANSLATE(owneraddress::text, ',', '.'), '.', 2);

ALTER TABLE nashville_housing
ADD ownerstate_converted varchar(255);

UPDATE nashville_housing
SET ownerstate_converted = SPLIT_PART(TRANSLATE(owneraddress::text, ',', '.'), '.', 1);

SELECT *
FROM nashville_housing;


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(soldasvacant), COUNT(soldasvacant)
FROM nashville_housing
GROUP BY soldasvacant
ORDER BY 2;

SELECT soldasvacant,
CASE WHEN soldasvacant = 'Y' THEN 'Yes'
	 WHEN soldasvacant = 'N' THEN 'No'
	 ELSE soldasvacant
	 END
FROM nashville_housing;

UPDATE nashville_housing
SET soldasvacant = CASE 
		WHEN soldasvacant = 'Y' THEN 'Yes'
	    WHEN soldasvacant = 'N' THEN 'No'
	    ELSE soldasvacant
	    END;


-- Remove Duplicates

Select *
FROM nashville_housing
ORDER BY propertyaddress;

SELECT *,
	ROW_NUMBER() OVER ( PARTITION BY ParcelID,
									 PropertyAddress,
									 SalePrice,
									 SaleDate,
									 LegalReference
	ORDER BY UniqueID) AS row_num
	FROM nashville_housing;

DELETE FROM nashville_housing
WHERE UniqueID IN (SELECT UniqueID
	FROM
	(SELECT *,
	ROW_NUMBER() OVER ( PARTITION BY ParcelID,
									 PropertyAddress,
									 SalePrice,
									 SaleDate,
									 LegalReference
	ORDER BY UniqueID) AS row_num
	FROM nashville_housing) t
	WHERE t.row_num > 1);

Select *
From nashville_housing;


-- Delete Unused Columns

SELECT *
FROM nashville_housing;

ALTER TABLE nashville_housing
DROP COLUMN owneraddress,
DROP COLUMN taxdistrict,
DROP COLUMN propertyaddress,
DROP COLUMN saledate;
