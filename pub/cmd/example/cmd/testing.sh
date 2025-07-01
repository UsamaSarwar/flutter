#!/bin/bash

# Flutter Testing & Analysis Script
# Comprehensive testing suite with unit, widget, and integration tests

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

# Check if test directory exists
check_test_directory() {
    if [ ! -d "test" ]; then
        echo -e "${YELLOW}⚠️  No test directory found${NC}"
        read -p "Create test directory? (y/n): " create_test
        if [[ $create_test == "y" ]]; then
            mkdir -p test
            echo -e "${GREEN}✅ Test directory created${NC}"
        else
            echo -e "${RED}❌ Tests require a test directory${NC}"
            exit 1
        fi
    fi
}

# Run unit tests
run_unit_tests() {
    echo -e "${CYAN}🧪 Running Unit Tests${NC}"
    echo ""
    
    check_flutter_project
    
    # Check for unit test files
    unit_tests=$(find test -name "*_test.dart" -not -path "*/integration_test/*" -not -path "*/widget_test/*" 2>/dev/null)
    
    if [ -z "$unit_tests" ]; then
        echo -e "${YELLOW}⚠️  No unit test files found${NC}"
        echo -e "${YELLOW}💡 Unit test files should end with '_test.dart' in the test directory${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}🔍 Found unit test files:${NC}"
    echo "$unit_tests"
    echo ""
    
    echo -e "${YELLOW}🧪 Running unit tests...${NC}"
    flutter test --no-test-assets
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Unit tests completed successfully!${NC}"
    else
        echo -e "${RED}❌ Unit tests failed${NC}"
    fi
}

# Run widget tests
run_widget_tests() {
    echo -e "${CYAN}🎨 Running Widget Tests${NC}"
    echo ""
    
    check_flutter_project
    
    # Look for widget test files (usually widget_test.dart or files with "widget" in name)
    widget_tests=$(find test -name "*widget*test.dart" 2>/dev/null)
    
    if [ -z "$widget_tests" ]; then
        echo -e "${YELLOW}⚠️  No widget test files found${NC}"
        echo -e "${YELLOW}💡 Widget test files typically contain 'widget' in their name${NC}"
        
        # Check for default widget_test.dart
        if [ -f "test/widget_test.dart" ]; then
            echo -e "${GREEN}Found default widget_test.dart${NC}"
            widget_tests="test/widget_test.dart"
        else
            return 1
        fi
    fi
    
    echo -e "${YELLOW}🔍 Found widget test files:${NC}"
    echo "$widget_tests"
    echo ""
    
    echo -e "${YELLOW}🎨 Running widget tests...${NC}"
    flutter test $widget_tests
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Widget tests completed successfully!${NC}"
    else
        echo -e "${RED}❌ Widget tests failed${NC}"
    fi
}

# Run integration tests
run_integration_tests() {
    echo -e "${CYAN}🔗 Running Integration Tests${NC}"
    echo ""
    
    check_flutter_project
    
    # Check for integration test directory
    if [ ! -d "integration_test" ]; then
        echo -e "${YELLOW}⚠️  No integration_test directory found${NC}"
        echo -e "${YELLOW}💡 Create integration_test directory and add test files${NC}"
        return 1
    fi
    
    # Find integration test files
    integration_tests=$(find integration_test -name "*_test.dart" 2>/dev/null)
    
    if [ -z "$integration_tests" ]; then
        echo -e "${YELLOW}⚠️  No integration test files found${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}🔍 Found integration test files:${NC}"
    echo "$integration_tests"
    echo ""
    
    # Check if device is available
    echo -e "${YELLOW}📱 Checking available devices...${NC}"
    flutter devices
    echo ""
    
    read -p "Enter device ID (or press Enter for default): " device_id
    
    if [ -n "$device_id" ]; then
        echo -e "${YELLOW}🔗 Running integration tests on device: $device_id${NC}"
        flutter test integration_test -d "$device_id"
    else
        echo -e "${YELLOW}🔗 Running integration tests...${NC}"
        flutter test integration_test
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Integration tests completed successfully!${NC}"
    else
        echo -e "${RED}❌ Integration tests failed${NC}"
    fi
}

