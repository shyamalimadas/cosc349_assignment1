-- Sample data for demonstration
INSERT INTO todos (title, description, completed, priority, due_date) VALUES
('Complete COSC349 Assignment', 'Build a multi-VM application using Vagrant', false, 'high', '2025-09-08'),
('Learn Vagrant', 'Study Vagrant fundamentals and multi-VM setup', true, 'medium', '2025-08-30'),
('Setup Database VM', 'Configure MySQL on separate virtual machine', true, 'high', '2025-08-25'),
('Build REST API', 'Create Node.js API server for todo operations', true, 'medium', '2025-08-28'),
('Implement Frontend', 'Create React frontend with responsive design', false, 'medium', '2025-09-05'),
('Write Documentation', 'Document the VM architecture and setup process', false, 'high', '2025-09-07'),
('Test Multi-VM Communication', 'Verify all VMs can communicate properly', false, 'high', '2025-09-06'),
('Deploy Application', 'Ensure application works after vagrant up', false, 'medium', '2025-09-08'),
('Create Screen Recording', 'Record 2-minute demo of the application', false, 'medium', '2025-09-08'),
('Review Code Quality', 'Check code style and add comments where needed', false, 'low', '2025-09-07');

-- Sample users for future extension
INSERT INTO users (username, email) VALUES
('demo_user', 'demo@example.com'),
('student', 'student@otago.ac.nz');