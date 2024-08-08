-- creates a stored procedure ComputeAverageWeightedScoreForUsers that computes
-- and store the average weighted score for all students.
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoresForAllUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE current_user_id INT;
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE cur CURSOR FOR
        SELECT id
        FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO current_user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Compute the total weighted score and total weight for the current user
        SELECT SUM(corrections.score * projects.weight)
            INTO total_weighted_score
            FROM corrections
            INNER JOIN projects
                ON corrections.project_id = projects.id
            WHERE corrections.user_id = current_user_id;

        SELECT SUM(projects.weight)
            INTO total_weight
            FROM corrections
            INNER JOIN projects
                ON corrections.project_id = projects.id
            WHERE corrections.user_id = current_user_id;

        -- Update the user's average score
        IF total_weight = 0 THEN
            UPDATE users
                SET average_score = 0
                WHERE id = current_user_id;
        ELSE
            UPDATE users
                SET average_score = total_weighted_score / total_weight
                WHERE id = current_user_id;
        END IF;

    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

