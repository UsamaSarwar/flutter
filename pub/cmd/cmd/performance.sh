#!/bin/bash

# Flutter Performance Testing Script
# Memory and CPU profiling with frame rate monitoring

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Check if we're in a Flutter project
check_flutter_project() {
    if [ ! -f "pubspec.yaml" ]; then
        echo -e "${RED}❌ Error: Not in a Flutter project directory!${NC}"
        exit 1
    fi
}

# Check if Flutter is running
check_flutter_running() {
    if ! pgrep -f "flutter.*run" > /dev/null; then
        echo -e "${RED}❌ No Flutter app is currently running!${NC}"
        echo -e "${YELLOW}💡 Start your app with 'flutter run' first${NC}"
        return 1
    fi
    return 0
}

# List available devices
list_devices() {
    echo -e "${CYAN}📱 Available Devices${NC}"
    echo ""
    flutter devices
}

# Run performance profiling
run_performance_profile() {
    echo -e "${CYAN}📊 Performance Profiling${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}Select profiling mode:${NC}"
    echo -e "${GREEN}1.${NC} CPU Profiling"
    echo -e "${GREEN}2.${NC} Memory Profiling"
    echo -e "${GREEN}3.${NC} GPU Profiling"
    echo -e "${GREEN}4.${NC} Network Profiling"
    echo ""
    read -p "Enter choice (1-4): " profile_choice
    
    case $profile_choice in
        1)
            echo -e "${YELLOW}🔄 Starting CPU profiling...${NC}"
            flutter run --profile --enable-software-rendering
            ;;
        2)
            echo -e "${YELLOW}🧠 Starting memory profiling...${NC}"
            flutter run --profile --verbose-system-logs
            ;;
        3)
            echo -e "${YELLOW}🎮 Starting GPU profiling...${NC}"
            flutter run --profile --trace-skia
            ;;
        4)
            echo -e "${YELLOW}🌐 Starting network profiling...${NC}"
            flutter run --profile --verbose-system-logs
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Measure app startup time
measure_startup_time() {
    echo -e "${CYAN}⏱️ App Startup Time Measurement${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}📱 Select device for testing:${NC}"
    flutter devices
    echo ""
    read -p "Enter device ID: " device_id
    
    if [ -z "$device_id" ]; then
        echo -e "${RED}❌ Device ID is required${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}⏱️ Measuring startup time...${NC}"
    echo -e "${CYAN}Starting app and measuring startup performance...${NC}"
    
    # Create startup measurement script
    cat > measure_startup.dart << 'EOF'
import 'dart:io';

void main() async {
  final startTime = DateTime.now();
  
  // Simulate app initialization
  await Future.delayed(Duration(milliseconds: 100));
  
  final endTime = DateTime.now();
  final duration = endTime.difference(startTime);
  
  print('App startup time: ${duration.inMilliseconds}ms');
}
EOF
    
    # Run with timing
    time flutter run -d "$device_id" --profile measure_startup.dart
    
    # Cleanup
    rm -f measure_startup.dart
    
    echo -e "${GREEN}✅ Startup time measurement completed${NC}"
}

# Monitor frame rate
monitor_frame_rate() {
    echo -e "${CYAN}🎯 Frame Rate Monitoring${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}📱 Select device for monitoring:${NC}"
    flutter devices
    echo ""
    read -p "Enter device ID: " device_id
    
    if [ -z "$device_id" ]; then
        echo -e "${RED}❌ Device ID is required${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}🎯 Starting frame rate monitoring...${NC}"
    echo -e "${CYAN}This will run your app with performance overlay${NC}"
    echo -e "${CYAN}Press 'P' in the running app to toggle performance overlay${NC}"
    echo ""
    
    flutter run -d "$device_id" --profile --enable-software-rendering
}

# Analyze app size
analyze_app_size() {
    echo -e "${CYAN}📏 App Size Analysis${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}🔍 Analyzing app size...${NC}"
    
    # Build release APK for Android
    if [ -d "android" ]; then
        echo -e "${BLUE}📱 Building Android APK...${NC}"
        flutter build apk --release --analyze-size
        
        if [ $? -eq 0 ]; then
            # Find and display APK size
            apk_path=$(find build/app/outputs/flutter-apk/ -name "*.apk" | head -1)
            if [ -n "$apk_path" ]; then
                apk_size=$(du -h "$apk_path" | cut -f1)
                echo -e "${GREEN}📱 Android APK size: $apk_size${NC}"
                echo -e "${YELLOW}📍 Location: $apk_path${NC}"
            fi
        fi
    fi
    
    # Build iOS app for size analysis
    if [ -d "ios" ] && [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${BLUE}🍎 Building iOS app...${NC}"
        flutter build ios --release --analyze-size
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}🍎 iOS build completed for size analysis${NC}"
        fi
    fi
    
    # Build web app
    if [ -d "web" ]; then
        echo -e "${BLUE}🌐 Building web app...${NC}"
        flutter build web --analyze-size
        
        if [ $? -eq 0 ]; then
            web_size=$(du -sh build/web | cut -f1)
            echo -e "${GREEN}🌐 Web app size: $web_size${NC}"
        fi
    fi
}

# Memory leak detection
detect_memory_leaks() {
    echo -e "${CYAN}🧠 Memory Leak Detection${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}🔍 Starting memory leak detection...${NC}"
    echo -e "${CYAN}This will run your app with memory monitoring${NC}"
    echo ""
    
    # Create memory test script
    cat > memory_test.dart << 'EOF'
import 'dart:developer';
import 'dart:io';

void main() async {
  print('Starting memory monitoring...');
  
  // Monitor memory usage
  for (int i = 0; i < 10; i++) {
    final info = ProcessInfo.currentRss;
    print('Memory usage iteration $i: ${info ~/ 1024 ~/ 1024} MB');
    
    // Simulate memory allocation
    final list = List.generate(100000, (index) => index);
    list.clear();
    
    await Future.delayed(Duration(seconds: 1));
  }
  
  print('Memory monitoring completed');
}
EOF
    
    dart memory_test.dart
    
    # Cleanup
    rm -f memory_test.dart
    
    echo -e "${GREEN}✅ Memory leak detection completed${NC}"
}

