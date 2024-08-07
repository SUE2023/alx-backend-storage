--Creates a stored procedure ComputeAverageWeightedScoreForUser
--that computes and store the average weighted score for a student.

DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser (
    IN user_id INT  -- Input parameter: user ID for which the average weighted score is computed
)
BEGIN
    DECLARE total_weighted_score FLOAT DEFAULT 0;  -- Variable to store the total weighted score
    DECLARE total_weight FLOAT DEFAULT 0;          -- Variable to store the total weight

    -- Compute the total weighted score for the user
    SELECT SUM(corrections.score * projects.weight)
        INTO total_weighted_score
        FROM corrections
        INNER JOIN projects
            ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

    -- Compute the total weight for the user
    SELECT SUM(projects.weight)
        INTO total_weight
        FROM corrections
        INNER JOIN projects
            ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

    -- Update the user's average score based on the computed values
    IF total_weight = 0 THEN
        UPDATE users
            SET average_score = 0
            WHERE id = user_id;
    ELSE
        UPDATE users
            SET average_score = total_weighted_score / total_weight
            WHERE id = user_id;
    END IF;
END //

DELIMITER ;

