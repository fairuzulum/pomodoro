import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomotime/views/login_page.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../controllers/pomodoro_controller.dart'; // Import the PomodoroController

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Adjust X and Y position for the FloatingActionButton
    final double fabXPosition = scaffoldGeometry.scaffoldSize.width *
        0.70; // Move slightly to the left (reduce the value for more movement to the left)
    final double fabYPosition = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        60.0; // Move upwards (reduce the value for more upward movement)
    return Offset(fabXPosition, fabYPosition);
  }
}

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
        floatingActionButton: Obx(() => Container(
              width: 80, // Adjust width to make the background larger
              height: 80, // Adjust height to make the background larger
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3FA2F6), // Background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5), // Optional shadow for depth
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: Colors
                    .transparent, // Make the actual button transparent so only background shows
                elevation: 0, // Remove additional elevation
                shape: CircleBorder(),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    selectedIndex.value == 1
                        ? Icons.check
                        : (controller.isRunning.value
                            ? Icons.pause
                            : Icons.play_arrow),
                    key: ValueKey<int>(selectedIndex.value == 1
                        ? 1
                        : (controller.isRunning.value ? 2 : 3)),
                    size: 36, // Keep icon size the same
                    color: Colors.white, // Icon color
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
              ),
            )),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(),

        // Bottom Navigation Bar with custom image background
        //   bottomNavigationBar: Container(
        //     height: 100, // Adjust the height as necessary
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //         image: AssetImage('assets/buttom.png'), // Path to your image
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //     // child: Obx(() => StylishBottomBar(
        //     //   backgroundColor: Colors.transparent, // Set to transparent to show the image background
        //     //   option: DotBarOptions(
        //     //     dotStyle: DotStyle.tile,
        //     //     gradient: const LinearGradient(
        //     //       colors: [
        //     //         Color(0xFF3FA2F6), // Primary color applied here
        //     //         Color(0xFF3FA2F6), // Primary color applied here
        //     //       ],
        //     //       begin: Alignment.topLeft,
        //     //       end: Alignment.bottomRight,
        //     //     ),
        //     //   ),
        //     //   items: [
        //     //     BottomBarItem(
        //     //       icon: Icon(Icons.home_outlined,
        //     //           color: Color(0xFF3FA2F6).withOpacity(0.6)), // Outline icon
        //     //       title: Icon(Icons.home, color: Color(0xFF3FA2F6)), // Primary color
        //     //       backgroundColor: Color(0xFF3FA2F6), // Primary color
        //     //     ),
        //     //     BottomBarItem(
        //     //       icon: Icon(Icons.settings_outlined,
        //     //           color: Color(0xFF3FA2F6).withOpacity(0.6)), // Outline icon
        //     //       title: Icon(Icons.settings, color: Color(0xFF3FA2F6)), // Primary color
        //     //       backgroundColor: Color(0xFF3FA2F6), // Primary color
        //     //     ),
        //     //   ],
        //     //   fabLocation: StylishBarFabLocation.end,
        //     //   hasNotch: true,
        //     //   currentIndex: selectedIndex.value,
        //     //   onTap: (index) {
        //     //     selectedIndex.value = index;
        //     //   },
        //     // )),

        //   ),
        // );

        bottomNavigationBar: Container(
          height: 100, // Sesuaikan dengan kebutuhan
          child: Stack(
            children: [
              // Background image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/buttom.png'), // Path to your image
                    fit: BoxFit
                        .cover, // Menutupi seluruh area sesuai dengan gambar
                  ),
                ),
              ),
              // Icons on top of the background
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Mulai dari kiri
                  children: [
                    Spacer(
                        flex:
                            1), // Memberikan ruang di awal untuk menggeser semuanya ke kiri
                    Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                selectedIndex.value == 0
                                    ? Icons
                                        .home // Jika terpilih, tampilkan ikon filled
                                    : Icons
                                        .home_outlined, // Jika tidak, tampilkan ikon outline
                                color:
                                    Color(0xFF3FA2F6), // Warna biru untuk ikon
                              ), // Jika tidak, warna abu-abu
                              onPressed: () {
                                selectedIndex.value =
                                    0; // Ubah index menjadi 0 saat tombol Home ditekan
                              },
                            ),
                            // Indicator below the Home icon
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: selectedIndex.value == 0
                                  ? 4
                                  : 0, // Show when selected
                              width: 10, // Adjust width as needed
                              color: Color(0xFF3FA2F6), // Primary color
                            ),
                          ],
                        )),
                    Spacer(
                        flex: 3), // Memberikan jarak antara home dan settings
                    Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                selectedIndex.value == 1
                                    ? Icons
                                        .settings // Jika terpilih, tampilkan ikon filled
                                    : Icons
                                        .settings_outlined, // Jika tidak, tampilkan ikon outline
                                color:
                                    Color(0xFF3FA2F6), // Warna biru untuk ikon
                              ),
                              onPressed: () {
                                selectedIndex.value =
                                    1; // Ubah index menjadi 1 saat tombol Settings ditekan
                              },
                            ),
                            // Indicator below the Settings icon
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: selectedIndex.value == 1
                                  ? 4
                                  : 0, // Show when selected
                              width: 10, // Adjust width as needed
                              color: Color(0xFF3FA2F6), // Primary color
                            ),
                          ],
                        )),
                    Spacer(flex: 6), // Menambah lebih banyak ruang di kanan
                  ],
                ),
              ),
            ],
          ),
        ));
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white), // Warna progress bar putih
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
                        color: Colors.white
                            .withOpacity(0.8), // Warna putih agak transparan
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Dropdowns for Pomodoro, Short Break, and Long Break
                  _buildTimeDropdown(
                      "pomodoro", "Pomodoro", controller.pomodoroTime),
                  _buildTimeDropdown(
                      "short break", "Short Break", controller.shortBreakTime),
                  _buildTimeDropdown(
                      "long break", "Long Break", controller.longBreakTime),
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
                            color: Colors.white
                                .withOpacity(1), // Warna lingkaran putih
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
                color: Colors.white
                    .withOpacity(0.9), // Background putih dengan transparansi
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
                              color: Color(
                                  0xFF3FA2F6), // Warna biru untuk teks dropdown
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
                  color: isSelected
                      ? Color(0xFF3FA2F6)
                      : Colors.grey, // Primary color applied
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
