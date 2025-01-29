from PySide6.QtWidgets import (QWidget, QVBoxLayout, QHBoxLayout, QSplitter,
                             QTreeWidget, QTreeWidgetItem, QPushButton,
                             QTextEdit, QListWidget, QLabel)
from PySide6.QtCore import Qt
from pathlib import Path
import subprocess
import logging

class ScriptExecutorTab(QWidget):
    def __init__(self):
        super().__init__()
        self.setup_ui()
        self.populate_tree()
        
    def setup_ui(self):
        layout = QVBoxLayout(self)
        
        # Create splitter for tree and output
        splitter = QSplitter(Qt.Horizontal)
        
        # Left side - Script tree
        tree_widget = QWidget()
        tree_layout = QVBoxLayout(tree_widget)
        
        self.treeWidget = QTreeWidget()
        self.treeWidget.setHeaderLabel("Scripts")
        tree_layout.addWidget(self.treeWidget)
        
        # Add buttons under tree
        button_layout = QHBoxLayout()
        
        self.execute_button = QPushButton("Execute")
        self.execute_button.clicked.connect(self.execute_selected_scripts)
        button_layout.addWidget(self.execute_button)
        
        self.schedule_button = QPushButton("Schedule")
        self.schedule_button.clicked.connect(self.schedule_script)
        button_layout.addWidget(self.schedule_button)
        
        tree_layout.addLayout(button_layout)
        
        # Right side - Output and status
        output_widget = QWidget()
        output_layout = QVBoxLayout(output_widget)
        
        # Output display
        self.output_display = QTextEdit()
        self.output_display.setReadOnly(True)
        output_layout.addWidget(QLabel("Output:"))
        output_layout.addWidget(self.output_display)
        
        # Status list
        self.status_list = QListWidget()
        output_layout.addWidget(QLabel("Status:"))
        output_layout.addWidget(self.status_list)
        
        # Add widgets to splitter
        splitter.addWidget(tree_widget)
        splitter.addWidget(output_widget)
        
        layout.addWidget(splitter)
        
    def populate_tree(self):
        """Populate the QTreeWidget with directory structure."""
        base_dir = self.get_base_directory()
        if not base_dir.exists():
            self.output_display.setText(f"Error: Directory '{base_dir}' not found.")
            base_dir.mkdir(parents=True, exist_ok=True)
            return
            
        self.treeWidget.clear()
        root_item = QTreeWidgetItem(self.treeWidget)
        root_item.setText(0, base_dir.name)
        root_item.setData(0, Qt.UserRole, str(base_dir))
        self.add_items_to_tree(root_item, base_dir)
        self.treeWidget.expandAll()
        
    def get_base_directory(self):
        """Return the base directory for scripts."""
        return Path("scripts")
        
    def add_items_to_tree(self, parent_item, path):
        """Recursively add items to the tree."""
        try:
            for item in sorted(path.iterdir()):
                tree_item = QTreeWidgetItem(parent_item)
                tree_item.setText(0, item.name)
                tree_item.setData(0, Qt.UserRole, str(item))
                if item.is_dir():
                    self.add_items_to_tree(tree_item, item)
        except Exception as e:
            logging.error(f"Error adding items to tree: {str(e)}")

    def execute_selected_scripts(self):
        """Execute the selected scripts."""
        selected_items = self.treeWidget.selectedItems()
        if not selected_items:
            self.output_display.setText("Error: No script selected.")
            return
            
        self.output_display.clear()
        self.status_list.clear()
        
        for item in selected_items:
            script_path = Path(item.data(0, Qt.UserRole))
            if script_path.is_file():
                try:
                    if script_path.suffix == ".sh":
                        process = subprocess.run(["bash", str(script_path)], 
                                              capture_output=True, text=True)
                    elif script_path.suffix == ".ps1":
                        process = subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", 
                                               "-File", str(script_path)], 
                                              capture_output=True, text=True)
                    else:
                        self.output_display.append(f"Unsupported file type: {script_path}")
                        continue
                        
                    self.output_display.append(f"=== Output for {script_path.name} ===")
                    self.output_display.append(process.stdout)
                    if process.stderr:
                        self.output_display.append("=== Errors ===")
                        self.output_display.append(process.stderr)
                        
                    status = "Success" if process.returncode == 0 else "Failed"
                    self.status_list.addItem(f"{script_path.name}: {status}")
                    
                except Exception as e:
                    error_msg = f"Error executing {script_path.name}: {str(e)}"
                    self.output_display.append(error_msg)
                    self.status_list.addItem(f"{script_path.name}: Error")
                    logging.error(error_msg)
    
    def schedule_script(self):
        """Schedule a script to run at a specific time."""
        self.output_display.append("Scheduling feature coming soon...")
    
    def refresh(self):
        """Refresh the script tree."""
        self.populate_tree()
