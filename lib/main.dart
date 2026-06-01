import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Main app widget
/// This sets theme and connects to the home page
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // App name shown in device/app switcher
      title: 'Appointment Scheduler',

      // Simple modern theme (Material 3)
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),

      home: const HomePage(),
    );
  }
}

/// Home screen where user selects date and time
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // These variables store user selections
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  /// Opens calendar picker
  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,

      // Default date shown when calendar opens
      initialDate: DateTime.now(),

      // Prevent selecting very old dates
      firstDate: DateTime(2024),

      // Allow selection up to year 2100
      lastDate: DateTime(2100),
    );

    // Save selected date and refresh UI
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  /// Opens clock picker
  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,

      // Default time shown
      initialTime: TimeOfDay.now(),
    );

    // Save selected time and refresh UI
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  /// Convert date to readable text
  String getDateText() {
    if (selectedDate == null) {
      return "No date selected yet";
    }
    return "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
  }

  /// Convert time to readable text
  String getTimeText() {
    if (selectedTime == null) {
      return "No time selected yet";
    }
    return selectedTime!.format(context);
  }

  /// Booking validation + confirmation logic
  void bookAppointment() {
    // Check if user selected a date
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a date first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if user selected a time
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a time first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Combine date + time into one DateTime object
    final selectedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // Prevent booking past date/time
    if (selectedDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You cannot book a past date or time"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success message (booking confirmed)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Appointment booked successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointment Scheduler")),

      body: Padding(
        // Adds spacing around the whole screen (clean UI)
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// DATE SECTION
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    const Text(
                      "Selected Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(getDateText(), style: const TextStyle(fontSize: 18)),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: pickDate,

                      // Button styling (improves UI look)
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),

                      child: const Text("Select Date"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TIME SECTION
            Card(
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

                    const SizedBox(height: 10),

                    Text(getTimeText(), style: const TextStyle(fontSize: 18)),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: pickTime,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),

                      child: const Text("Select Time"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// BOOKING BUTTON (REAL WORLD ACTION)
            ElevatedButton(
              onPressed: bookAppointment,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),

              child: const Text(
                "Book Appointment",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
