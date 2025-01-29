import sys
import subprocess
import psutil
import platform
import logging  # <-- Import the logging module
from datetime import datetime
from pathlib import Path
from PySide6.QtCore import *
from PySide6.QtWidgets import *
from PySide6.QtGui import *
from tabs.system_monitor import SystemMonitorTab
from tabs.script_executor import ScriptExecutorTab
from tabs.backup_manager import BackupManagerTab
from tabs.remote_executor import RemoteExecutorTab
from utils.logging_config import setup_logging

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("System Administrator Tool")
        self.setMinimumSize(1024, 768)
        
        # Setup logging
        self.log_file_path = setup_logging()  # Ensure this sets up logging
        logging.info("Application started")  # Now logging is defined
        
        # Create main widget and layout
        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        main_layout = QVBoxLayout(main_widget)
        
        # Create tab widget
        self.tab_widget = QTabWidget()
        main_layout.addWidget(self.tab_widget)
        
        # Add tabs
        self.script_executor_tab = ScriptExecutorTab()
        self.system_monitor_tab = SystemMonitorTab()
        self.backup_manager_tab = BackupManagerTab()
        self.remote_executor_tab = RemoteExecutorTab()
        
        self.tab_widget.addTab(self.script_executor_tab, "Script Executor")
        self.tab_widget.addTab(self.system_monitor_tab, "System Monitor")
        self.tab_widget.addTab(self.backup_manager_tab, "Backup Manager")
        self.tab_widget.addTab(self.remote_executor_tab, "Remote Executor")
        
        # Create status bar
        self.status_bar = QStatusBar()
        self.setStatusBar(self.status_bar)
        self.update_status_bar()
        
        # Setup timer for status updates
        self.status_timer = QTimer()
        self.status_timer.timeout.connect(self.update_status_bar)
        self.status_timer.start(5000)  # Update every 5 seconds
        
        # Setup menu bar
        self.create_menu_bar()
        
    def create_menu_bar(self):
        menubar = self.menuBar()
        
        # File menu
        file_menu = menubar.addMenu("File")
        
        exit_action = QAction("Exit", self)
        exit_action.setShortcut("Ctrl+Q")
        exit_action.triggered.connect(self.close)
        file_menu.addAction(exit_action)
        
        # Tools menu
        tools_menu = menubar.addMenu("Tools")
        
        refresh_action = QAction("Refresh All", self)
        refresh_action.setShortcut("F5")
        refresh_action.triggered.connect(self.refresh_all)
        tools_menu.addAction(refresh_action)
        
        # Help menu
        help_menu = menubar.addMenu("Help")
        
        about_action = QAction("About", self)
        about_action.triggered.connect(self.show_about)
        help_menu.addAction(about_action)
        
    def update_status_bar(self):
        cpu_usage = psutil.cpu_percent()
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        status_msg = (f"CPU: {cpu_usage}% | "
                     f"Memory: {memory.percent}% | "
                     f"Disk: {disk.percent}% | "
                     f"System: {platform.system()} {platform.release()}")
        
        self.status_bar.showMessage(status_msg)
        
    def refresh_all(self):
        self.script_executor_tab.refresh()
        self.system_monitor_tab.refresh()
        self.backup_manager_tab.refresh()
        self.remote_executor_tab.refresh()
        self.status_bar.showMessage("All tabs refreshed", 3000)
        
    def show_about(self):
        QMessageBox.about(
            self,
            "About System Administrator Tool",
            "System Administrator Tool v1.0\n\n"
            "A comprehensive tool for system administrators\n"
            "Created with PySide6\n\n"
            f"Python {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}\n"
            f"Running on {platform.system()} {platform.release()}"
        )
        
    def closeEvent(self, event):
        reply = QMessageBox.question(
            self,
            'Exit',
            'Are you sure you want to exit?',
            QMessageBox.Yes | QMessageBox.No,
            QMessageBox.No
        )
        
        if reply == QMessageBox.Yes:
            logging.info("Application closed")  # Now logging works
            event.accept()
        else:
            event.ignore()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    
    # Set application style
    app.setStyle("Fusion")
    
    # Set dark theme
    palette = QPalette()
    palette.setColor(QPalette.Window, QColor(53, 53, 53))
    palette.setColor(QPalette.WindowText, Qt.white)
    palette.setColor(QPalette.Base, QColor(25, 25, 25))
    palette.setColor(QPalette.AlternateBase, QColor(53, 53, 53))
    palette.setColor(QPalette.ToolTipBase, Qt.white)
    palette.setColor(QPalette.ToolTipText, Qt.white)
    palette.setColor(QPalette.Text, Qt.white)
    palette.setColor(QPalette.Button, QColor(53, 53, 53))
    palette.setColor(QPalette.ButtonText, Qt.white)
    palette.setColor(QPalette.BrightText, Qt.red)
    palette.setColor(QPalette.Link, QColor(42, 130, 218))
    palette.setColor(QPalette.Highlight, QColor(42, 130, 218))
    palette.setColor(QPalette.HighlightedText, Qt.black)
    app.setPalette(palette)
    
    window = MainWindow()
    window.show()
    sys.exit(app.exec())

