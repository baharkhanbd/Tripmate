/* 
3️⃣ Folder Mapping (Figma → Flutter)

lib/
├── core/
│   ├── constants/   // Colors, Strings
│   ├── widgets/     // Buttons, Cards, Loading
│   └── utils/       // Validators, Helpers
├── config/
│   └── app_config.dart
├── controllers/     // Provider + MVC logic
├── models/          // Data models (Student, Teacher, Message)
├── services/        // ApiService / Dio
├── views/
│   ├── auth/        // Login / Signup
│   ├── student/     // Student module pages
│   └── teacher/     // Teacher module pages
├── routes/          // AppRoutes.dart
└── main.dart


1️⃣ Figma থেকে assets & design নেয়ার ধাপ


Step 1: Screens এবং components চিহ্নিত করো

তোমার Figma file এ কোন screen আছে দেখো:

Login / SignUp

Student Home, ClassRoom, Challenge, Message, Profile

Teacher Home, Classes, Profile, Message

প্রতিটা screen কে Flutter page হিসেবে ভাবো।

Step 2: Colors & Typography

Figma থেকে primary color, secondary color, background color নাও → এগুলো core/constants/colors.dart এ রাখো।

Font size, weight, style → TextStyle হিসেবে centralized করে রাখো।

Step 3: Images & Icons

Figma images export করো (PNG, SVG) → Flutter project এর assets/images/ folder এ রাখো।

Icons যদি vector হয় → flutter_svg package ব্যবহার করা ভালো।

Reusable icons & buttons centralized widgets এ রাখো।

2️⃣ Component/Widget Mapping

Figma এ যেসব UI elements আছে, সেগুলো Flutter widgets এ map করো:

Figma Component	Flutter Widget	Notes
Button	CustomButton	Colors & size centralized
Card	CardWidget	For class/challenge/question
TextField	TextFormField + validator	Form input
List / Table	ListView.builder	Dynamic data
Chat bubble	Custom widget	MessageType অনুযায়ী styling

4️⃣ Step 4: Build UI from Figma

Start small: প্রথমে Login page build করো।

Use Reusable Widgets: Button, Card, Loading, TextField centralized করা।

Layout: Figma এর spacing, padding, margin অনুযায়ী Padding, SizedBox, Column, Row, Stack ব্যবহার করো।

Fonts: Figma typography অনুযায়ী TextStyle apply করো।


5️⃣ Step 5: Connect UI with Provider / Controller

Form input → Controller → API call

API response → Controller → UI update

Example:

Student Home Page → fetch class & challenge → StudentController → ListView.builder → CardWidget

Extra Tips

Figma এ component reuse আছে → Flutter এও widgets reusable রাখো।

Assets নাম logical রাখো: assets/images/logo.png, assets/icons/chat.svg।

Constant values (padding, margin, colors) centralized রাখলে future update সহজ।

প্রথমে static UI build করো, পরে Provider + API connect করো।
*/