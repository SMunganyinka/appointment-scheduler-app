import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// MAIN APP ENTRY POINT
/// This widget starts the application and sets the theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // This is the name of the application
      // It appears in the task switcher on mobile
      title: 'Appointment Scheduler',

      // Theme configuration (Material 3 for modern UI look)
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),

      // First screen shown when app opens
      home: const HomePage(),
    );
  }
}

/// HOME PAGE (STATEFUL WIDGET)
/// We use StatefulWidget because the UI changes when user selects date/time
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// STATE CLASS
/// This holds all dynamic data (date, time, etc.)
class _HomePageState extends State<HomePage> {
  // Stores selected date from calendar
  DateTime? selectedDate;

  // Stores selected time from clock picker
  TimeOfDay? selectedTime;

  /// FUNCTION: OPEN DATE PICKER
  /// This shows a calendar dialog for user to choose a date
  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,

      // Default date shown when calendar opens
      initialDate: DateTime.now(),

      // User cannot select dates before 2024
      firstDate: DateTime(2024),

      // User can select up to year 2100
      lastDate: DateTime(2100),
    );

    // If user selects a date, update UI
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  /// FUNCTION: OPEN TIME PICKER
  /// This shows a clock dialog for selecting time
  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,

      // Default time shown when clock opens
      initialTime: TimeOfDay.now(),
    );

    // Save selected time and refresh UI
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  /// FUNCTION: FORMAT SELECTED DATE
  /// Converts DateTime into readable text for UI
  String getDateText() {
    if (selectedDate == null) {
      return "No date selected yet";
    }

    return "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
  }

  /// FUNCTION: FORMAT SELECTED TIME
  /// Converts TimeOfDay into readable format
  String getTimeText() {
    if (selectedTime == null) {
      return "No time selected yet";
    }

    return selectedTime!.format(context);
  }

  /// FUNCTION: BOOK APPOINTMENT (VALIDATION + CONFIRMATION)
  /// This checks if user selected valid data before booking
  void bookAppointment() {
    // Step 1: Check if date is selected
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a date first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 2: Check if time is selected
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a time first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 3: Combine date and time into one object
    final selectedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // Step 4: Prevent booking past time
    if (selectedDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You cannot book a past date or time"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Step 5: Success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Appointment booked successfully 🎉"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// APP BAR (TOP SECTION)
      appBar: AppBar(
        title: const Text("Appointment Scheduler"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      /// MAIN BODY
      body: Padding(
        // Adds spacing around entire UI
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// ================= DATE SECTION =================
            Card(
              elevation: 3, // Gives shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    // Section title
                    const Text(
                      "Selected Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Display selected date
                    Text(getDateText(), style: const TextStyle(fontSize: 18)),

                    const SizedBox(height: 12),

                    // Button to open date picker
                    ElevatedButton.icon(
                      onPressed: pickDate,

                      // Icon improves user understanding
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Pick Date"),

                      // Button styling
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= TIME SECTION =================
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    const Text(
                      "Selected Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Display selected time
                    Text(getTimeText(), style: const TextStyle(fontSize: 18)),

                    const SizedBox(height: 12),

                    // Button to open time picker
                    ElevatedButton.icon(
                      onPressed: pickTime,
                      icon: const Icon(Icons.access_time),
                      label: const Text("Select Time"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// ================= BOOK BUTTON =================
            ElevatedButton.icon(
              onPressed: bookAppointment,

              icon: const Icon(Icons.check_circle),
              label: const Text(
                "Book Appointment",
                style: TextStyle(fontSize: 16),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
