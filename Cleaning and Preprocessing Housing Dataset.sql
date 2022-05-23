select *
from SQLDataExploration.dbo.HousingDataset

select SaleDate ,CONVERT(date,SaleDate) as date
from SQLDataExploration..HousingDataset

update HousingDataset
set SaleDate= CONVERT(date,SaleDate)

select * 
from SQLDataExploration.dbo.HousingDataset

--alter table HousingDataset
--add saledateconverted date;

update HousingDataset
set saledateconverted= CONVERT(date,SaleDate)

select *
from SQLDataExploration..HousingDataset

--Handling null values in Property Address


select *
from SQLDataExploration..HousingDataset
where PropertyAddress is null
order by ParcelID

select *
from SQLDataExploration..HousingDataset
order by ParcelID

select *
from SQLDataExploration..HousingDataset a
join SQLDataExploration..HousingDataset b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from SQLDataExploration..HousingDataset a
join SQLDataExploration..HousingDataset b
on 
  a.ParcelID=b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select *
from SQLDataExploration..HousingDataset

--Breaking address into address, city and state

select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as City
from SQLDataExploration..HousingDataset

alter table HousingDataset
add propAddress nvarchar(255);
 
update HousingDataset
set propAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table HousingDataset
add propCity Nvarchar(255);

update HousingDataset
set propCity=substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) 

select *
from HousingDataset


select 
PARSENAME(replace(OwnerAddress,',','.'),3) ,
PARSENAME(replace(OwnerAddress,',','.'),2) ,
PARSENAME(replace(OwnerAddress,',','.'),1)
from HousingDataset




alter table HousingDataset
add ownerAdd Nvarchar(255);

update HousingDataset
set ownerAdd=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table HousingDataset
add ownerCity Nvarchar(255);

update HousingDataset
set ownerCity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table HousingDataset
add ownerState Nvarchar(255);

update HousingDataset
set ownerState=PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from HousingDataset

--converting y and n to yes and no in 'sold as vacant'  column

select distinct(SoldAsVacant)
from HousingDataset

select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
    when SoldAsVacant='N' then 'No'
	else SoldAsVacant 
	end
from HousingDataset

update HousingDataset
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
    when SoldAsVacant='N' then 'No'
	else SoldAsVacant 
	end

select * 
from HousingDataset



--remove duplicates
with RowNumCTE as (
select *, 
    ROW_NUMBER() over (
	partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by ParcelID
	)row_num
from HousingDataset
)
delete 
from RowNumCTE
where row_num>1



