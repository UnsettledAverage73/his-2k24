import sys
import subprocess
from pathlib import Path
from PySide6.QtCore import *
from PySide6.QtWidgets import *
from improved_ui4 import Ui_MainWindow  
import logging
import datetime
import reporting
import traceback

def setup_logging():
    # Ensure logs directory exists
    logs_dir = Path("logs")
    logs_dir.mkdir(exist_ok=True)
    
    # Create log filename with timestamp
    log_filename = logs_dir / f"{datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.log"
    
    # Configure logging
    logging.basicConfig(
        filename=log_filename, 
        level=logging.INFO, 
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    return log_filename

class ScriptExecutorApp(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        
        self.log_file_path = setup_logging()
        logging.info(f"Log file created: {self.log_file_path}")

        self.populate_tree()

        self.execute_button.clicked.connect(self.execute_selected_scripts)
        self.exit_button.clicked.connect(self.close)

        self.complete_check_button.clicked.connect(self.run_complete_check_scripts)
        self.complete_fix_button.clicked.connect(lambda: self.run_scripts_by_keyword("rem"))

        self.reset_ui_state()

    def reset_ui_state(self):
        """Reset UI to a clean state before running scripts."""
        self.output_display.clear()
        self.status_list.clear()

    def populate_tree(self):
        """Populate the QTreeWidget with directory structure."""
        base_dir = self.get_base_directory()
        if not base_dir.exists():
            self.output_display.setText(f"Error: Directory '{base_dir}' not found.")
            return

        self.treeWidget.clear()
        root_item = QTreeWidgetItem(self.treeWidget)
        root_item.setText(0, base_dir.name)
        root_item.setData(0, Qt.UserRole, str(base_dir))
        self.add_items_to_tree(root_item, base_dir)
        self.treeWidget.expandAll()

        self.treeWidget.setSelectionMode(QAbstractItemView.MultiSelection)

    def get_base_directory(self):
        """Return the base directory for scripts (can be customized)."""
        return Path("../rhel/v9")

    def add_items_to_tree(self, parent_item, path):
        """Recursively add items to the tree."""
        for item in sorted(path.iterdir()):
            tree_item = QTreeWidgetItem(parent_item)
            tree_item.setText(0, item.name)
            tree_item.setData(0, Qt.UserRole, str(item))  
            if item.is_dir():
                self.add_items_to_tree(tree_item, item)  

    def run_complete_check_scripts(self):
        """Run complete check scripts and generate a consolidated report."""
        try:
            # Reset UI before running scripts
            self.reset_ui_state()
            
            # Get scripts with 'chk' in their name
            scripts = self.get_scripts_by_name("chk")
            
            if not scripts:
                self.output_display.append("No check scripts found.")
                return

            # Collect results for consolidated reporting
            all_results = []
            
            # Execute scripts
            for script in scripts:
                try:
                    output = self.execute_single_script(script)
                    status = 'PASS' if 'FAIL' not in output else 'FAIL'
                    
                    result = {
                        "script": script.name, 
                        "status": status, 
                        "output": output, 
                        "serial_number": len(all_results) + 1
                    }
                    all_results.append(result)
                    
                    # Update UI
                    self.output_display.append(f"{script.name}: {status}")
                    self.status_list.addItem(f"{script.name}: {status}")
                    
                except Exception as script_error:
                    error_result = {
                        "script": script.name,
                        "status": "ERROR",
                        "output": str(script_error),
                        "serial_number": len(all_results) + 1
                    }
                    all_results.append(error_result)
            
            # Generate consolidated report for failed scripts
            failed_results = [result for result in all_results if result['status'] != 'PASS']
            if failed_results:
                reporting.generate_report(failed_results, self.output_display)
            else:
                self.output_display.append("All check scripts passed successfully.")
        
        except Exception as e:
            error_msg = f"Error in complete check: {str(e)}"
            self.output_display.append(error_msg)
            logging.error(error_msg)
            logging.error(traceback.format_exc())

    def execute_single_script(self, script_path):
        """Execute a single script and return its output."""
        try:
            if script_path.suffix == ".sh":
                command = ["bash", str(script_path)]
            else:  # .ps1
                command = ["powershell", "-ExecutionPolicy", "Bypass", "-File", str(script_path)]
            
            result = subprocess.run(command, text=True, capture_output=True, check=True)
            return result.stdout
        except subprocess.CalledProcessError as e:
            return f"Error executing {script_path.name}:\n{e.stderr}\n{e.stdout}"
        except Exception as e:
            return f"Unexpected error executing {script_path.name}: {str(e)}"

    def execute_selected_scripts(self):
        """Execute the selected scripts or scripts from selected folders."""
        try:
            # Reset UI before running scripts
            self.reset_ui_state()

            selected_items = self.treeWidget.selectedItems()
            if not selected_items:
                self.output_display.setText("Error: No script or folder selected.")
                return

            scripts_to_execute = []
            for item in selected_items:
                path = Path(item.data(0, Qt.UserRole))
                if path.is_dir():
                    scripts_to_execute.extend(self.get_scripts_in_folder(path))
                elif path.is_file() and path.suffix in {".sh", ".ps1"}:
                    scripts_to_execute.append(path)

            if not scripts_to_execute:
                self.output_display.setText("Error: No valid scripts selected.")
                return

            all_results = []
            for script in scripts_to_execute:
                output = self.execute_single_script(script)
                status = 'PASS' if 'FAIL' not in output else 'FAIL'
                
                result = {
                    "script": script.name, 
                    "status": status, 
                    "output": output, 
                    "serial_number": len(all_results) + 1
                }
                all_results.append(result)
                
                # Update UI
                self.output_display.append(f"{script.name}: {status}")
                self.status_list.addItem(f"{script.name}: {status}")
            
            # Generate report for failed scripts
            failed_results = [result for result in all_results if result['status'] != 'PASS']
            if failed_results:
                reporting.generate_report(failed_results, self.output_display)
        
        except Exception as e:
            error_msg = f"Error executing scripts: {str(e)}"
            self.output_display.append(error_msg)
            logging.error(error_msg)
            logging.error(traceback.format_exc())

    def get_scripts_in_folder(self, folder_path):
        """Return all scripts within a folder, recursively."""
        scripts = []
        for item in folder_path.rglob('*'):
            if item.is_file() and item.suffix in {".sh", ".ps1"}:
                scripts.append(item)
        return scripts

    def run_scripts_by_keyword(self, keyword):
        """Run scripts that contain a specific keyword in their name."""
        try:
            # Reset UI before running scripts
            self.reset_ui_state()
            
            scripts = self.get_scripts_by_name(keyword)
            if scripts:
                all_results = []
                for script in scripts:
                    output = self.execute_single_script(script)
                    status = 'PASS' if 'FAIL' not in output else 'FAIL'
                    
                    result = {
                        "script": script.name, 
                        "status": status, 
                        "output": output, 
                        "serial_number": len(all_results) + 1
                    }
                    all_results.append(result)
                    
                    # Update UI
                    self.output_display.append(f"{script.name}: {status}")
                    self.status_list.addItem(f"{script.name}: {status}")
                
                # Generate report for failed scripts
                failed_results = [result for result in all_results if result['status'] != 'PASS']
                if failed_results:
                    reporting.generate_report(failed_results, self.output_display)
                else:
                    self.output_display.append(f"All scripts with '{keyword}' passed successfully.")
            else:
                self.output_display.append(f"No scripts found for '{keyword}'.")
        
        except Exception as e:
            error_msg = f"Error running scripts with keyword '{keyword}': {str(e)}"
            self.output_display.append(error_msg)
            logging.error(error_msg)
            logging.error(traceback.format_exc())

    def get_scripts_by_name(self, filter_text):
        """Get all scripts that contain the filter_text in their filename."""
        base_dir = self.get_base_directory()
        scripts = []

        if base_dir.exists():
            for item in base_dir.rglob('*'):
                if item.is_file() and filter_text in item.name:
                    scripts.append(item)
        return scripts


class ScriptWorker(QThread):
    """Worker thread to run scripts in the background."""
    finished = Signal()

    def __init__(self, script_path):
        super().__init__()
        self.script_path = script_path
        self.result = ("", script_path)

    def run(self):
        """Run the script and capture its output."""
        try:
            if self.script_path.suffix == ".sh":
                command = ["bash", str(self.script_path)]
            else:  # .ps1
                command = ["powershell", "-ExecutionPolicy", "Bypass", "-File", str(self.script_path)]
            
            result = subprocess.run(command, text=True, capture_output=True, check=True)
            self.result = (result.stdout, self.script_path)
        except subprocess.CalledProcessError as e:
            error_output = f"Error executing {self.script_path.name}:\n{e.stderr}\n{e.stdout}"
            self.result = (error_output, self.script_path)
        except Exception as e:
            error_output = f"Unexpected error executing {self.script_path.name}: {str(e)}"
            self.result = (error_output, self.script_path)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = ScriptExecutorApp()
    window.show()
    sys.exit(app.exec())