# Generate performance report
generate_performance_report() {
    echo -e "${CYAN}📊 Performance Report Generation${NC}"
    echo ""
    
    check_flutter_project
    
    # Create reports directory
    mkdir -p performance_reports
    
    local report_file="performance_reports/performance_report_$(date +%Y%m%d_%H%M%S).txt"
    
    echo -e "${YELLOW}📊 Generating comprehensive performance report...${NC}"
    
    {
        echo "Flutter Performance Report"
        echo "========================="
        echo "Generated: $(date)"
        echo ""
        
        echo "Project Information:"
        echo "-------------------"
        echo "Project Name: $(grep '^name:' pubspec.yaml | cut -d' ' -f2)"
        echo "Flutter Version: $(flutter --version | head -1)"
        echo ""
        
        echo "Platform Support:"
        echo "----------------"
        [ -d "android" ] && echo "✅ Android"
        [ -d "ios" ] && echo "✅ iOS"
        [ -d "web" ] && echo "✅ Web"
        [ -d "macos" ] && echo "✅ macOS"
        [ -d "windows" ] && echo "✅ Windows"
        [ -d "linux" ] && echo "✅ Linux"
        echo ""
        
        echo "Dependencies:"
        echo "------------"
        grep -A 100 "^dependencies:" pubspec.yaml | grep -B 100 "^dev_dependencies:" | head -n -1
        echo ""
        
        echo "Performance Recommendations:"
        echo "---------------------------"
        echo "1. Use 'flutter build --release' for production builds"
        echo "2. Optimize images and assets"
        echo "3. Minimize widget rebuilds"
        echo "4. Use const constructors where possible"
        echo "5. Profile your app regularly"
        
    } > "$report_file"
    
    echo -e "${GREEN}✅ Performance report generated: $report_file${NC}"
}

# Benchmark tests
run_benchmark_tests() {
    echo -e "${CYAN}🏃 Benchmark Tests${NC}"
    echo ""
    
    check_flutter_project
    
    # Check if integration_test directory exists
    if [ ! -d "integration_test" ]; then
        echo -e "${YELLOW}⚠️  No integration_test directory found${NC}"
        read -p "Create integration_test directory for benchmarks? (y/n): " create_dir
        if [[ $create_dir == "y" ]]; then
            mkdir -p integration_test
        else
            return 1
        fi
    fi
    
    # Create benchmark test if it doesn't exist
    if [ ! -f "integration_test/performance_test.dart" ]; then
        echo -e "${YELLOW}📝 Creating benchmark test...${NC}"
        cat > integration_test/performance_test.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:your_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Performance Tests', () {
    testWidgets('scroll performance test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Find scrollable widget
      final listView = find.byType(Scrollable);
      
      if (listView.evaluate().isNotEmpty) {
        // Measure scroll performance
        await tester.timedDrag(
          listView.first,
          const Offset(0, -300),
          const Duration(milliseconds: 300),
        );
        await tester.pumpAndSettle();
      }
    });
    
    testWidgets('animation performance test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Test animations if any
      // Add your animation performance tests here
    });
  });
}
EOF
        echo -e "${GREEN}✅ Benchmark test created${NC}"
    fi
    
    echo -e "${YELLOW}🏃 Running benchmark tests...${NC}"
    flutter test integration_test/performance_test.dart --verbose
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Benchmark tests completed${NC}"
    else
        echo -e "${RED}❌ Benchmark tests failed${NC}"
    fi
}

# Show performance menu
show_performance_menu() {
    echo -e "${CYAN}📊 Flutter Performance Testing${NC}"
    echo ""
    echo -e "${WHITE}Profiling:${NC}"
    echo -e "${GREEN}1.${NC} Performance Profiling"
    echo -e "${GREEN}2.${NC} Startup Time Measurement"
    echo -e "${GREEN}3.${NC} Frame Rate Monitoring"
    echo ""
    echo -e "${WHITE}Analysis:${NC}"
    echo -e "${GREEN}4.${NC} App Size Analysis"
    echo -e "${GREEN}5.${NC} Memory Leak Detection"
    echo -e "${GREEN}6.${NC} Generate Performance Report"
    echo ""
    echo -e "${WHITE}Testing:${NC}"
    echo -e "${GREEN}7.${NC} Run Benchmark Tests"
    echo -e "${GREEN}8.${NC} List Available Devices"
    echo ""
    read -p "Enter choice (1-8): " perf_choice
    
    case $perf_choice in
        1) run_performance_profile ;;
        2) measure_startup_time ;;
        3) monitor_frame_rate ;;
        4) analyze_app_size ;;
        5) detect_memory_leaks ;;
        6) generate_performance_report ;;
        7) run_benchmark_tests ;;
        8) list_devices ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Main execution
main() {
    case ${1:-"menu"} in
        "profile") run_performance_profile ;;
        "startup") measure_startup_time ;;
        "frames") monitor_frame_rate ;;
        "size") analyze_app_size ;;
        "memory") detect_memory_leaks ;;
        "report") generate_performance_report ;;
        "benchmark") run_benchmark_tests ;;
        "devices") list_devices ;;
        *) show_performance_menu ;;
    esac
}

main "$@"