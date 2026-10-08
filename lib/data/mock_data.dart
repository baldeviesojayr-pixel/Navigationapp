import '../models/notice.dart';
import '../models/student.dart';

const mockStudents = <Student>[
  Student(
    id: 's1',
    name: 'Olivia Rhye',
    rollNumber: 'STU-2024-001',
    grade: 'Grade 10',
    contact: 'olivia.rhye@email.com',
  ),
  Student(
    id: 's2',
    name: 'Phoenix Baker',
    rollNumber: 'STU-2024-002',
    grade: 'Grade 9',
    contact: 'phoenix.baker@email.com',
  ),
  Student(
    id: 's3',
    name: 'Lana Steiner',
    rollNumber: 'STU-2024-003',
    grade: 'Grade 11',
    contact: 'lana.steiner@email.com',
  ),
  Student(
    id: 's4',
    name: 'Demi Wilkinson',
    rollNumber: 'STU-2024-004',
    grade: 'Grade 10',
    contact: 'demi.wilkinson@email.com',
  ),
  Student(
    id: 's5',
    name: 'Candice Wu',
    rollNumber: 'STU-2024-005',
    grade: 'Grade 8',
    contact: 'candice.wu@email.com',
  ),
  Student(
    id: 's6',
    name: 'Natali Craig',
    rollNumber: 'STU-2024-006',
    grade: 'Grade 12',
    contact: 'natali.craig@email.com',
  ),
  Student(
    id: 's7',
    name: 'Drew Cano',
    rollNumber: 'STU-2024-007',
    grade: 'Grade 9',
    contact: 'drew.cano@email.com',
  ),
  Student(
    id: 's8',
    name: 'Orlando Diggs',
    rollNumber: 'STU-2024-008',
    grade: 'Grade 11',
    contact: 'orlando.diggs@email.com',
  ),
];

const mockNotices = <Notice>[
  Notice(
    title: 'Midterm examinations begin',
    description:
        'Exams start Monday, October 14. Please check the updated timetable.',
    category: 'Exams',
    date: 'Oct 14, 2024',
    icon: 'school',
  ),
  Notice(
    title: 'Parent–teacher meetings',
    description:
        'Meet with teachers to discuss student progress and goals this term.',
    category: 'Events',
    date: 'Oct 18, 2024',
    icon: 'groups',
  ),
  Notice(
    title: 'Science fair registration',
    description:
        'Sign up your team with the science department by the end of this week.',
    category: 'Activities',
    date: 'Oct 22, 2024',
    icon: 'science',
  ),
  Notice(
    title: 'Library hours update',
    description:
        'The library will stay open until 6:00 PM during exam preparation week.',
    category: 'General',
    date: 'Oct 24, 2024',
    icon: 'menu_book',
  ),
];