# Run all tests
run_all_tests() {
    echo -e "${CYAN}🧪 Running All Tests${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}🔄 Running comprehensive test suite...${NC}"
    echo ""
    
    # Run unit tests
    echo -e "${BLUE}📝 Phase 1: Unit Tests${NC}"
    run_unit_tests
    echo ""
    
    # Run widget tests
    echo -e "${BLUE}🎨 Phase 2: Widget Tests${NC}"
    run_widget_tests
    echo ""
    
    # Run integration tests
    echo -e "${BLUE}🔗 Phase 3: Integration Tests${NC}"
    run_integration_tests
    echo ""
    
    echo -e "${GREEN}✅ All test phases completed!${NC}"
}

# Run tests with coverage
run_tests_with_coverage() {
    echo -e "${CYAN}📊 Running Tests with Coverage${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}📊 Running tests with coverage analysis...${NC}"
    flutter test --coverage
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Tests with coverage completed!${NC}"
        
        # Check if coverage file was generated
        if [ -f "coverage/lcov.info" ]; then
            echo -e "${YELLOW}📍 Coverage report: coverage/lcov.info${NC}"
            
            # Check if genhtml is available for HTML report
            if command -v genhtml &> /dev/null; then
                echo -e "${YELLOW}📈 Generating HTML coverage report...${NC}"
                genhtml coverage/lcov.info -o coverage/html
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ HTML coverage report generated: coverage/html/index.html${NC}"
                fi
            else
                echo -e "${YELLOW}💡 Install lcov for HTML coverage reports: brew install lcov${NC}"
            fi
        fi
    else
        echo -e "${RED}❌ Tests with coverage failed${NC}"
    fi
}

# Continuous testing with file watching
run_continuous_tests() {
    echo -e "${CYAN}👀 Continuous Testing (Watch Mode)${NC}"
    echo ""
    
    check_flutter_project
    
    echo -e "${YELLOW}Select test type for continuous mode:${NC}"
    echo -e "${GREEN}1.${NC} Unit tests"
    echo -e "${GREEN}2.${NC} Widget tests"
    echo -e "${GREEN}3.${NC} All tests"
    echo ""
    read -p "Enter choice (1-3): " watch_choice
    
    case $watch_choice in
        1)
            echo -e "${YELLOW}👀 Watching for changes - running unit tests...${NC}"
            echo -e "${CYAN}Press Ctrl+C to stop${NC}"
            # Simple file watching implementation
            while true; do
                flutter test --no-test-assets
                echo -e "${YELLOW}⏳ Waiting for file changes...${NC}"
                sleep 5
            done
            ;;
        2)
            echo -e "${YELLOW}👀 Watching for changes - running widget tests...${NC}"
            echo -e "${CYAN}Press Ctrl+C to stop${NC}"
            while true; do
                run_widget_tests
                echo -e "${YELLOW}⏳ Waiting for file changes...${NC}"
                sleep 5
            done
            ;;
        3)
            echo -e "${YELLOW}👀 Watching for changes - running all tests...${NC}"
            echo -e "${CYAN}Press Ctrl+C to stop${NC}"
            while true; do
                flutter test
                echo -e "${YELLOW}⏳ Waiting for file changes...${NC}"
                sleep 10
            done
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Generate test reports
generate_test_report() {
    echo -e "${CYAN}📊 Generating Test Report${NC}"
    echo ""
    
    check_flutter_project
    
    # Create reports directory
    mkdir -p reports
    
    echo -e "${YELLOW}📊 Running tests and generating reports...${NC}"
    
    # Run tests with JSON output
    flutter test --reporter json > reports/test_results.json 2>&1
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Test report generated: reports/test_results.json${NC}"
        
        # Generate coverage if requested
        read -p "Generate coverage report? (y/n): " generate_coverage
        if [[ $generate_coverage == "y" ]]; then
            flutter test --coverage
            if [ -f "coverage/lcov.info" ]; then
                cp coverage/lcov.info reports/
                echo -e "${GREEN}✅ Coverage report copied to reports/lcov.info${NC}"
            fi
        fi
    else
        echo -e "${RED}❌ Test report generation failed${NC}"
    fi
}

