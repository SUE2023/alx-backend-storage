-- Creates a stored procedure AddBonus that adds a new correction for a student
DELIMITER //

CREATE PROCEDURE AddBonus (
    IN user_id INT,
    IN project_name VARCHAR(255),
    IN score FLOAT
)
BEGIN
    DECLARE project_id INT;

    -- Check if the project exists
    SELECT id INTO project_id
    FROM projects
    WHERE name = project_name;

    -- If the project does not exist, insert it and get the new project ID
    IF project_id IS NULL THEN
        INSERT INTO projects(name)
            VALUES(project_name);

        -- Retrieve the ID of the newly inserted project
        SELECT LAST_INSERT_ID() INTO project_id;
    END IF;

    -- Insert the correction record
    INSERT INTO corrections(user_id, project_id, score)
        VALUES (user_id, project_id, score);
END //

DELIMITER ;
