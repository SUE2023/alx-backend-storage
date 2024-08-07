--Ranks country origins of bands
SELECT origin,
   RANK() OVER(ORDER BY SUM(fans) DESC) as nb_fans
FROM metal_bands;
