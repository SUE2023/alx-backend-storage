-- Lists all bands with Glam rock as their main style, ranked by their longevity
SELECT band_name,
       RANK() OVER (ORDER BY (IFNULL(split, 2022) - formed) DESC) AS lifespan
FROM metal_bands
WHERE FIND_IN_SET('Glam rock', style) > 0;
