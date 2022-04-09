select comparaja.products.id, comparaja.products.provider_id, comparaja.products.data, comparaja.products.is_sponsored, comparaja.verticals.code
from comparaja.products 
inner join comparaja.verticals on comparaja.products.vertical_id = comparaja.verticals.id 
where comparaja.verticals.code ='BB';

SELECT *
from comparaja.products inner join comparaja.verticals on comparaja.products.vertical_id = comparaja.verticals.id
inner join comparaja.providers on comparaja.providers.id = comparaja.products.provider_id
where comparaja.verticals.code = 'BB' and comparaja.providers.is_active = TRUE;

 SELECT comparaja.products.id, 
 substring_index(substring_index(substring_index (comparaja.products.data, ',', 1), ' ', -1), ':', '-1') as p,
 substring_index(substring_index(substring_index (comparaja.products.data, ',', 2), ' ', -1), ':', '-1') as internet_download_speed_in_mbs, 
 substring_index(substring_index(substring_index (comparaja.products.data, ',', 3), ' ', -1), ':', '-1') as internet_upload_speed_in_mbs, 
 substring_index(substring_index(substring_index (comparaja.products.data, ',', 4), ' ', -1), ':', '-1') as tv_channels, 
 substring_index(substring_index(substring_index (comparaja.products.data, ',', 5), ' ', -1), ':', '-1') as mobile_phone_count, 
 substring_index(substring_index(substring_index (comparaja.products.data, ',', 6), ' ', -1), ':', '-1') as mobile_phone_data_in_gbps, 
 substring_index(replace(substring_index(substring_index (comparaja.products.data, ',', 7), ' ', -1), '\n}', ''), ':', -1) as price
from comparaja.products inner join comparaja.verticals on comparaja.products.vertical_id = comparaja.verticals.id
inner join comparaja.providers on comparaja.providers.id = comparaja.products.provider_iFilterd
where comparaja.verticals.code = 'BB' and comparaja.providers.is_active = TRUE;

select comparaja.data_products.*, comparaja.products.is_sponsored 
from comparaja.data_products inner join comparaja.products on comparaja.data_products.id = comparaja.products.id
where comparaja.data_products.mobile_phone_count > 2;