# Create test templates
create_test_templates() {
    echo -e "${CYAN}📝 Creating Test Templates${NC}"
    echo ""
    
    check_flutter_project
    check_test_directory
    
    echo -e "${YELLOW}Select template type:${NC}"
    echo -e "${GREEN}1.${NC} Unit test template"
    echo -e "${GREEN}2.${NC} Widget test template"
    echo -e "${GREEN}3.${NC} Integration test template"
    echo ""
    read -p "Enter choice (1-3): " template_choice
    
    case $template_choice in
        1)
            read -p "Enter test file name (without .dart): " test_name
            cat > "test/${test_name}_test.dart" << 'EOF'
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YourClass', () {
    test('should return expected result', () {
      // Arrange
      
      // Act
      
      // Assert
      expect(true, true);
    });
    
    test('should handle edge cases', () {
      // Arrange
      
      // Act
      
      // Assert
      expect(true, true);
    });
  });
}
EOF
            echo -e "${GREEN}✅ Unit test template created: test/${test_name}_test.dart${NC}"
            ;;
        2)
            read -p "Enter widget test file name (without .dart): " widget_name
            cat > "test/${widget_name}_test.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YourWidget', () {
    testWidgets('should display correctly', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(), // Your widget here
          ),
        ),
      );
      
      // Verify the widget appears
      expect(find.byType(Container), findsOneWidget);
    });
    
    testWidgets('should respond to user interaction', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(), // Your widget here
          ),
        ),
      );
      
      // Interact with the widget
      // await tester.tap(find.byType(Button));
      // await tester.pump();
      
      // Verify the result
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
EOF
            echo -e "${GREEN}✅ Widget test template created: test/${widget_name}_test.dart${NC}"
            ;;
        3)
            mkdir -p integration_test
            read -p "Enter integration test file name (without .dart): " integration_name
            cat > "integration_test/${integration_name}_test.dart" << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:your_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    testWidgets('should navigate through app', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Test app navigation and functionality
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Add your integration test steps here
    });
  });
}
EOF
            echo -e "${GREEN}✅ Integration test template created: integration_test/${integration_name}_test.dart${NC}"
            
            # Add integration_test dependency if not present
            if ! grep -q "integration_test:" pubspec.yaml; then
                echo -e "${YELLOW}💡 Adding integration_test dependency to pubspec.yaml${NC}"
                echo "" >> pubspec.yaml
                echo "dev_dependencies:" >> pubspec.yaml
                echo "  integration_test:" >> pubspec.yaml
                echo "    sdk: flutter" >> pubspec.yaml
            fi
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            ;;
    esac
}

# Show testing menu
show_testing_menu() {
    echo -e "${CYAN}🧪 Flutter Testing & Analysis${NC}"
    echo ""
    echo -e "${WHITE}Test Execution:${NC}"
    echo -e "${GREEN}1.${NC} Run Unit Tests"
    echo -e "${GREEN}2.${NC} Run Widget Tests"
    echo -e "${GREEN}3.${NC} Run Integration Tests"
    echo -e "${GREEN}4.${NC} Run All Tests"
    echo -e "${GREEN}5.${NC} Run Tests with Coverage"
    echo ""
    echo -e "${WHITE}Advanced:${NC}"
    echo -e "${GREEN}6.${NC} Continuous Testing (Watch Mode)"
    echo -e "${GREEN}7.${NC} Generate Test Report"
    echo -e "${GREEN}8.${NC} Create Test Templates"
    echo ""
    read -p "Enter choice (1-8): " testing_choice
    
    case $testing_choice in
        1) run_unit_tests ;;
        2) run_widget_tests ;;
        3) run_integration_tests ;;
        4) run_all_tests ;;
        5) run_tests_with_coverage ;;
        6) run_continuous_tests ;;
        7) generate_test_report ;;
        8) create_test_templates ;;
        *) echo -e "${RED}❌ Invalid choice${NC}" ;;
    esac
}

# Main execution
main() {
    case ${1:-"menu"} in
        "unit") run_unit_tests ;;
        "widget") run_widget_tests ;;
        "integration") run_integration_tests ;;
        "all") run_all_tests ;;
        "coverage") run_tests_with_coverage ;;
        "watch") run_continuous_tests ;;
        "report") generate_test_report ;;
        "template") create_test_templates ;;
        *) show_testing_menu ;;
    esac
}

main "$@"