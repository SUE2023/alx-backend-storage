-- Creates a stored procedure AddBonus that adds a new correction for a student
DELIMITER //

CREATE PROCEDURE AddBonus (
    IN user_id INT,           -- User ID for the correction
    IN project_name VARCHAR(255), -- Project name (new or existing)
    IN score FLOAT            -- Score for the correction
)
BEGIN
    DECLARE project_count INT DEFAULT 0; -- Variable to store the count of projects with the given name
    DECLARE project_id INT DEFAULT 0;    -- Variable to store the ID of the project

    -- Check if the project exists
    SELECT COUNT(id)
        INTO project_count
        FROM projects
        WHERE name = project_name;
    
    -- If project does not exist, insert a new one
    IF project_count = 0 THEN
        INSERT INTO projects(name)
            VALUES(project_name);
    END IF;

    -- Retrieve the ID of the project (newly created or existing)
    SELECT id
        INTO project_id
        FROM projects
        WHERE name = project_name;

    -- Insert the correction record
    INSERT INTO corrections(user_id, project_id, score)
        VALUES (user_id, project_id, score);
END //

DELIMITER ;

