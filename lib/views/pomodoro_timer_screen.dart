import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomotime/views/login_page.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../controllers/pomodoro_controller.dart'; // Import the PomodoroController

class PomodoroTimerScreen extends StatelessWidget {
  final PomodoroController controller = Get.put(PomodoroController());
  Rx<int> selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context), // Top bar with logo and refresh button
            Expanded(
              child: Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: selectedIndex.value == 1
                        ? _settingsPage(context)
                        : _mainContent(context),
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => StylishBottomBar(
            backgroundColor: Colors.white,
            option: DotBarOptions(
              dotStyle: DotStyle.tile,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3FA2F6), // Primary color applied here
                  Color(0xFF3FA2F6), // Primary color applied here
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            items: [
              BottomBarItem(
                icon: Icon(Icons.home_outlined,
                    color: Color(0xFF3FA2F6).withOpacity(0.6)), // Outline icon
                title: Icon(Icons.home, color: Color(0xFF3FA2F6)), // Primary color
                backgroundColor: Color(0xFF3FA2F6), // Primary color
              ),
              BottomBarItem(
                icon: Icon(Icons.settings_outlined,
                    color: Color(0xFF3FA2F6).withOpacity(0.6)), // Outline icon
                title: Icon(Icons.settings, color: Color(0xFF3FA2F6)), // Primary color
                backgroundColor: Color(0xFF3FA2F6), // Primary color
              ),
            ],
            fabLocation: StylishBarFabLocation.end,
            hasNotch: true,
            currentIndex: selectedIndex.value,
            onTap: (index) {
              selectedIndex.value = index;
            },
          )),
      
      
      floatingActionButton: Obx(() => FloatingActionButton(
            backgroundColor: Color(0xFF3FA2F6),
            shape: CircleBorder(),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                selectedIndex.value == 1
                    ? Icons.check
                    : (controller.isRunning.value ? Icons.pause : Icons.play_arrow),
                key: ValueKey<int>(selectedIndex.value == 1
                    ? 1
                    : (controller.isRunning.value ? 2 : 3)),
                size: 36,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (selectedIndex.value == 1) {
                // Handle save action for settings
                print("Settings saved!");
              } else if (controller.isRunning.value) {
                controller.pauseTimer();
              } else {
                controller.startTimer();
              }
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo (replacing "POMOTIME" text)
          Image.asset(
            'assets/logo2.png', // Path to your logo
            height: 50, // Adjust size according to your need
          ),
          // Refresh button with background
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light grey background
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                size: 32,
                color: Color(0xFF3FA2F6), // Primary color
              ),
              onPressed: controller.resetTimer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimer(context),
        _modeSelectionRow(context),
      ],
    );
  }

  Widget _buildTimer(BuildContext context) {
    return Center(
      child: Obx(
        () => TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: 1.0,
            end: controller.timeInSeconds.value /
                controller.getInitialTime(controller.currentMode.value),
          ),
          duration: Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Lingkaran besar sebagai latar belakang timer
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3FA2F6), // Warna dasar yang diinginkan
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                // Progress indicator (lingkaran putih di dalam)
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 10, // Tebal garis
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Warna progress bar putih
                    backgroundColor: Color(0xFF3FA2F6), // Warna dasar lingkaran
                  ),
                ),
                // Teks waktu di tengah lingkaran
                Text(
                  controller.formattedTime.value,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Warna teks putih agar jelas
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _modeSelectionRow(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildModeButton("short break", "short break", context),
              _buildModeButton("pomodoro", "pomodoro", context),
              _buildModeButton("long break", "long break", context),
            ],
          ),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 4,
                width: 320,
                color: Colors.grey[200],
              ),
              AnimatedAlign(
                duration: Duration(milliseconds: 300),
                alignment: _getAlignmentForMode(controller.currentMode.value),
                child: Container(
                  width: 70,
                  height: 4,
                  color: Color(0xFF3FA2F6), // Primary color
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Updated Settings Page based on the image provided
 Widget _settingsPage(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Card Settings
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300, // Lebar disesuaikan dengan gambar
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xFF3FA2F6), // Warna latar belakang biru
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title "Settings" and close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Garis putih di bawah tulisan "Settings"
                Container(
                  height: 2, // Garis putih tipis di bawah Settings
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.5),
                ),
                SizedBox(height: 15),
                // Subtitle "TIME (MINUTES)" aligned to center
                Center(
                  child: Text(
                    "TIME (MINUTES)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8), // Warna putih agak transparan
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // Dropdowns for Pomodoro, Short Break, and Long Break
                _buildTimeDropdown("pomodoro", "Pomodoro", controller.pomodoroTime),
                _buildTimeDropdown("short break", "Short Break", controller.shortBreakTime),
                _buildTimeDropdown("long break", "Long Break", controller.longBreakTime),
                SizedBox(height: 20), // Space before the bottom line
                // Garis putih tipis di atas lingkaran-lingkaran
                Container(
                  height: 2, // Garis putih tipis
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.5),
                ),
                SizedBox(height: 10), // Space before the dots
                // Three white dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(1), // Warna lingkaran putih
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20), // Space between the card and the logout icon
        // Icon Logout kecil di bawah Card
        IconButton(
          icon: Icon(
            Icons.logout,
            size: 28, // Ukuran icon kecil
            color: Colors.grey, // Warna icon abu-abu
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAll(LoginScreen()); // Navigate back to login screen
          },
        ),
      ],
    ),
  );
}


  Widget _buildTimeDropdown(String label, String text, RxInt timeValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white, // Warna putih untuk teks
            ),
          ),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Background putih dengan transparansi
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<int>(
                dropdownColor: Colors.white,
                underline: SizedBox(),
                value: timeValue.value ~/ 60, // Mengubah dari detik ke menit
                items: List.generate(60, (index) => index + 1)
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3FA2F6), // Warna biru untuk teks dropdown
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  timeValue.value = newValue! * 60; // Mengubah kembali ke detik
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Alignment _getAlignmentForMode(String mode) {
    switch (mode) {
      case "short break":
        return Alignment(-0.83, 0.0);
      case "long break":
        return Alignment(0.85, 0.0);
      default:
        return Alignment(0.02, 0.0);
    }
  }

  Widget _buildModeButton(String mode, String label, BuildContext context) {
    bool isSelected = controller.currentMode.value == mode;
    return GestureDetector(
      onTap: () {
        controller.changeMode(mode);
      },
      child: Column(
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              height: 24,
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: isSelected ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Color(0xFF3FA2F6) : Colors.grey, // Primary color applied
                ),
                child: Text(label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
