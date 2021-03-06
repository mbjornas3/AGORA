--	AGORA - an interactive and web-based argument mapping tool that stimulates reasoning, 
--			reflection, critique, deliberation, and creativity in individual argument construction 
--			and in collaborative or adversarial settings. 
--    Copyright (C) 2011 Georgia Institute of Technology
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU Affero General Public License as
--    published by the Free Software Foundation, either version 3 of the
--    License, or (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU Affero General Public License for more details.
--
--    You should have received a copy of the GNU Affero General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.

USE agora;

INSERT INTO users (is_deleted, firstname, lastname, username, password, email, url, user_level, created_date, last_login) VALUES
	(FALSE, "Joshua", "Justice", "JoshJ", "password", "joshj777@gmail.com", "http://github.com/joshjgt", 9, NOW(), NOW()),
	(FALSE, "George", "Burdell", "GeorgePBurdell", "YellowJackets", "GeorgeP@mailinator.com", "http://en.wikipedia.org/wiki/George_P_Burdell", 9, NOW(), NOW());

INSERT INTO maps (user_id, title, description, lang, created_date, modified_date) VALUES
	((SELECT user_id FROM users WHERE userName="JoshJ"), "Generic", "A basic argument for testing the database layout.", "EN-US", NOW(), NOW()),
	(1, "Second Map", "A pointless circular argument designed solely to fill space", "EN-US", NOW(), NOW()),
	(1, "Babelfish", "Douglas Adams's proof by contradiction of the nonexistence of god.", "EN-US", NOW(), NOW());

INSERT INTO nodes (user_id, map_id, nodetype_id, x_coord, y_coord, created_date, modified_date) VALUES 
	(1,1,1,1,1,NOW(), NOW()), (1,1,1,20,1,NOW(), NOW()), (1,1,3,15,12,NOW(), NOW()), (1,1,1,25,12,NOW(), NOW()), (1,1,3,20,24,NOW(), NOW());

INSERT INTO textboxes (text, user_id, map_id, created_date, modified_date) VALUES 
					("FOO", 1, 1, NOW(), NOW()), ("BAR", 1, 1, NOW(), NOW()), ("BAZ", 1, 1, NOW(), NOW());

INSERT INTO nodetext (node_id, textbox_id, position, created_date, modified_date) VALUES
	(1, 1, 1, NOW(), NOW()),
	(2, 2, 1, NOW(), NOW()),
	(3, 1, 1, NOW(), NOW()), (3, 2, 2, NOW(), NOW()),
	(4, 1, 1, NOW(), NOW()), (4, 3, 2, NOW(), NOW()),
	(5, 3, 1, NOW(), NOW()), (5, 2, 2, NOW(), NOW());
-- This is the following 2-part argument:
--
--     ModusPonens
-- BAR(2)------- FOO(1)
--          |
--          |
--          |        Constructive Syllogism
-- FOO therefore BAR (3)----------- FOO therefore BAZ (4)
--                          |
--                          |
--                          |
--                  BAZ therefore BAR (5)

INSERT INTO connections (map_id, user_id, node_id, type_id, x_coord, y_coord, created_date, modified_date) VALUES
	(1, 1, 2, (SELECT type_id FROM connection_types WHERE conn_name="MPifthen"), 12, 1, NOW(), NOW()),
	(1, 1, 3, (SELECT type_id FROM connection_types WHERE conn_name="CSifthen"), 20, 12, NOW(), NOW());

INSERT INTO sourcenodes (connection_id, node_id, created_date, modified_date) VALUES
	(1,1, NOW(), NOW()), (1,3, NOW(), NOW()), (2, 4, NOW(), NOW()), (2,5, NOW(), NOW());