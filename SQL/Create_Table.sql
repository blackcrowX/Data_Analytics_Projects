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
)